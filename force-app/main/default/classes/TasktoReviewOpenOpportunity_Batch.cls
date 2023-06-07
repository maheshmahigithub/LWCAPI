global class TasktoReviewOpenOpportunity_Batch implements Database.Batchable<sObject> {
    // Get all the Open opportunities in Database.QueryLocator
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id, OwnerId, Owner.IsActive FROM Opportunity where stagename!=\'Closed Won\' and stagename!=\'Closed Lost\' ';
        return Database.getQueryLocator(query);
    }
    
    // Execute the logic for opportunities quried in start method in batches
    global void execute(Database.BatchableContext bc, List<Opportunity> scope) {
        system.debug('execute method executed'+scope);
        system.debug('execute method BatchableContext'+bc);
        List<Task> listOfNewTasks = new List<Task>();
        //User adminUser = [Select Id From User Where Profile.Name = 'System Administrator' LIMIT 1];
        
        for(Opportunity opp : scope) {
            String owner;
            // If the owner is active then set the opportunity owner Id in the "owner" variable else set Admin Id
            if(opp.Owner.IsActive) {
                listOfNewTasks.add(new Task(WhatId = opp.Id,
                                       OwnerId = opp.OwnerId,
                                       Subject = 'Please review the related opne Opportunity.'));
            }
            
        }
        insert listOfNewTasks;
    }
    
    global void finish(Database.BatchableContext bc) {
        
    }

}