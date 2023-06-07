public with sharing class kanbanview {
@AuraEnabled(cacheable=true)
public static List<Opportunity> getOpportunities() {
  
   List<Opportunity> oppList = [SELECT Id,account.Id,Name,account.Name,CloseDate,StageName,Amount FROM Opportunity limit 10 ];
   return oppList;
 }
}