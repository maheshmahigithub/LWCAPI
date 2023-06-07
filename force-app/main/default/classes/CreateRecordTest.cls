@IsTest
private class CreateRecordTest {
    @IsTest
    static void testCreateAccount() {
        // Prepare test data
        List<CreateRecord.AccountInput> accountInputs = new List<CreateRecord.AccountInput>();
        CreateRecord.AccountInput input = new CreateRecord.AccountInput();
        input.accountName = 'Test Account';
        input.phoneNumber = '1234567890';
        input.industry1 = 'Technology';
        input.accountNumber = 'ACCT-001';
        input.numberOfLocations = 3;
        // Add more fields as needed
        accountInputs.add(input);
        
        // Execute the method to be tested
        Test.startTest();
        CreateRecord.createAccount(accountInputs);
        Test.stopTest();
        
        // Verify the results
        List<Account> createdAccounts = [SELECT Name, Phone, Industry, AccountNumber, NumberofLocations__c FROM Account];
        System.assertEquals(1, createdAccounts.size());
        Account createdAccount = createdAccounts[0];
        System.assertEquals('Test Account', createdAccount.Name);
        System.assertEquals('1234567890', createdAccount.Phone);
        System.assertEquals('Technology', createdAccount.Industry);
        System.assertEquals('ACCT-001', createdAccount.AccountNumber);
        System.assertEquals(3, createdAccount.NumberofLocations__c);
        // Add more assertions as needed
    }
}