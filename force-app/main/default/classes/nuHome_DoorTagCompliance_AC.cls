/********************************************************************************
Createdby: MST
Description : It will capture the Door Tag Compliance Record. Acceptance criteria is, 
Person Account should associate with at least one Survey records in order
to create Door Tag Compliance. 
***************************************************************************************/
public class nuHome_DoorTagCompliance_AC
{
    
    
    public Id currentAccountId;
    public Id currentUserAddressId;
    public Account accIns{get;set;}
    public List<Door_Tag_Script__c> doorTagInsList {get;set;}
    public Door_Tag_Script__c doorTagIns{get;set;}
    public Door_Tag_Script__c doorTagCompliance{get;set;}
    Public List<DTSQuestion__c> DTSQuestions{get;set;}
    Public List<DTSQuestion__c> DTSQuestionsFormLeadup{get;set;}
    Public List<DTSQuestion__c> DTSQuestionsInboundtm{get;set;}
    public Id userId{get;set;}
    public String createdDateStr{get;set;}
    public String finishedDateStr{get;set;}
    public User currentuser{get;set;}
    public String userName{get;set;}
    public boolean inputMode{get;set;}
    public boolean outputMode{get;set;}
    public string currUserName{get;set;}
    public boolean editSurvey{get;set;}
    
