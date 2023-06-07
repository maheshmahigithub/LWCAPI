//Source Org Trigger
trigger LeadTrigger on Lead (before insert, after insert, after update, after delete) {
    if(Trigger.isAfter){
        if(Trigger.isInsert || Trigger.isUpdate){
            LeadTriggerHandler.afterInsert(Trigger.newMap);
        }
        if(Trigger.IsDelete){
            LeadTriggerHandler.afterDelete(Trigger.Old);
        }
    }
   
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            LeadTriggerHandler.GenerateUniqueId(Trigger.New);
        }
    }

}