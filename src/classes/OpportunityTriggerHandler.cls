public class OpportunityTriggerHandler {
	//
	// custom trigger handler setup to handler all triggers received on contact object
	//
    private Boolean myIsExecuting = false;
    private Integer BatchSize = 0;
	//
	// constructor
	//
    public OpportunityTriggerHandler(Boolean isExecuting, Integer size) {
        myIsExecuting = isExecuting;
        BatchSize = size;
    }
	//
	// On Before Insert 
	//   
    public void OnBeforeInsert(Map<Id, Opportunity> mapNew) {
    } 
	//
	// On After Insert 
	// 
    public void OnAfterInsert(Map<Id, Opportunity> mapNew) {
    }
	//
	// On Before Update 
	//    
    public void OnBeforeUpdate(Map<Id, Opportunity> mapOld, Map<Id, Opportunity> mapNew) {
    }
	//
	// On After Update
	//
    public void OnAfterUpdate(Map<Id, Opportunity> mapOld, Map<Id, Opportunity> mapNew) {
		List<Id> accIds = new List<Id>();
		Map<Id, Opportunity> opportunityMap = new Map<Id, Opportunity>();

		for (Opportunity opp : mapNew.values()) {
			if (opp.AccountId  != null && opp.ExpectedRevenue != null) {
				accIds.add(opp.AccountId);
				opportunityMap.put(opp.AccountId, opp);
			}
		}

		Map<Id, Account> connectedAccounts = new Map<Id, Account>([SELECT Id, Revenue_From_Opp__c FROM Account WHERE Id IN: accIds]);
		List<Account> updatedAccounts = new List<Account>();

		Boolean needToUpdate = false;

		for (Account account : connectedAccounts.values()) {
			Opportunity oppNew = opportunityMap.get(account.Id);
			Opportunity oppOld = mapOld.get(oppNew.Id);

			if (account.Revenue_From_Opp__c == null) {
				account.Revenue_From_Opp__c = 0;
			}

			account.Revenue_From_Opp__c = account.Revenue_From_Opp__c + (oppNew.ExpectedRevenue - oppOld.ExpectedRevenue);
			updatedAccounts.add(account);
			needToUpdate = true;
		}

		if (needToUpdate) {
			update updatedAccounts;
		}


		System.debug(accIds);
		System.debug(mapNew);
		System.debug(connectedAccounts);
    }
	//
	// On Before Delete 
	//
    public void OnBeforeDelete(Map<Id, Opportunity> mapOld) {
    }
	//
	// On After Delete 
	//
    public void OnAfterDelete(Map<Id, Opportunity> mapOld) {
    }
	//
	// On Undelete
	//
    public void OnUndelete(List<Opportunity> lstNew) {
    }
    
}