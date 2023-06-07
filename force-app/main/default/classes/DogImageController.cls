public class DogImageController {
	@AuraEnabled(cacheable=true)
    public static String fetchRandomDogImage(String uniqueParam) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://dog.ceo/api/breeds/image/random?uniqueParam=' + uniqueParam);
        req.setMethod('GET');
        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug('Response status : '+ res.getStatus());
        System.debug('Response status : '+ res.getStatusCode());
        if (res.getStatusCode() == 200) {
            //return res.getBody();
            Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            String imageUrl = (String) jsonResponse.get('message');
            return imageUrl;
        }
        return null;
    }
}