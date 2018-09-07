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