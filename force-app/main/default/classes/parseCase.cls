/**************************************************************************************************************
Created By:MST Solutions.
Description : Wrapper class to deserialize the case records from webservice api response .
***************************************************************************************************************/

public class parseCase{
    
    public Integer totalSize;   //10
    public boolean done;
    public List<cls_records> records;
    
    public parseCase(){
        
    }
    
    public class cls_records {
        
        
        
        public boolean IsDeleted{get;set;} 
        public String CaseNumber{get;set;}   //00001007
        public String ContactId{get;set;}    //0037A000005q2ppQAA
        public String Contact_Name{get;set;}
        public String AccountId{get;set;}    //0017A000004DM53QAG
        public String EntitlementId{get;set;} 
        public String RecordTypeId{get;set;}
        public String vf_owner{get;set;}
        public String Type{get;set;} //Problem
        public String Reason{get;set;} 
        public String Status{get;set;}  //New
        public String Origin{get;set;}    //Phone
        public String Subject{get;set;}  //how to
        public String Description{get;set;} 
        public String Priority{get;set;} //High
        public boolean IsClosed{get;set;} 
        public String ClosedDate{get;set;} 
        public String OwnerId{get;set;}  //0057A000000WoGTQA0
        public String SlaStartDate{get;set;} 
        public String SlaExitDate{get;set;} 
        public String CreatedDate{get;set;}  //2015-11-27T10:52:04.000+0000
        public String CreatedById{get;set;}   //0057A000000WoGTQA0
        public String MilestoneStatus{get;set;}   //
        public string Sub_Type{get;set;}
        public string Account_Name{get;set;}
        public String Id{get;set;}  //5007A000000mNPCQA2
        
        public cls_attributes attributes{get;set;}
        
    }
    
    
    public class cls_attributes {
        public String type; //Case
        public String url;  ///services/data/v20.0/sobjects/Case/5007A000000mNPCQA2
    }
    
    public static parseCase parse(String json){
        
        json = json.replaceall('Contact_Name__c','Contact_Name');
        json = json.replaceall('vf_owner__c','vf_owner');
        json = json.replaceall('Account_Name__c','Account_Name');
        return (parseCase) System.JSON.deserialize(json, parseCase.class);
    }
}