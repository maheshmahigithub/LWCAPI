@isTest
public class ContactBatchSchedule_test {
    @testSetup
    static void setup(){
        contact cn = new contact();
        cn.FirstName = 'firstname';
        cn.LastName = 'lastname';
        cn.Birthdate= Date.newInstance(1992, 04, 12);
        cn.Is_Active__c = True;
        cn.Description = 'test description for the contact, testing comma'; 
        insert cn;
        Datetime yesterday = Datetime.now().addDays(-1);
        Test.setCreatedDate(cn.Id, yesterday); 
    }
    @isTest
    static void testMethod1() {
    	String CRON_EXP = '0 0 0 ? * * *';
        
        Test.startTest();
            ContactBatchSchedule abs= new ContactBatchSchedule();
            String jobId = System.schedule('myJobTestJobName', CRON_EXP, abs);
            abs.execute(null);
        Test.stopTest();
    }
}