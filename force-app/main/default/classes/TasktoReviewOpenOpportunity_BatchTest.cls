@isTest
public class TasktoReviewOpenOpportunity_BatchTest {
    
//private class BatchTasksCreationTest {
    @testSetup
    static void dataSetup() {
        // Create opportunities
        Opportunity op1 = new Opportunity(Name = 'Admin Opp',
                                   StageName = 'Prospecting',
                                   CloseDate = System.today());
        insert op1;
        
        Profile stanProfile = [Select Id From Profile Where Name = 'Standard User'];
        User usr = new User(LastName = 'User12ka4',
                            FirstName = 'Test',
                            Alias = 'tusr',
                            Email = 'test.user12ka4@apexstepbystep.com',
                            Username = 'test.user12ka4@apexstepbystep.com',
                            ProfileId = stanProfile.id,
                            TimeZoneSidKey = 'GMT',
                            LanguageLocaleKey = 'en_US',
                            EmailEncodingKey = 'UTF-8',
                            LocaleSidKey = 'en_US'
                           );
        System.runAs(usr) {
            Opportunity op2 = new Opportunity(Name = 'Standard Opp',
                                   StageName = 'Prospecting',
                                   CloseDate = System.today());
            insert op2;
        }
    }
    
    // Execute the batch class for tasks creation and verify that two tasks should be created
    // 1st for admin opp with admin user
    // 2nd for standard opp with standard user
    @isTest
    static void testMethod1() {
        Opportunity adminOpp = [Select Id, OwnerId, Owner.Name From Opportunity Where Name = 'Admin Opp'];
        Opportunity standOpp = [Select Id, OwnerId, Owner.Name From Opportunity Where Name = 'Standard Opp'];
        system.debug('adminOpp'+adminOpp);
        system.debug('standOpp'+standOpp);
        String CRON_EXP = '0 0 0 ? * * *';
        
        Test.startTest();
            TasktoReviewOpenOpportunities_Schedule abs= new TasktoReviewOpenOpportunities_Schedule();
            String jobId = System.schedule('myJobTestJobName', CRON_EXP, abs);
            abs.execute(null);
        Test.stopTest();
        
        
        // Assert that two tasks should be created 1 for each opportunity
        List<Task> tasks = [Select Id, OwnerId, WhatId From Task];
        System.assertEquals(2, tasks.size(), '2 Tasks should be created.');
        System.assertEquals(1, [Select Id From Task Where WhatId = :adminOpp.Id AND OwnerId = :adminOpp.OwnerId].size(), 'Task is not created for related Opportunity.');
        System.assertEquals(1, [Select Id From Task Where WhatId = :standOpp.Id AND OwnerId = :standOpp.OwnerId].size(), 'Task is not created for related Opportunity.');
    }
    
    
}