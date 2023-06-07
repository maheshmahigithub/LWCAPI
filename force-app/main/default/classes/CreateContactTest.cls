@IsTest
private class CreateContactTest {
    @IsTest
    static void testCreateContact() {
        // Prepare test data
        List<CreateContact.ContactInput> contactInputs = new List<CreateContact.ContactInput>();
        CreateContact.ContactInput input = new CreateContact.ContactInput();
        input.contactName = 'Test Contact';
        input.phoneNumber = '1234567890';
        // Add more fields as needed
        contactInputs.add(input);
        
        // Execute the method to be tested
        Test.startTest();
        CreateContact.createContact(contactInputs);
        Test.stopTest();
        
        // Verify the results
        List<Contact> createdContacts = [SELECT LastName, Phone FROM Contact];
        System.assertEquals(1, createdContacts.size());
        Contact createdContact = createdContacts[0];
        System.assertEquals('Test Contact', createdContact.LastName);
        System.assertEquals('1234567890', createdContact.Phone);
        // Add more assertions as needed
    }
}