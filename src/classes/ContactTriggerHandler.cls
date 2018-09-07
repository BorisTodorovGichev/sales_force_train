public class ContactTriggerHandler {
	//
	// custom trigger handler setup to handler all triggers received on contact object
	//
    private boolean myIsExecuting = false;
    private integer BatchSize = 0;
	//
	// constructor
	//
    public ContactTriggerHandler(boolean isExecuting, integer size) {
        myIsExecuting = isExecuting;
        BatchSize = size;
    }
	//
	// On Before Insert 
	//   
    public void OnBeforeInsert(list<Contact> lstNew) { 
    } 
	//
	// On After Insert 
	// 
    public void OnAfterInsert(map<id, Contact> mapNew) {
    }
	//
	// On Before Update 
	//    
    public void OnBeforeUpdate(map<id, Contact> mapOld, map<id, Contact> mapNew) {
    }
	//
	// On After Update
	//
    public void OnAfterUpdate(map<id, Contact> mapOld, map<id, Contact> mapNew) {
    	set<Id> accountIds = new set<Id>();

    	list<Contact> contacts = [Select id, Account_Site__c, AccountId from Contact where id IN:mapOld.keySet()];

    	map<Id, Account> accountMap = new map<Id, Account>();
    	list<Contact> updatedContacts = new list<Contact>();

    	list<Contact> myLstContacts = mapNew.values();

    	for(Contact con: mapNew.values()) {
    		if(con.AccountId != null) {
    			accountIds.add(con.AccountId);
    		}
    	}

    	list<Account> accounts = [Select id, Site from Account where id IN:accountIds];

    	for(Account acc: accounts) {
    		accountMap.put(acc.id, acc);
    	}

    	for(Contact con: contacts) {
    		if(con.AccountId != null ) {
    			con.Account_Site__c = accountMap.get(con.AccountId).Site;
    			updatedContacts.add(con);
    		}
    	}

    	if (updatedContacts.size() > 0) {
    		update updatedContacts;
    	}

    	System.debug('*********accountIDs' + accountIds);
    	System.debug('*********accountMap' + accountMap);
    }
	//
	// On Before Delete 
	//
    public void OnBeforeDelete(map<ID, Contact> mapOld) {
    }
	//
	// On After Delete 
	//
    public void OnAfterDelete(map<ID, Contact> mapOld) {
    }
	//
	// On Undelete
	//
    public void OnUndelete(list<Contact> lstNew) {
    }
    
}