    public string dtsComplianceId;

public nuHome_DoorTagCompliance_AC(Apexpages.standardController control)
{
    DTSQuestions = New List<DTSQuestion__c>();
    DTSQuestionsFormLeadup = New List<DTSQuestion__c>();
    DTSQuestionsInboundtm = New List<DTSQuestion__c>();
    for(DTSQuestion__c DTQ:[SELECT Id,Section__c,FieldAPIName__c,PopupHelperClass__c,Industry__c,Order__c,Question__c FROM DTSQuestion__c ORDER BY Order__c]){
        IF(DTQ.Section__c == 'Form Lead up with Popups')
            DTSQuestions.add(DTQ);
        IF(DTQ.Section__c == 'Form Lead up')
            DTSQuestionsFormLeadup.add(DTQ);
        IF(DTQ.Section__c == 'Inbound TM Script')
            DTSQuestionsInboundtm.add(DTQ);
    }
     if (!Test.isRunningTest()) {
        List<String> fieldList = New List<String>();
            for(DTSQuestion__c DTS:DTSQuestionsInboundtm){
                fieldList.add(DTS.FieldAPIName__c);
            }
            for(DTSQuestion__c DTS:DTSQuestionsFormLeadup){
                fieldList.add(DTS.FieldAPIName__c);
            }
            for(DTSQuestion__c DTS:DTSQuestions){
                fieldList.add(DTS.FieldAPIName__c);
            }
            control.addFields(fieldList);
            control.addFields(new List<String>{'Account__c','User_Address__c','CreatedDate','Starting_Agent__c','Finishing_Agent__c','Starting_Date__c','Finishing_Date__c'});
        }
   //doorTagCompliance = new Door_Tag_Script__c();
   doorTagCompliance = (Door_Tag_Script__c)control.getRecord();
   userId = UserInfo.getUserId();
   currentAccountId =  ApexPages.currentPage().getParameters().get('accountId');
   currentUserAddressId = ApexPages.currentPage().getParameters().get('userAddressId');
   dtsComplianceId = ApexPages.currentPage().getParameters().get('Id');
   currUserName = UserInfo.getName();
   system.debug('currentAccountId value '+currentAccountId+' currentUserAddressId value '+currentUserAddressId+' dtsComplianceId '+dtsComplianceId);
   callconsuctor();
   
   
   doorTagCompliance.Compliance_Agent__c = userId ;  
   inputMode = true;
   outputMode = false;
   
   If(dtsComplianceId != Null)
   {
      doorTagCompliance = [SElECT Id,User_Address_For_Compliance__c , Person_Account__c,Account_Phone__c,Account_Mobile__c,Person_Email__c, TCPA_Response__c,
                          Survey_Details__c,Compliance_Agent__c,Call_Center_Agent__c,Compliance_Notes__c FROM Door_Tag_Script__c WHERE Id = :dtsComplianceId limit 1];
     
   }
   
}

// Fetching recently created Survey record.
public PageReference callconsuctor(){

  Id dtsRecTypeId = Schema.SObjectType.Door_Tag_Script__c.getRecordTypeInfosByName().get('nuHome Door Tag Compliance').getRecordTypeId();
  
  if(currentAccountId != Null)
  {
   doorTagInsList = [SELECT Id,Name,CreatedDate,Hidden_Consumer_Summary__c,Finishing_Date__c,Starting_Date__c,TCPA_Response__c,Account__c,Account__r.Name,Account__r.PersonEmail,Account__r.Primary_Shipping_Street__c,Account__r.Primary_Shipping_City__c,Account__r.Primary_Shipping_State__c,Account__r.Primary_Shipping_Country__c,
                    Account__r.Primary_Shipping_Zip_Code__c,Account__r.PrimaryShippingZip_Code_Plus_4_Lookup__c,Account__r.County__c,Account__r.verbal_consent__c,User_Address__c,User_Address__r.phone__c, User_Address__r.personmobilephone__c,
                    Account__r.Primary_Shipping_County__c,Account__r.Phone,Account__r.PersonMobilePhone,Box_Confirmation__c,Box_Confirmation_Email2__c,Box_Confirmation_Email__c,Consent__c,Are_you_the_homeowner__c,First_Home__c,New_Build__c,Different_State__c,
                    Cable_and_Internet_Service__c,Pest_Control__c,Landscape_Maintenance__c,Handyman__c,House_Cleaning__c,Carpet_Cleaning__c,Garage_Doors__c,Home_Security__c,Home_Automation__c,HVAC__c,Roofer__c,Plumbing__c,Electrical__c,Lockssmith__c,Do_you_have_a_Water_Softener__c,Kitchen_Remodeling__c,
                    Bathroom_Remodeling__c,Home_Remodeling__c,Granite_Marble__c,Blinds_Shutters__c,Flooring__c,Wood__c,Carpet__c,
                    Tile__c,Professional_Painting__c,Garage_Floor_Coating__c,Closet_Organizing__c,Solar_Power__c,Windows_Doors__c,Energy_Audit__c,Landscape_install__c,Lawn_and_Weed_Control__c,
                    Synthetic_grass_interested__c,Deck_Patio_Awnings__c,Awning__c,Shed__c,Fencing__c,Gutters__c,Siding__c,Pool__c,New_Pool__c,Pool_Maintenance__c,Hot_Tub__c,Dentist__c,Chiropractor__c,
                    Identity_Theft__c,Health_Clubs_Crossfit__c,Spouse_Name__c,Auto_New_Car__c,Home_Warranty_Appliance_Protection__c,Mortgage_Protection__c,Estimated_Spend__c,Previous_Street__c,Previous_City__c,Previous_State__c,
                    Previous_Zip__c,Previous_Country__c,Appointment_Summary__c,Door_Tag_Compliance__C,Completed_Percentage__c  from Door_Tag_Script__c where User_Address__c=:currentUserAddressId and recordtypeId != :dtsRecTypeId  ORDER BY CreatedDate DESC Limit 1]; 
   system.debug('doorTagInsList size '+doorTagInsList.size());
   }
        
      if(doorTagInsList.size() == 0){
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'It should have atleast one Survey Records inorder to create Door Tag Compliance');
            ApexPages.addMessage(myMsg);
            return null;
            }
         if(doorTagInsList.size() > 0)
         {
             doorTagIns = doorTagInsList[0];
             doorTagCompliance.Account_Phone__c= doorTagIns.Account__r.Phone;
             doorTagCompliance.Account_Mobile__c= doorTagIns.Account__r.PersonMobilePhone;
             doorTagCompliance.person_email__c = doorTagIns.Account__r.PersonEmail;
             doorTagCompliance.Survey_Details__c = doorTagInsList[0].id;
             doorTagCompliance.person_account__c  = currentAccountId;
             doorTagCompliance.User_Address_For_Compliance__c = currentUserAddressId ;             
             doorTagCompliance.TCPA_Response__c = doorTagIns.consent__c;
             
         }
        createdDateStr = doorTagIns.Starting_Date__c != null ? doorTagIns.Starting_Date__c.format('MM/dd/yyyy hh:mm a') : null;
        finishedDateStr = doorTagIns.Finishing_Date__c != null ? doorTagIns.Finishing_Date__c.format('MM/dd/yyyy hh:mm a') : null;
        
