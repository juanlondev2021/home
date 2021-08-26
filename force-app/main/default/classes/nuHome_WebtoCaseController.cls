/******************************************************************************************

Created by: MST
Description : This VF and Controller is enabled for 'Force.com - App Subscription license' users to create case using site link.
*******************************************************************************************/

public class nuHome_WebtoCaseController
{
  public Case caseobj {get;set;}
  public String RecordType{get;set;}
  public boolean displayCaseEditPage{get;set;}
  public boolean displayDetailPage{get;set;}
  public List<Attachment> newAttachments {get; set;}
  public integer NUM_ATTACHMENTS_TO_ADD;
  public Id userId{get;set;}
  public nuHome_WebtoCaseController()
  {
      caseobj = new Case();
      displayDetailPage = false;
      NUM_ATTACHMENTS_TO_ADD = 4;
      String steps = '1';
      newAttachments = new List<Attachment>();
      steps =  apexpages.currentpage().getparameters().get('step');
      
       
      String RecordTypeId = apexpages.currentpage().getparameters().get('RecordTypeid');
      userId = apexpages.currentpage().getparameters().get('userId');
     
      
      //String caseId =  apexpages.currentpage().getparameters().get('Id');
      caseObj.Created_By__c = userId;
      caseObj.Created_By_Id__c = userId;
      if(RecordTypeId != Null)
      {
        caseObj.RecordTypeId = RecordTypeId;
        
      }
      
      if(steps == '1')
      {
          displayCaseEditPage = false;
      }
      else if(steps == '2')
      {
           displayCaseEditPage = true;
      }
      else if(steps == '3')
      {
           displayDetailPage = true;
      }
      
    /*  If(caseId != Null)
      {
        caseobj = [SELECT id, RecordTypeId,CaseNumber,Contact.Name,Status,Priority,Type,Reason,Sub_Type__c,
                   Subject,SuppliedEmail,SuppliedPhone,SuppliedCompany,Description FROM Case WHERE Id = :caseId Limit 1];
      }*/
  
  } 
  // creating case.
  public PageReference casecreate()
  {
      try
      {
      
          //Fetching the assignment rules on case
            AssignmentRule AR = new AssignmentRule();
            AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];

         //Creating the DMLOptions for "Assign using active assignment rules" checkbox
            Database.DMLOptions dmlOpts = new Database.DMLOptions();
            dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
        
          caseObj.setOptions(dmlOpts);
          insert caseobj;
          
          List<Attachment> toInsert=new List<Attachment>();
            for (Attachment newAtt : newAttachments)
            {
                if (newAtt.Body!=null)
                {
                    newAtt.parentId=caseObj.ID;
                    toInsert.add(newAtt);
                }
            }
        
            insert toInsert;
            newAttachments.clear();
         
          
          
          
          pageReference pgRef = new pageReference('https://nuhome--c.na16.visual.force.com/apex/nuHome_Case' );
          pgRef.setRedirect(True);
          return pgRef; 
          
      }
      Catch(DMLException e)
      {
        system.debug('eeeee'+e.getMessage());
      }
    return null;
  }
  
  // Getting all the Record Type info.
    public list<selectoption> GetTypeValues(){
        List<SelectOption> options = new List<SelectOption>();
        for(recordtype records:[select Id,Name from recordtype where SobjectType='Case']){
            options.add(new SelectOption(records.Id,records.Name));
        }
        return options;
    }

  // Based on the Record Type selection, Page will render picklist values.
   public pageReference chooseRT()
   {
            displayCaseEditPage = true;
            pageReference pgRef = new pageReference('/apex/nuHome_WebtoCase?RecordTypeid='+recordtype+'&Step=2'+'&userId='+userId);
            pgRef.setRedirect(True);
            return pgRef;
           
   
   }
    // Back to case list page.
   public pageReference Cancel()
   {
            pageReference pgRef = new pageReference('https://nuhome--c.na16.visual.force.com/apex/nuHome_Case' );
            pgRef.setRedirect(True);
            return pgRef;
   
   }
   
   // Adding more attachments row.
   public void addMore()
    {
        for (Integer idx=0; idx<NUM_ATTACHMENTS_TO_ADD; idx++)
        {
            newAttachments.add(new Attachment());
        }
    }
}