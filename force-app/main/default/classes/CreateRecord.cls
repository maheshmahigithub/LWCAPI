public class CreateRecord {
    @InvocableMethod(label='Create Account' description='Creates an account record')
    public static void createAccount(List<AccountInput> accountInputs) {
        List<Account> accountsToCreate = new List<Account>();
        
        for (AccountInput input : accountInputs) {
            Account newAccount = new Account();
            newAccount.Name = input.accountName;
            newAccount.Phone = input.phoneNumber;
            newAccount.Industry = input.industry1;
            newAccount.AccountNumber = input.accountNumber;
            newAccount.NumberofLocations__c = input.numberOfLocations;
            // Add more fields as needed
            
            accountsToCreate.add(newAccount);
        }
        
        insert accountsToCreate;
    }
    
    public class AccountInput {
        @InvocableVariable(label='Account Name' required=true)
        public String accountName;
        
        @InvocableVariable(label='phoneNumber')
        public String phoneNumber;
        
        @InvocableVariable(label='industry1')
        public String industry1;
        
        @InvocableVariable(label='accountNumber')
        public String accountNumber;
        
        @InvocableVariable(label='NumberofLocations')
        public integer numberOfLocations;
        // Add more fields as needed
    }
}