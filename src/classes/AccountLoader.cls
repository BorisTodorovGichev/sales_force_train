global class AccountLoader implements Database.Batchable<sObject>, Database.Stateful {
    //
    // query string that is set in the ExampleScheduler (and ExampleController if one is created)
    //
    public String query;
    //
    // Database.executeBatch() in ExampleScheduler call this start method
    //
    global database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }
    //
    // execute method is called by database.queryLocater -- the number of executions is the total number of
    // records returned from query divided by the number of records to be done in each batch
    //
    global void execute(Database.BatchableContext BC, List<SObject> scope) {
        List<Account> myLstAccts = scope;
        List<Account> myUpdatedAccounts = new List<Account>();

        for (Account x : myLstAccts) {
            x.Account_Site_2__c = x.Site;
            myUpdatedAccounts.add(x);
        }

        if (myUpdatedAccounts.size()>0) {
            update myUpdatedAccounts;
        }

    }
    //
    // after all batches have been executed, do any final cleanup tasks in this method
    //
    global void finish(Database.BatchableContext BC) {

    }
}