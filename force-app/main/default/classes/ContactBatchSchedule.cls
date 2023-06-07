global class ContactBatchSchedule implements Database.Batchable<sObject>, Schedulable { 
	global Database.QueryLocator start(Database.BatchableContext BC) {
    	String query = 'SELECT Id, FirstName,LastName,Status__c FROM Contact WHERE CreatedDate = YESTERDAY';
        return Database.getQueryLocator(query);  
    }
    global void execute(Database.BatchableContext BC, List<Contact> lstSobects) {        
        for(Contact cn : lstSobects){
            if(cn.Status__c != 'Ready for Approval'){
                cn.Status__c = 'Ready for Approval';
            }            
        }
        update lstSobects;
    }
    global void finish(Database.BatchableContext BC) {
          
    }
    global void execute(SchedulableContext sc) {
        Type t = Type.forName('ContactBatchSchedule');
        Database.Batchable< sObject > batchClass = ((Database.Batchable< sObject >) t.newInstance());
        Database.executeBatch(batchClass, 200);
        
        List<Contact> conlist = [SELECT Id, FirstName,LastName,Birthdate,Createddate,Is_Active__c,Description FROM Contact WHERE CreatedDate = YESTERDAY];
        string header = 'Record Id, FirstName ,LastName, Birthdate,Createddate, Is_Active__c,Description \n';
        string finalstr = header ;
            for(Contact c: conlist)
            {
                string recordString = '"'+c.id+'","'+c.FirstName+'","'+c.LastName+'","'+c.Birthdate +'","'+c.Createddate +'","'+c.Is_Active__c +'","'+c.Description +'" \n';
                finalstr = finalstr +recordString;
            }
        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
        blob csvBlob = Blob.valueOf(finalstr);
        string csvname= 'Contacts.csv';
        csvAttc.setFileName(csvname);
        csvAttc.setBody(csvBlob);
        Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
        String[] toAddresses = new list<string> {'Mahikumar0169@gmail.com'};
        String subject ='Contacts created yesterday CSV';
        email.setSubject(subject);
        email.setToAddresses( toAddresses );
        email.setPlainTextBody('Contact CSV attached ');
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        system.debug('send email result'+r);
    }
}