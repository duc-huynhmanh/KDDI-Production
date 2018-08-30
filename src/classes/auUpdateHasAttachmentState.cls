public class auUpdateHasAttachmentState {
    
    public static void doUpdate(Integer i){        
        List<auCXKnowledge__c> allKnowledges = [SELECT HasAttachment__c, (SELECT Id FROM Attachments) FROM auCXKnowledge__c WHERE CalculateAttachmentTechnical__c != :i LIMIT 14];
        if(allKnowledges.isEmpty()){
            system.debug('Updated all records');
            return;
        }
        List<auCXKnowledge__c> updateList = new List<auCXKnowledge__c>();
        for(auCXKnowledge__c k : allKnowledges){
            k.CalculateAttachmentTechnical__c = i;
            k.HasAttachment__c = k.Attachments != null && k.Attachments.size() > 0;
            updateList.add(k);
        }
        if(!updateList.isEmpty()) {
            update updateList;
            system.debug('updated ' + updateList.size() + ' records: ' + updateList);
        }
    }
}