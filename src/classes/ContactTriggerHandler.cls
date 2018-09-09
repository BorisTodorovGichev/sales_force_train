public class ContactTriggerHandler {
	//
	// custom trigger handler setup to handler all triggers received on contact object
	//
    private Boolean myIsExecuting = false;
    private Integer BatchSize = 0;
	//
	// constructor
	//
    public ContactTriggerHandler(Boolean isExecuting, Integer size) {
        myIsExecuting = isExecuting;
        BatchSize = size;
    }
	//
	// On Before Insert 
	//   
    public void OnBeforeInsert(List<Contact> lstNew) {
    } 
	//
	// On After Insert 
	// 
    public void OnAfterInsert(Map<Id, Contact> mapNew) {
    }
	//
	// On Before Update 
	//    
    public void OnBeforeUpdate(Map<Id, Contact> mapOld, Map<Id, Contact> mapNew) {
    }
	//
	// On After Update
	//
    public void OnAfterUpdate(Map<Id, Contact> mapOld, Map<Id, Contact> mapNew) {
    }
	//
	// On Before Delete 
	//
    public void OnBeforeDelete(Map<Id, Contact> mapOld) {
    }
	//
	// On After Delete 
	//
    public void OnAfterDelete(Map<Id, Contact> mapOld) {
    }
	//
	// On Undelete
	//
    public void OnUndelete(List<Contact> lstNew) {
    }
    
}