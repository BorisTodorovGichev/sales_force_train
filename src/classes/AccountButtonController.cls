public class AccountButtonController {
    public ApexPages.StandardController Controller {get;set;}

    public AccountButtonController(ApexPages.StandardController stdController) {
        Controller = stdController;
    }
    public PageReference startBatch() {
        String myId = ApexPages.currentPage().getParameters().get('id');
        //
        // create a loader class and instantiate it
        // define "query" in loader class
        //
        AccountLoader myLoader = new AccountLoader();
        //
        // set the query string for the SOQL query
        //
        myLoader.query = 'select Id, Site, Website from Account';
        System.debug('**************** myLoader.query: '+myLoader.query);
        //
        // finally, call Database.executeBatch() to start the batch process executing
        // myLoader - instantiation of the batch loader
        // myBatchSize - the number of records to process in each batch
        //
        Integer myBatchSize = 2;
        Id batchprocessid = Database.executeBatch(myLoader,myBatchSize);
        //
        // return the user to the current page where the button was pressed
        //
        PageReference pageRef = new PageReference('/' + myId);
        pageRef.setRedirect(true);
        return pageRef;
    }
}