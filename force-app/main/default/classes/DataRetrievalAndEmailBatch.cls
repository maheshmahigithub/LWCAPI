global class DataRetrievalAndEmailBatch implements Database.Batchable<sObject>, Schedulable {
    
    global void execute(SchedulableContext sc) {
        // Instantiate the batch class and start the execution
        DataRetrievalAndEmailBatch batch = new DataRetrievalAndEmailBatch();
        Database.executeBatch(batch);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // Return null as we will make the REST API call directly in the execute method
        return null;
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
       DataRetrievalAndEmail.executeDataRetrievalAndEmail(); 
        
    }
    
    global void finish(Database.BatchableContext BC) {
        // Batch execution finished
    }
}