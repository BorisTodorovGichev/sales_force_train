public class AccountTriggerHandler {
	//
	// custom trigger handler setup to handler all triggers received on account object
	//
    private Boolean myIsExecuting = false;
    private Integer BatchSize = 0;
	//
	// constructor
	//
    public AccountTriggerHandler(Boolean isExecuting, Integer size) {
        myIsExecuting = isExecuting;
        BatchSize = size;
    }
	//
	// On Before Insert
	//
    public void OnBeforeInsert(List<Account> lstNew) {
    }
	//
	// On After Insert
	//
    public void OnAfterInsert(Map<Id, Account> mapNew) {
        sendMailsToManagerIfImportantOnCreate(mapNew);
    }
	//
	// On Before Update
	//
    public void OnBeforeUpdate(Map<Id, Account> mapOld, Map<Id, Account> mapNew) {
		sendMailsToManagerIfImportantOnUpdate(mapOld, mapNew);
    }

	//
	// On After Update
	//
    public void OnAfterUpdate(Map<Id, Account> mapOld, Map<Id, Account> mapNew) {
        updateAccountsContactSites(mapNew);
    }
	//
	// On Before Delete
	//
    public void OnBeforeDelete(Map<Id, Account> mapOld) {
    }
	//
	// On After Delete
	//
    public void OnAfterDelete(Map<Id, Account> mapOld) {
    }
	//
	// On Undelete
	//
    public void OnUndelete(List<Account> lstNew) {
    }


	//
	// Send email to managers if an account becomes important
	//
	public void sendMailsToManagerIfImportantOnUpdate(Map<Id, Account> mapOld, Map<Id, Account> mapNew) {

        List<Account> importantAccounts = new List<Account>();

        for( Account acc : mapOld.values()) {
            Boolean isImportantOld = acc.Important_Account__c;
            Boolean isImportantNew = mapNew.get(acc.Id).Important_Account__c;

            if(isImportantNew == true && isImportantNew != isImportantOld) {
                importantAccounts.add(acc);
                System.debug('************ newly marked important account');
            }
        }

        prepareAndSendMails(importantAccounts);
	}

    //
    // Send email to managers if new important account is created
    //
    public void sendMailsToManagerIfImportantOnCreate(Map<Id, Account> mapNew) {

        List<Account> importantAccounts = new List<Account>();

        for( Account acc : mapNew.values()) {
            if(acc.Important_Account__c == true ) {
                importantAccounts.add(acc);
                System.debug('************ newly created important account');
            }
        }

        prepareAndSendMails(importantAccounts);
    }

    public void prepareAndSendMails(List<Account> importantAccounts) {

        if (importantAccounts.size() > 0) {
            String[]  addresses = new String[]{},
                    subjects = new String[]{},
                    messages = new String[]{};

            List<User> managerUsers = [SELECT Id, Title, Email, FirstName, LastName FROM User WHERE Title = 'manager' ];

            for (User manager : managerUsers) {
                addresses.add(manager.Email);
                subjects.add('New Important account/s');

                String message = 'Those accounts have been marked as important maybe you should check them out:';

                for (Account importantAccount : importantAccounts) {
                    message += '  <a title="Click Here" href="' + importantAccount.Url_Link__c + '">' + importantAccount.Name + '</a>  ';
                }

                messages.add(message);
            }

            EmailManager.sendMail(addresses, subjects, messages);
            System.debug('************ sending mails' + messages);
        }

    }

    public void updateAccountsContactSites(Map<Id, Account> mapNew) {

        Set<Id> myAccIds = mapNew.keySet();

        List<Contact> myLstContacts = [SELECT Id, Name, AccountId, Site_From_Acc__c FROM Contact WHERE AccountId IN :myAccIds];

        List<Contact> contactsForUpdate = new List<Contact>();

        for(Contact con: myLstContacts) {
            if(con.AccountId != null) {
                con.Site_From_Acc__c = mapNew.get(con.AccountId).Site;
                contactsForUpdate.add(con);
            }
        }

        if (contactsForUpdate.size() > 0) {
            System.debug('**************updatingContactsSites' + contactsForUpdate);
            update contactsForUpdate;
        }
    }


}