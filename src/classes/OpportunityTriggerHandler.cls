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
    public void onBeforeInsert(Map<Id, Opportunity> mapNew) {
    } 
	//
	// On After Insert 
	// 
    public void onAfterInsert(Map<Id, Opportunity> mapNew) {
		calculateRevenueInAccountOnInsert(mapNew);
    }
	//
	// On Before Update 
	//    
    public void onBeforeUpdate(Map<Id, Opportunity> mapOld, Map<Id, Opportunity> mapNew) {
    }
	//
	// On After Update
	//
    public void onAfterUpdate(Map<Id, Opportunity> mapOld, Map<Id, Opportunity> mapNew) {
		calculateRevenueInAccountOnUpdate(mapOld, mapNew);
    }
	//
	// On Before Delete 
	//
    public void onBeforeDelete(Map<Id, Opportunity> mapOld) {
    }
	//
	// On After Delete 
	//
    public void onAfterDelete(Map<Id, Opportunity> mapOld) {
		calculateRevenueInAccountOnDelete(mapOld);
    }
	//
	// On Undelete
	//
    public void onUndelete(Map<Id, Opportunity>  mapNew) {
		calculateRevenueInAccountOnInsert(mapNew);
    }

	private void calculateRevenueInAccountOnInsert(Map<Id, Opportunity> mapNew) {
		List<Id> accIdConnectedOpportunities = new List<Id>();
		Map<Id, Opportunity> opportunityWithConnectedAccountMap = new Map<Id, Opportunity>();

		for (Opportunity newOpp : mapNew.values()) {

			//added app to acc connection
			if (newOpp.AccountId != null && newOpp.ExpectedRevenue != null) {
				accIdConnectedOpportunities.add(newOpp.AccountId);
				opportunityWithConnectedAccountMap.put(newOpp.AccountId, newOpp);
			}
		}

		Map<Id, Account> connected = new Map<Id, Account>([SELECT Id, Revenue_From_Opp__c FROM Account WHERE Id IN:accIdConnectedOpportunities]);
		List<Account> updatedAccounts = new List<Account>();

		for (Account account : connected.values()) {
			Decimal newRevenue = opportunityWithConnectedAccountMap.get(account.Id).ExpectedRevenue;

			System.debug('newRevenue' +newRevenue);

			if (account.Revenue_From_Opp__c == null) {
				account.Revenue_From_Opp__c = 0;
			}

			account.Revenue_From_Opp__c += newRevenue;
			updatedAccounts.add(account);
		}

		if (updatedAccounts.size() > 0) {
			System.debug('***** Updated revenue in accounts ' + updatedAccounts);

			update updatedAccounts;
		}
	}

	private void calculateRevenueInAccountOnUpdate(Map<Id, Opportunity> mapOld, Map<Id, Opportunity> mapNew) {
		List<Id> accIdConnectedOpportunities = new List<Id>();
		Map<Id, Opportunity> opportunityWithConnectedAccountMap = new Map<Id, Opportunity>();

		List<Id> accIdRevenueChange = new List<Id>();
		Map<Id, Opportunity> opportunityMapRevenueChange = new Map<Id, Opportunity>();

		List<Id> acctIdsDisconcertedOpportunities = new List<Id>();
		Map<Id, Opportunity> opportunityWithDisconnectedAccountMap = new Map<Id, Opportunity>();

		for (Opportunity newOpp : mapNew.values()) {

			//added app to acc connection
			if (newOpp.AccountId != null && mapOld.get(newOpp.Id).AccountId == null) {
				System.debug('added new');
				accIdConnectedOpportunities.add(newOpp.AccountId);
				opportunityWithConnectedAccountMap.put(newOpp.AccountId, newOpp);
			//Only change in revenue
			} else if (newOpp.AccountId  != null && mapOld.get(newOpp.Id).AccountId != null) {
				accIdRevenueChange.add(newOpp.AccountId);
				opportunityMapRevenueChange.put(newOpp.AccountId, newOpp);
			//removed app to acc connection
			} else if (newOpp.AccountId == null && mapOld.get(newOpp.Id).AccountId != null) {
				acctIdsDisconcertedOpportunities.add(mapOld.get(newOpp.Id).AccountId);
				opportunityWithDisconnectedAccountMap.put(mapOld.get(newOpp.Id).AccountId, mapOld.get(newOpp.Id));
			}
		}

		System.debug('new' +accIdConnectedOpportunities);

		Map<Id, Account> connected = new Map<Id, Account>([SELECT Id, Revenue_From_Opp__c FROM Account WHERE Id IN:accIdConnectedOpportunities]);
		Map<Id, Account> revenueChange = new Map<Id, Account>([SELECT Id, Revenue_From_Opp__c FROM Account WHERE Id IN:accIdRevenueChange]);
		Map<Id, Account> disconnected = new Map<Id, Account>([SELECT Id, Revenue_From_Opp__c FROM Account WHERE Id IN:acctIdsDisconcertedOpportunities]);

		List<Account> updatedAccounts = new List<Account>();

		System.debug('newAcc' +connected);

		for (Account account : connected.values()) {
			Decimal newRevenue = opportunityWithConnectedAccountMap.get(account.Id).ExpectedRevenue;

			System.debug('newRevenue' +newRevenue);

			if (account.Revenue_From_Opp__c == null) {
				account.Revenue_From_Opp__c = 0;
			}

			account.Revenue_From_Opp__c += newRevenue;
			updatedAccounts.add(account);
		}

		for (Account account : revenueChange.values()) {
			Opportunity oppNew = opportunityMapRevenueChange.get(account.Id);

			Decimal newRevenue = oppNew.ExpectedRevenue;
			Decimal oldRevenue = mapOld.get(oppNew.Id).ExpectedRevenue;

			if (account.Revenue_From_Opp__c == null) {
				account.Revenue_From_Opp__c = 0;
			}

			account.Revenue_From_Opp__c += (newRevenue - oldRevenue);
			updatedAccounts.add(account);
		}

		for (Account account : disconnected.values()) {

			Opportunity oppNew = opportunityWithDisconnectedAccountMap.get(account.Id);

			Decimal oldRevenue = mapOld.get(oppNew.Id).ExpectedRevenue;

			if (account.Revenue_From_Opp__c == null) {
				account.Revenue_From_Opp__c = 0;
			}

			account.Revenue_From_Opp__c -= (oldRevenue);
			updatedAccounts.add(account);
		}

		if (updatedAccounts.size() > 0) {
			System.debug('***** Updated revenue in accounts ' + updatedAccounts);

			update updatedAccounts;
		}
	}

	private void calculateRevenueInAccountOnDelete(Map<Id, Opportunity> mapOld) {
		List<Id> acctIdsDisconcertedOpportunities = new List<Id>();
		Map<Id, Opportunity> opportunityWithDisconnectedAccountMap = new Map<Id, Opportunity>();

		for (Opportunity oldOpp : mapOld.values()) {
			if (mapOld.get(oldOpp.Id).AccountId != null) {
				acctIdsDisconcertedOpportunities.add(mapOld.get(oldOpp.Id).AccountId);
				opportunityWithDisconnectedAccountMap.put(mapOld.get(oldOpp.Id).AccountId, mapOld.get(oldOpp.Id));
			}
		}

		Map<Id, Account> disconnected = new Map<Id, Account>([SELECT Id, Revenue_From_Opp__c FROM Account WHERE Id IN:acctIdsDisconcertedOpportunities]);

		List<Account> updatedAccounts = new List<Account>();

		for (Account account : disconnected.values()) {
			Decimal oldRevenue = opportunityWithDisconnectedAccountMap.get(account.Id).ExpectedRevenue;

			if (account.Revenue_From_Opp__c == null) {
				account.Revenue_From_Opp__c = 0;
			}

			account.Revenue_From_Opp__c -= (oldRevenue);
			updatedAccounts.add(account);
		}

		if (updatedAccounts.size() > 0) {
			System.debug('***** Updated revenue in accounts ' + updatedAccounts);

			update updatedAccounts;
		}
	}
    
}