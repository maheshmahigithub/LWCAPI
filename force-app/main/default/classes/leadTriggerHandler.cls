public class leadTriggerHandler {
    
     public static string Consumer_Key='3MVG9wt4IL4O5wvLMRH97bxBpZ6WBZMcJFkY6fMwE1sZCG4Lu_fG8e7XTSyDbiGXEQD_scz_6ww==';
     public static string Consumer_Secret='A70F49E3E6DEA48DC1089B42E9FB42CD270D15E2FF33927680A74E5B628CEA2D';
     public static string UserName = 'Mahesh@Altimetrik.com';
     public static string Password = 'Capital@169CisYiCP89kHmiSORE8xLOI3n';
    
    public static void GenerateUniqueId(List<Lead> leadList){
        for(Lead ld : leadList){
            if(ld.LastName != null){
                String UID = String.valueOf((Math.random() * 10000) + 1) + ld.LastName + String.valueOf((System.now()));
                ld.Unique_Id__c = UID;
            }
        }
    }
   
    public static void afterInsert(Map<id,Lead> leadNewMap){
        upsertLeadInTargetOrg(leadNewMap.keySet());
    }
    //since we cannot make callout directly from trigger, so for that we are using future method here
    @future(callout = true)
    public static void upsertLeadInTargetOrg(Set<Id> leadIds){
        List<Lead> leadList = [Select Id, FirstName, LastName, Company, Status, Unique_Id__c From Lead WHERE Id In: leadIds];
        AccessTokenWrapper accessTokenWrap = generateToken();
        if(accessTokenWrap != null && accessTokenWrap.access_Token != null){
            String requestBody = JSON.serialize(leadList);
            HTTP http = new HTTP();
            HTTPRequest req = new HTTPRequest();
            req.setBody(requestBody);
            req.setMethod('POST');
            req.setHeader('Authorization','Bearer '+ accessTokenWrap.access_Token);
            req.setHeader('content-type', 'application/json');
            req.setHeader('accept','application/json');
            req.setEndpoint('https://maheshaltimetrikcom-dev-ed.develop.my.salesforce.com/services/apexrest/v1/GetLeadsFromSourceOrg/');
            HttpResponse response = http.send(req);
            System.debug('Response Status code : '+ response.getStatusCode());
            System.debug('response body in source Org : '+ response.getBody());
        }
    }
    public static AccessTokenWrapper generateToken(){
        String requestBody = 'grant_type=password&client_id='+Consumer_Key+'&client_secret='+Consumer_Secret+'&username='+UserName+'&password='+Password;
        HTTP http = new HTTP();
        HTTPRequest req = new HTTPRequest();
        req.setBody(requestBody);
        req.setMethod('POST');
        req.setEndpoint('https://login.salesforce.com/services/oauth2/token');
        HttpResponse response = http.send(req);
        //System.debug('Response Status code : '+ response.getStatusCode());
        //System.debug('Response Body : '+ response.getBody());
        if(response.getStatusCode() == 200){
            return(AccessTokenWrapper) System.JSON.deserialize(response.getBody(), AccessTokenWrapper.class);
        }
        else{
            return null;
        }
    }
   
    public class AccessTokenWrapper{
        public string access_Token;
        public string instance_url;
        public string id;
        public string token_type;
        public string issued_at;
        public string signature;
    }
   
    public static void afterDelete(List<Lead> oldList){
        Set<String> DeletedUID = New Set<String>();
        for(Lead ld : oldList){
            DeletedUID.add(ld.Unique_Id__c);
        }
        DeleteRecordInTargetOrg(DeletedUID);
    }
   
    @future(callout = true)
    public static void DeleteRecordInTargetOrg(Set<String> DeletedLeadUIds){
       AccessTokenWrapper accessTokenWrap = generateToken();
        if(accessTokenWrap != null && accessTokenWrap.access_Token != null){
            String requestBody = JSON.serialize(DeletedLeadUIds);
            HTTP http = new HTTP();
            HTTPRequest req = new HTTPRequest();
            req.setBody(requestBody);
            req.setMethod('DELETE');
            req.setHeader('Authorization','Bearer '+ accessTokenWrap.access_Token);
            req.setHeader('content-type', 'application/json');
            req.setHeader('accept','application/json');
            req.setEndpoint('https://maheshaltimetrikcom-dev-ed.develop.my.salesforce.com/services/apexrest/v1/GetLeadsFromSourceOrg/');
            HttpResponse response = http.send(req);
            System.debug('Response Status code : '+ response.getStatusCode());
            System.debug('response body in source Org : '+ response.getBody());
        }
    }
}