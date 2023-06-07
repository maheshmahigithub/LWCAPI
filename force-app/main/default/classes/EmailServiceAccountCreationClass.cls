global class EmailServiceAccountCreationClass implements Messaging.InboundEmailHandler  {
	global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,Messaging.InboundEnvelope envelope){        
        system.debug('method called');
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult(); 
        //  Messaging.InboundEmail.TextAttachment[] tAttachments = email.textAttachments;
        Messaging.InboundEmail.BinaryAttachment[] bAttachments = email.BinaryAttachments; 
        String csvbody='';
        String[] csvFileLines = new List<String>();
        List<Account> accountlist= New List<Account>();        
        system.debug('bAttachments****'+ bAttachments);
        if(bAttachments !=null){
            for(Messaging.InboundEmail.BinaryAttachment btt :bAttachments){
                if(btt.filename.endsWith('.csv')){
                    csvbody = btt.body.toString();  
                    system.debug('csvbody****'+ csvbody);                  
                    //Now sepatate every row of the Csv                    
                    csvFileLines = csvbody.split('\n');
                    system.debug('csvFileLines****'+ csvFileLines);                    
                    for(Integer i=1; i < csvFileLines.size(); i++){                        
                        String[] csvRecordData = csvFileLines[i].split(',');
                        Account accObj = new Account() ;
                        system.debug('accObj****'+ accObj);  
                        system.debug('csvRecordData[0]****'+ csvRecordData[0]);
                        accObj.name = csvRecordData[0] ;
                        //  accObj.accountnumber = csvRecordData[1];
                        accObj.Type = csvRecordData[1];
                        system.debug('csvRecordData[1]****'+ csvRecordData[1]);
                       // accObj.body = Blob.valueOf(tAttachment.Body);                 
                        accountlist.add(accObj);                        
                    }     
                }
            }           
            if(accountlist.size()>0)  {             
                //insert accountlist;
                system.debug('accountlist@@@'+ accountlist);
                Database.SaveResult[] srList = Database.insert(accountlist,false);
                for(Database.SaveResult sr : srList){
                    if(!sr.Success){
                        system.debug('This Account record is failed to insert'+sr);
                    }
                }   
            }
            
            }        
            result.success = true;
            return result;        
    }     
}