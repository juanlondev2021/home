trigger Verbal_Consent_Trigger_AT on Verbal_Consent__c (before insert, before update) {
    
    set<string> currPlaceHolderSet= new set<string>();
    set<string> exPlaceHolderSet = new set<string>();
    
    
    for(Verbal_Consent__c currRec : Trigger.New){
        
        if(currRec.Active__c && currRec.Place_Holder__c <> NULL){ 
            if(Trigger.isInsert){
                currPlaceHolderSet.add(currRec.Place_Holder__c); 
            }
            if(Trigger.isUpdate && (currRec.Place_Holder__c <> Trigger.oldmap.get(currRec.id).Place_Holder__c || currRec.Active__c <> Trigger.oldmap.get(currRec.id).Active__c))
                currPlaceHolderSet.add(currRec.Place_Holder__c); 
        }
    }
    
    if(!currPlaceHolderSet.isEmpty()){
        For(Verbal_Consent__c  vc :[SELECT ID,Place_Holder__c, Active__c FROM Verbal_Consent__c WHERE Place_Holder__c in : currPlaceHolderSet AND Active__c = True]){
            exPlaceHolderSet.add(vc.Place_Holder__c);
        }
    }
 
    if(!exPlaceHolderSet.isEmpty()){
        for(Verbal_Consent__c currVC : Trigger.New){
            if(exPlaceHolderSet.contains(currVC.Place_Holder__c))
                currVC.Place_Holder__c.addError('You can not create two active record for same place holder - '+currVC.Place_Holder__c);
        }
    }
    
    
}