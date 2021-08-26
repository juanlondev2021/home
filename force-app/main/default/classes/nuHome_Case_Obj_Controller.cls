/**************************************************************************************************************
Created By:MST Solutions.
Description : This is the controller for nuHome Case, nuHome Case Comment, nuHome Case Create visualforce pages.
***************************************************************************************************************/

public class nuHome_Case_Obj_Controller {
    public String RecordType{get;set;}
    public String PageUrl{get;set;}
    public String caseIdFromurl{get;set;}
    public List<parseCase.cls_records> caseList1{get;set;}
    public List<parseCasecomment.cls_records> casecommentList1{get;set;}
    public String casecommentstring{get;set;}
    public String caseId{get;set;}
    public String createdByid{get;set;}
    public Map<String,parseCase.cls_records> caseMap;
    Public parseCase.cls_records wrapins{get;set;}
    public boolean showComment{get;set;}
    public string commentId{get;set;}
    public string commentBody{get;set;}
    public string tempcommentBody{get;set;}
    public boolean editCommentBody {get;set;}
    public Case caseObj{get;set;}
    
    public nuHome_Case_Obj_Controller() {
        //Create wrapper class(parseCase) list and get the list of cases by calling nuHome_Case_API.getCasemethod method.
        caseList1 = NEW List<parseCase.cls_records>();
        caseList1 = nuHome_Case_API.getCasemethod();
        caseId = apexpages.currentpage().getparameters().get('id');
        caseMap = new Map<String,parseCase.cls_records>();
        createdByid = userinfo.getuserid();
        PageUrl = String.valueof(URL.getSalesforceBaseUrl().toExternalForm());
        //Creating Map with list of cases with id as key for the purpose to getting particular record for processing.
        for(parseCase.cls_records parse:caseList1){
            caseMap.put(parse.Id,parse);
        }
        if(!caseMap.isEmpty() && caseMap.containskey(caseId)){
            wrapins = caseMap.get(caseId);
        }
    }
    
    //Get the Record types for Case object and display in new case create visualforce page.
    public list<selectoption> GetTypeValues(){
        List<SelectOption> options = new List<SelectOption>();
        for(recordtype records:[select Id,Name from recordtype where SobjectType='Case']){
            options.add(new SelectOption(records.Id,records.Name));
        }
        return options;
    }
    //Rendering the comment Section
    public void showComment(){
        showComment = true;
    }
    
    //Redirect the control to case edit page with the case id in the url.
    public PageReference redirectEditpage(){
        PageReference ref = new PageReference('/apex/nuHome_Case_Edit?id=' +wrapins.id);
        return ref;
    }
    
    //Create comment in case comment object by seding the caseId and its comment string to webservice method setCommentmethod
    public pageReference Comment(){
        casecommentstring =  'Created By: '+UserInfo.getFirstname()+' '+UserInfo.getLastName()+' ('+System.now()+') || '+casecommentstring ;
        caseIdFromurl = nuHome_Case_API.setCommentmethod(apexpages.currentpage().getparameters().get('id'),casecommentstring);
        if(caseIdFromurl.contains('"success":true')){
            pageReference pgRef = new pageReference('/apex/nuHome_Case_Comment?id='+caseId );
            pgRef.setRedirect(True);
            return pgRef;
        }
        else
            return NULL;
    }
    //This method is to update the case comment object record.
    public pageReference updateComment(){
         
        String splitter1 = commentBody.substringBefore('||');
        String Splitter2 = commentBody.substringAfter('||');
        String Joiner =  'Updated By: '+UserInfo.getFirstname()+' '+UserInfo.getLastName()+' ('+System.now()+') ';
        
        commentBody = tempcommentBody +' || ' + Joiner + ' || ' + Splitter2 +' '+ splitter1;
        nuHome_Case_API.commentPatch(commentId,commentBody);
        pageReference pgRef = new pageReference('/apex/nuHome_Case_Comment?id='+caseId );
        pgRef.setRedirect(True);
        return pgRef;
        //return NULL;
    }
    
    //This method is to delete the case comment object record.
    public pageReference deleteComment(){
        nuHome_Case_API.commentDelete(commentId);
        pageReference pgRef = new pageReference('/apex/nuHome_Case_Comment?id='+caseId );
        pgRef.setRedirect(True);
        return pgRef;
    }
    
    //This method is to edit the case comment object record.
    public pageReference editComment(){
        
        List<String> parts = commentBody.split('\\|\\|');
        tempcommentBody = parts[0];
        commentBody = parts[parts.size()-1];
        
        editCommentBody = true; 
        return NULL;
    }
    //Get the current case id and store it in casecommentList1 variable.
    public void getComment(){
        casecommentList1 = NEW List<parseCasecomment.cls_records>();
        casecommentList1 = nuHome_Case_API.getcommentlistmethod(apexpages.currentpage().getparameters().get('id'));
    }
    
    
    public pageReference newCase()
    {
          pageReference pgRef = new pageReference('https://nuhome.secure.force.com/index/nuHome_WebtoCase?userId='+userInfo.getUserId());
          pgRef.setRedirect(True);
          return pgRef; 
    }
}