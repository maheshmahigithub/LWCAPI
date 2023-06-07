public class FindSchemaInOrg2 {
    public static final String Consumer_Key = '3MVG9wt4IL4O5wvLMRH97bxBpZ6WBZMcJFkY6fMwE1sZCG4Lu_fG8e7XTSyDbiGXEQD_scz_6ww==';
    public static final String Consumer_Secret = 'A70F49E3E6DEA48DC1089B42E9FB42CD270D15E2FF33927680A74E5B628CEA2D';
    public static final String UserName = 'Mahesh@Altimetrik.com';
    public static final String Password = 'Capital@169CisYiCP89kHmiSORE8xLOI3n';
   
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
   
    public static void FindObject(){
        List<string> ObjNames = new List<String>();
        ObjNames.add('Contact');
        AccessTokenWrapper accessTokenWrap = generateToken();
        if(accessTokenWrap != null && accessTokenWrap.access_Token != null){
            String requestBody = JSON.serialize(ObjNames);
            HTTP http = new HTTP();
            HTTPRequest req = new HTTPRequest();
            req.setBody(requestBody);
            req.setMethod('POST');
            req.setHeader('Authorization','Bearer '+ accessTokenWrap.access_Token);
            req.setHeader('content-type', 'application/json');
            req.setHeader('accept','application/json');
            req.setEndpoint('https://maheshaltimetrikcom-dev-ed.develop.my.salesforce.com/services/apexrest/v1/FindObject/');
            HttpResponse response = http.send(req);
            System.debug('Response Status code : '+ response.getStatusCode());
            //System.debug('response body : '+ response.getBody());
            Map<String,String> responseMap  = (Map<String,String>) System.JSON.deserialize(response.getBody(), Map<String,String>.class);
            //System.debug('responseMap : ' + responseMap);
            for(String rsMap : responseMap.keySet()){
                System.debug('Schema:: '+rsMap +' Query:: ' +responseMap.get(rsMap));
            }
        }
    }
}