/***************************************************************************************************
    Created By  : MST
	Modified By: John Hernandez(JH)-Logic separated from trigger and now in controller.
    Description : Opportunity Stage will be updated as 'Needs Analysis',When the event is scheduled/created on the Opp.
                  Opportunity Stage will be updated as 'Presentation',When the scheduled event is completed.

****************************************************************************************************/
public class EventOpportunitiesStageController {
    
    
    public static void UpdateOportunitiesOnInsert (List<Event> events ){
        
         set<id> openEventSet = new set<id>();
        list<opportunity> opportunityupdatelist = new list<opportunity>();
         
        for(Event evt:events){
            if(evt.StartDateTime > System.now())
                openEventSet.add(evt.whatid);
           }
        
        
        if(openEventSet.size() > 0)
        {
            for(opportunity openopp:[select id,StageName from opportunity WHERE Id in :openeventset])
            {
                Opportunity opportunityupdate = new Opportunity();
                opportunityupdate.id = openopp.id;
                opportunityupdate.StageName = 'Needs Analysis';
                opportunityupdatelist.add(opportunityupdate);
  
            }
        
        }
        
         if(opportunityupdatelist.size()>0)
                update opportunityupdatelist;
     
        
    }

    
    public static void UpdateOportunitiesOnUpdate (List<Event> events){
        set<id> closedEventSet = new set<id>();
        list<opportunity> opportunityupdatelist = new list<opportunity>();
        
        for(Event evt:events){
            if(evt.Completed__c == True)
                closedEventSet.add(evt.whatid);
        }
        
        if(closedeventset.size() > 0)
        {
            for(opportunity closedopp:[select id,StageName from opportunity WHERE Id in :closedeventset]){
                Opportunity opportunityupdate = new Opportunity();
                opportunityupdate.id = closedopp.id;
                opportunityupdate.StageName = 'Presentation';
                opportunityupdatelist.add(opportunityupdate);
            }
        }
        
        
        if(opportunityupdatelist.size()>0)
            update opportunityupdatelist;
    }
}