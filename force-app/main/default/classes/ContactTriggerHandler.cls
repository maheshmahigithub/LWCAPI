public class ContactTriggerHandler {
    public void onbeforeinsert(List<Contact> conlist){
        List<Contact> conlisttoupdate = new List<Contact>();
        List<Account> acclist = new List<Account>();
        Map<Id,Account> accmap = new Map<Id,Account>();
        Map<Id,Contact> conmap = new Map<Id,Contact>();
        //set<Id> accids = new set<Id>();
        Map<Id,Decimal> accsequensenumber = new Map<Id,Decimal>();
        Map<Id,Decimal> consequensenumber = new Map<Id,Decimal>();        
        for(Contact cn: conlist){
            //conmap.put(cn.Id, cn);           
            if(cn.AccountId != null){
                accsequensenumber.put(cn.AccountId,cn.Sequence_Number__c);
            }                     	
        }
        //system.debug('mah consequensenumber --- '+consequensenumber);
        system.debug('mah accsequensenumber --- '+accsequensenumber);
        acclist = [Select Id, (Select Id,Sequence_Number__c from Contacts where Sequence_Number__c!=null Order by Sequence_Number__c DESC),Name from Account where Id In :accsequensenumber.keyset()];
        for(Account a:acclist){
            accmap.put(a.id, a);
        }
        for(Contact cn: conlist){
            if(cn.Sequence_Number__c != null && cn.AccountId != null){
                if(cn.Sequence_Number__c == -1){
                    cn.Sequence_Number__c = 1;                                       
                }
                for(Contact cn1 : accmap.get(cn.AccountId).Contacts){
                    if(cn.Sequence_Number__c <= cn1.Sequence_Number__c){
                        cn1.Sequence_Number__c = cn1.Sequence_Number__c+1;
                        conlisttoupdate.add(cn1);
                        //system.debug('mah method called --- '+cn.Sequence_Number__c);
                    } 
                }
            }
                
            else if(cn.Sequence_Number__c == null){
                if(cn.AccountId != null ){
                    if(accmap.get(cn.AccountId).Contacts.size()>0 && accmap.get(cn.AccountId).Contacts[0] != null){
                        cn.Sequence_Number__c = accmap.get(cn.AccountId).Contacts[0].Sequence_Number__c+1;
						system.debug('mah 12344 method called --- '+cn.Sequence_Number__c);                        
                    }
                    else{
                        cn.Sequence_Number__c =1;
                        system.debug('mahh 7654 method called --- '+cn.Sequence_Number__c);
                    }
                    //conlisttoupdate.add(cn);
                }                
            } 
        }
        update conlisttoupdate;
    }
}