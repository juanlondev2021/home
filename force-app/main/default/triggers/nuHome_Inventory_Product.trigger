/********************************************************************************************************
Description : This class creates Inventory Records for all Door Tag Script Industries which are 
marked as "Yes" and Verbal Consent equals Phone/Yes.
***************************************************************************************************************/

trigger nuHome_Inventory_Product on Door_Tag_Script__c (after insert,after update,before update,before insert) {

    if(Trigger.isUpdate && Trigger.isAfter)
    {
        nuHome_Email_Task_AC.createTask(Trigger.newMap, Trigger.oldMap); 
    }
    
    if(Trigger.isBefore && Trigger.isUpdate){
        system.debug('Test recursive value '+Recursive.isExecute);
        if(Recursive.isExecute){
            Recursive.isExecute = False;
            Map<String,Door_Tag_Script__c> summaryDTS = New Map<String,Door_Tag_Script__c>();
            set<string> searsInd = New set<string>();
            String industryValues = '';
            for(Door_Tag_Script__c dtsIns:Trigger.New){
                if(dtsIns.Home_Remodeling__c != Trigger.oldMap.get(dtsIns.Id).Home_Remodeling__c &&
                   dtsIns.Home_Remodeling__c != Null && dtsIns.Home_Remodeling__c != 'Not Interested' &&
                   dtsIns.Home_Remodeling__c != 'Already Has')
                    searsInd.add('Home Remodeling');
                if(dtsIns.Kitchen_Remodeling__c != Trigger.oldMap.get(dtsIns.Id).Kitchen_Remodeling__c &&
                   dtsIns.Kitchen_Remodeling__c != Null && dtsIns.Kitchen_Remodeling__c != 'Not Interested' &&
                   dtsIns.Kitchen_Remodeling__c != 'Already Has')
                    searsInd.add('Kitchen Remodeling');
                if(dtsIns.Bathroom_Remodeling__c != Trigger.oldMap.get(dtsIns.Id).Bathroom_Remodeling__c &&
                   dtsIns.Bathroom_Remodeling__c != Null && dtsIns.Bathroom_Remodeling__c != 'Not Interested' &&
                   dtsIns.Bathroom_Remodeling__c != 'Already Has')
                    searsInd.add('Bathroom Remodeling');
                if(dtsIns.Granite_Marble__c != Trigger.oldMap.get(dtsIns.Id).Granite_Marble__c &&
                   dtsIns.Granite_Marble__c != Null && dtsIns.Granite_Marble__c != 'Not Interested' &&
                   dtsIns.Granite_Marble__c != 'Already Has')
                    searsInd.add('Granite/Marble');
                if(dtsIns.Windows_Doors__c != Trigger.oldMap.get(dtsIns.Id).Windows_Doors__c &&
                   dtsIns.Windows_Doors__c != Null && dtsIns.Windows_Doors__c != 'Not Interested' &&
                   dtsIns.Windows_Doors__c != 'Already Has')
                    searsInd.add('Windows/Doors');
                if(dtsIns.Flooring__c != Trigger.oldMap.get(dtsIns.Id).Flooring__c &&
                   dtsIns.Flooring__c != Null && dtsIns.Flooring__c != 'Not Interested' &&
                   dtsIns.Flooring__c != 'Already Has')
                    searsInd.add('Flooring/Carpeting');
                if(dtsIns.Gutters__c != Trigger.oldMap.get(dtsIns.Id).Gutters__c &&
                   dtsIns.Gutters__c != Null && dtsIns.Gutters__c != 'Not Interested' &&
                   dtsIns.Gutters__c != 'Already Has')
                    searsInd.add('Gutters');
                if(dtsIns.Roofer__c != Trigger.oldMap.get(dtsIns.Id).Roofer__c &&
                   dtsIns.Roofer__c != Null && dtsIns.Roofer__c != 'Not Interested' &&
                   dtsIns.Roofer__c != 'Already Has')
                    searsInd.add('Roofing');
                if(dtsIns.Siding__c != Trigger.oldMap.get(dtsIns.Id).Siding__c &&
                   dtsIns.Siding__c != Null && dtsIns.Siding__c != 'Not Interested' &&
                   dtsIns.Siding__c != 'Already Has')
                    searsInd.add('Siding');
                
                for(String str:searsInd) {
                    industryValues += (industryValues==''?'':',')+str;
                }
                system.debug('Before painting process '+industryValues);
                if(dtsIns.PaintingInside__c){
                    if(industryValues == '')
                        industryValues = 'Painting (Exterior/Interior)';
                    else
                        industryValues = industryValues + ', Painting (Exterior/Interior)';
                    dtsIns.PaintingInside__c = false;
                    system.debug('After painting process '+industryValues);
                }
                if(industryValues != ''){
                    dtsIns.SearsIndustry__c = industryValues;
                    system.debug('dtsIns.SearsIndustry__c values'+dtsIns.SearsIndustry__c);
                }
            }
        }
    }
    
    if(Trigger.isBefore && Trigger.isInsert){
        Map<String,Door_Tag_Script__c> summaryDTS = New Map<String,Door_Tag_Script__c>();
        set<string> searsInd = New set<string>();
        String industryValues = '';
        for(Door_Tag_Script__c dtsIns:Trigger.New){
            if(dtsIns.Home_Remodeling__c != Null && dtsIns.Home_Remodeling__c != 'Not Interested' &&
               dtsIns.Home_Remodeling__c != 'Already Has')
                searsInd.add('Home Remodeling');
            if(dtsIns.Kitchen_Remodeling__c != Null && dtsIns.Kitchen_Remodeling__c != 'Not Interested' &&
               dtsIns.Kitchen_Remodeling__c != 'Already Has')
                searsInd.add('Kitchen Remodeling');
            if(dtsIns.Bathroom_Remodeling__c != Null && dtsIns.Bathroom_Remodeling__c != 'Not Interested' &&
               dtsIns.Bathroom_Remodeling__c != 'Already Has')
                searsInd.add('Bathroom Remodeling');
            if(dtsIns.Granite_Marble__c != Null && dtsIns.Granite_Marble__c != 'Not Interested' &&
               dtsIns.Granite_Marble__c != 'Already Has')
                searsInd.add('Granite/Marble');
            if(dtsIns.Windows_Doors__c != Null && dtsIns.Windows_Doors__c != 'Not Interested' &&
               dtsIns.Windows_Doors__c != 'Already Has')
                searsInd.add('Windows/Doors');
            if(dtsIns.Flooring__c != Null && dtsIns.Flooring__c != 'Not Interested' &&
               dtsIns.Flooring__c != 'Already Has')
                searsInd.add('Flooring/Carpeting');
            if(dtsIns.Gutters__c != Null && dtsIns.Gutters__c != 'Not Interested' &&
               dtsIns.Gutters__c != 'Already Has')
                searsInd.add('Gutters');
            if(dtsIns.Roofer__c != Null && dtsIns.Roofer__c != 'Not Interested' &&
               dtsIns.Roofer__c != 'Already Has')
                searsInd.add('Roofing');
            if(dtsIns.Siding__c != Null && dtsIns.Siding__c != 'Not Interested' &&
               dtsIns.Siding__c != 'Already Has')
                searsInd.add('Siding');
            
            for(String str:searsInd) {
                    industryValues += (industryValues==''?'':',')+str;
                }
                system.debug('Before painting process '+industryValues);
                if(dtsIns.PaintingInside__c){
                    if(industryValues == '')
                        industryValues = 'Painting (Exterior/Interior)';
                    else
                        industryValues = industryValues + ', Painting (Exterior/Interior)';
                    dtsIns.PaintingInside__c = false;
                    system.debug('After painting process '+industryValues);
                }
                if(industryValues != ''){
                    dtsIns.SearsIndustry__c = industryValues;
                    system.debug('dtsIns.SearsIndustry__c values'+dtsIns.SearsIndustry__c);
                }
        }
    }
}