trigger OpportunityTrigger on Opportunity (after delete, after insert, after undelete, after update,
        before delete, before insert, before update) {
    OpportunityTriggerHandler handler = new OpportunityTriggerHandler(Trigger.isExecuting, Trigger.size);
    //
    // Before Insert - new record(s) being created
    //
    if(Trigger.isInsert && Trigger.isBefore) {
        handler.onBeforeInsert(Trigger.newMap);
        //
        // After Insert - new record(s) being created
    } else if(Trigger.isInsert && Trigger.isAfter) {
        handler.onAfterInsert(Trigger.newMap);
        //
        // Before Update - existing record(s) being saved
        //
    } else if(Trigger.isUpdate && Trigger.isBefore) {
        handler.onBeforeUpdate(Trigger.oldMap, Trigger.newMap);
        //
        // After Update - existing record(s) being saved
        //
    } else if(Trigger.isUpdate && Trigger.isAfter) {
        handler.onAfterUpdate(Trigger.oldMap, Trigger.newMap);
        //
        // Before Delete - existing record(s) being deleted
        //
    } else if(Trigger.isDelete && Trigger.isBefore) {
        handler.onBeforeDelete(Trigger.oldMap);
        //
        // After Delete - existing record(s) being deleted
        //
    } else if(Trigger.isDelete && Trigger.isAfter) {
        handler.onAfterDelete(Trigger.oldMap);
        //
        // After UnDelete - existing record(s) being undeleted
        //
    } else if(Trigger.isUndelete) {
        handler.onUndelete(Trigger.newMap);
    }
}