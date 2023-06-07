public class DataRetrievalAndEmail {
    private static String externalUrl = 'http://restapi.adequateshop.com/api/tourist?page=2';
    
    public static void executeDataRetrievalAndEmail() {
        // Make a REST API call to fetch data from the external URL
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('http://restapi.adequateshop.com/api/tourist?page=2');
        request.setMethod('GET');
        
        HttpResponse response = http.send(request);
        
        if (response.getStatusCode() == 200) {
            String responseBody = response.getBody();
            
            // Parse the JSON response into a Map or List
            Object parsedResponse = JSON.deserializeUntyped(responseBody);
            
            // Access and process the parsed data
            if (parsedResponse instanceof Map<String, Object>) {
                Map<String, Object> dataMap = (Map<String, Object>) parsedResponse;
                list<Object> dataMap1 = (list< Object>) dataMap.get('data');
                Map<String, Datawraper> dataMap3 = new Map<String, Datawraper> ();
                for(object obj: dataMap1){
                    Map<String, Object> dataMap2 = (Map<String, Object>) obj;
                    Datawraper obj1= new Datawraper();
                    obj1.email= string.valueof(dataMap2.get('tourist_email'));
                    obj1.name= string.valueof(dataMap2.get('tourist_name'));
                    obj1.location= string.valueof(dataMap2.get('tourist_location'));
                    obj1.createddate= string.valueof(dataMap2.get('createdat'));  
                    
                    dataMap3.put(string.valueof(dataMap2.get('id')),obj1);
                }
                for(string str: dataMap3.keyset()){
                    //dataMap3.get(str);
                    system.debug(dataMap3.get(str).name);
                }
                system.debug(dataMap3);
                // Access the email addresses from the dataMap
                Object emailData = dataMap.get('emails');
                if (emailData instanceof List<Object>) {
                    List<Object> emailObjects = (List<Object>) emailData;
                    List<String> emailList = new List<String>();
                    for (Object emailObj : emailObjects) {
                        if (emailObj instanceof String) {
                            String email = (String) emailObj;
                            emailList.add(email);
                        }
                    }
                    
                    // Send email to the emailList
                    if (!emailList.isEmpty()) {
                        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();
                        
                        for (String strData :  dataMap3.keyset()) {
                            // Create email message for each email address
                            Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
                            emailMsg.setToAddresses(new List<String>{dataMap3.get(strData).email});
                            emailMsg.setSubject(dataMap3.get(strData).name);
                            emailMsg.setPlainTextBody('Here is the location you are travelling to '+dataMap3.get(strData).location +' on ' +dataMap3.get(strData).createddate);
                            emailsToSend.add(emailMsg);
                        }
                        
                        // Send the email messages
                        Messaging.sendEmail(emailsToSend);
                    }
                }
            } else if (parsedResponse instanceof List<Object>) {
                // Handle the case if the parsed response is a list
            }
        } else {
            // Handle the error if the REST API call was unsuccessful
            System.debug('Error: ' + response.getStatusCode() + ' ' + response.getStatus());
        }
    }
    public class Datawraper{
        public string email; 
        public string name;
        public string location;
        public string createddate;
        
        
        
        
    }
    
}