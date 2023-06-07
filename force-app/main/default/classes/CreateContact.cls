public class CreateContact {
    @InvocableMethod(label='Create Contact' description='Creates an contact record')
    public static void createContact(List<ContactInput> contactInputs) {
        List<Contact> contactsToCreate = new List<Contact>();
        
        for (ContactInput input : contactInputs) {
           Contact newContact = new Contact();
            newContact.LastName = input.contactName;
            newContact.Phone = input.phoneNumber;
            
            // Add more fields as needed
            
            contactsToCreate.add(newContact);
        }
        
        insert contactsToCreate;
    }
    
    public class ContactInput {
        @InvocableVariable(label='Contact Name' required=true)
        public String contactName;
        
        @InvocableVariable(label='phoneNumberc')
        public String phoneNumber;
        
       
        // Add more fields as needed
    }
}