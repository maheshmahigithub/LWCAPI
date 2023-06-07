trigger CountContactOnAccount on Contact (before Insert, after INSERT, after UPDATE, after DELETE) {
    Set <Id> accountIds = new Set <Id>();
    List <Account> lstAccountsToUpdate = new List <Account>();
    ContactTriggerHandler handler = new ContactTriggerHandler();
     //calling handler only before insert
         if(Trigger.Isbefore && Trigger.isInsert){
             handler.onbeforeinsert(trigger.new);
             system.debug('testing');
         }
         
     if(Trigger.isInsert||Trigger.isUpdate){
         
        for(Contact con:trigger.new){
            accountIds.add(con.accountID);
        }
    }
    if(Trigger.isUpdate|| Trigger.isDelete){
        for(Contact con:trigger.old){
            accountIds.add(con.accountID);
        }
    }
    
    for(Account acc:[SELECT Id,Name,Total_Contacts_Count__c,(Select Id from Contacts) from Account where Id IN: accountIds]){
        Account accObj = new Account ();
        accObj.Id = acc.Id;
        accObj.Total_Contacts_Count__c= acc.Contacts.size();
        lstAccountsToUpdate.add(accObj);
    }
    
    UPDATE lstAccountsToUpdate;

}