      return null;

}
   
   // Creating Door Tag Compliance record.

    public pagereference SaveRec(){
    
       Id dtsRecTypeId = Schema.SObjectType.Door_Tag_Script__c.getRecordTypeInfosByName().get('nuHome Door Tag Compliance').getRecordTypeId();
       doorTagCompliance.recordTypeId = dtsRecTypeId;
       try
       {
          
          Upsert doorTagCompliance;
         
          Account updateAccount = new Account();
          Boolean updateAccountFlag;
          updateAccount.id = doorTagIns.account__c;
          if(doorTagIns.Account__r.verbal_consent__c !=doorTagCompliance.TCPA_Response__c)
          {
             
             updateAccountFlag = True;
             updateAccount.verbal_consent__c  = doorTagCompliance.TCPA_Response__c;
             
             
          }
          
          if(doorTagIns.Account__r.Phone != doorTagCompliance.Account_phone__c)
          {
               updateAccountFlag = True;
               updateAccount.phone= doorTagCompliance.Account_phone__c;
               
          }
          
         if(doorTagIns.Account__r.PersonMobilePhone != doorTagCompliance.Account_Mobile__c)
          {
               updateAccountFlag = True;
               updateAccount.PersonMobilePhone = doorTagCompliance.Account_Mobile__c;
               
          }
          
         if(doorTagIns.Account__r.PersonEmail != doorTagCompliance.Person_Email__c)
          {
               updateAccountFlag = True;
               updateAccount.PersonEmail = doorTagCompliance.Person_Email__c;
               
          }
          
          if(updateAccountFlag == true)
          {
              update updateAccount;
          }
          
          
         
          Door_Tag_Script__c updateScript = new Door_Tag_Script__c ();
          updateScript.id = doorTagIns.id;
          Boolean updateFlag;
          if(doorTagCompliance.Call_Center_Agent__c != Null)
          {
             updateScript.starting_agent__c = doorTagCompliance.Call_Center_Agent__c;
             updateFlag = true;
          }
          if(doorTagIns.consent__c !=doorTagCompliance.TCPA_Response__c)
          {
             updateScript.consent__c   = doorTagCompliance.TCPA_Response__c;
             updateFlag = true;
          }
          
          if(updateFlag == true)
            update updateScript;
            
            
            
          User_Address__c  updateUserAdd = new User_Address__c();
          updateUserAdd.id = doorTagIns.user_address__c;
          
          Boolean updateUserAddFlag;
          
          if(doorTagIns.user_address__r.phone__c != doorTagCompliance.Account_phone__c )
          {
             updateUserAddFlag = true;
             updateUserAdd.phone__c = doorTagCompliance.Account_phone__c;
          }
          
          if(doorTagIns.user_address__r.personmobilephone__c != doorTagCompliance.Account_mobile__c )
          {
             updateUserAddFlag = true;
             updateUserAdd.personmobilephone__c = doorTagCompliance.Account_mobile__c;
          }
          
          if(updateUserAddFlag == True)
          {
            update updateUserAdd;
          }
           
          PageReference reference=new PageReference('/apex/nuHome_DTS_View?id='+doorTagCompliance.id);
          reference.setRedirect(true);     
          return reference;
       }
       Catch(DMLException e)
       {
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,e.getmessage() );
           ApexPages.addMessage(myMsg);
       }
       
       
         return null;
    }
    // Redirect to Survey page.
     public pagereference EditRec(){
    
          PageReference reference=new PageReference('/apex/nuHome_statistics?id='+doorTagIns.id);
          reference.setRedirect(true);     
          return reference;
       
    }
    
    // Redirect to Survey page.
    public pagereference editSurveyFunc()
    {
    
          PageReference reference=new PageReference('/apex/nuHome_statistics?id='+doorTagIns.id);
          reference.setRedirect(true);     
          return reference;
    }
    
   
 }