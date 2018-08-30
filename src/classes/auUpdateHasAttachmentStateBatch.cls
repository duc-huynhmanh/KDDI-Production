global class auUpdateHasAttachmentStateBatch implements Database.Batchable<sObject> {
    
    String query;
    Integer flagNo;
    Boolean hasError;
    
    global auUpdateHasAttachmentStateBatch(Integer i) {
    	flagNo = i;
        query = 'SELECT HasAttachment__c, (SELECT Id FROM Attachments) FROM auCXKnowledge__c WHERE CalculateAttachmentTechnical__c != ' + flagNo + ' LIMIT 14';
        hasError = false;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<auCXKnowledge__c> scope) {
        List<auCXKnowledge__c> updateList = new List<auCXKnowledge__c>();
        for (auCXKnowledge__c k : scope) {
            k.CalculateAttachmentTechnical__c = flagNo;
            k.HasAttachment__c = k.Attachments != null && k.Attachments.size() > 0;
            updateList.add(k);
        }
        if(!updateList.isEmpty()) {
        	try{
        		update updateList;
        	} catch(Exception ex) {
        		system.debug('Exception: ' + ex);
        		hasError = true;
        	}
        }
    }
    
    global void finish(Database.BatchableContext BC) {
    	if(!hasError) {
    		List<auCXKnowledge__c> listK = [SELECT Id FROM auCXKnowledge__c WHERE CalculateAttachmentTechnical__c != :flagNo LIMIT 14];
        	if(listK != null && listK.size() > 0 ) {
        		auUpdateHasAttachmentStateBatch b = new auUpdateHasAttachmentStateBatch(flagNo);
				database.executebatch(b, 14);
        	}
    	}
    }
    
}