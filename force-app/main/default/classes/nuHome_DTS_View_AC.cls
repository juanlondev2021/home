/*****************************************************************************
Created by: MST
Description : This will display nuhome Door Tag Script and Door Tag Compliance details on View page.
Based on the record type, it will render the details.

******************************************************************************/


public class nuHome_DTS_View_AC{
    
    
    public string dtsId{get;set;}
    public Door_Tag_Script__c survey{get;set;}
    public Door_Tag_Script__c surveyComp{get;set;}
    public boolean displayDTS{get;set;}
    public boolean displayCompliance{get;set;}
    public Id userId{get;set;}
    public String createdDateStr{get;set;}
    public String finishedDateStr{get;set;}
    public string currUserName{get;set;}

    Public Decimal SQFT{get;set;}
    Public String yearBuilt{get;set;}
    Public String yesOnly{get;set;}   
    Public List<Property__c> propertyList{get;set;}    
    public User_Address__c userAddrerss{get;set;}
    public Address__c address{get;set;}
    Public Boolean outboundFlag{get;set;}
    public Account masterAcc{get;set;}
    public String currentUser{get;set;}
    
    public List<DTSQuestion__c> DTSVerbiageList{get;set;}
    public DTSQuestion__c DTSVerbiage{get;set;}
    
    Public List<DTSQuestion__c> DTSQuestionsConfirmEmail{get;set;}
    Public List<DTSQuestion__c> DTSQuestionsSection1{get;set;}
    Public List<DTSQuestion__c> DTSQuestionsSection2{get;set;} 
    Public List<DTSQuestion__c> DTSQuestionsSection3{get;set;}
    Public List<DTSQuestion__c> DTSQuestionsSection4{get;set;}
    Public List<DTSQuestion__c> DTSQuestionsSection5{get;set;}
    Public List<DTSQuestion__c> DTSQuestionsOutbound{get;set;}
    Public List<DTSQuestion__c> DTSQuestionsInbound{get;set;}
    
    public nuHome_DTS_View_AC(ApexPages.StandardController stdController)
    {
       currentUser = UserInfo.getName(); 
       outboundFlag = false;
        
        DTSVerbiage = New DTSQuestion__c();
        DTSVerbiageList = New List<DTSQuestion__c>();
        
        DTSQuestionsConfirmEmail = New List<DTSQuestion__c>();
        DTSQuestionsSection1 = New List<DTSQuestion__c>();
        DTSQuestionsSection2 = New List<DTSQuestion__c>();
        DTSQuestionsSection3 = New List<DTSQuestion__c>();
        DTSQuestionsSection4 = New List<DTSQuestion__c>();
        DTSQuestionsSection5 = New List<DTSQuestion__c>();
        DTSQuestionsOutbound = New List<DTSQuestion__c>();
        DTSQuestionsInbound = New List<DTSQuestion__c>();
        
        List<Profile> profileList = [SELECT Id,Name FROM Profile WHERE Id =: userInfo.getProfileId()];
        List<UserRole> roleList = [SELECT Id,Name FROM UserRole WHERE Id = : userInfo.getUserRoleId()];
        String queryFilter = '';
        if(profileList.size() > 0){
            String roleName = '';
            if(roleList.size() > 0)
                roleName = roleList[0].Name;
            String profileName = profileList[0].Name;
            if(profileName == 'NuHome OBCC Supervisor' || profileName == 'NuHomes: Force - Call Agents OB'
               || profileName == 'NuHomes: OB CC Sales' || profileName == 'NuHomes: Force - Confirmation Agent OB' || roleName.indexOf('OB') != -1){
                outboundFlag = true;
                queryFilter = 'Outbound';
               }
            else{
                outboundFlag = false;
                queryFilter = 'Inbound';                
            }
        }
        //Developement purpose
        //outboundFlag = true;
        //queryFilter = 'Outbound';
        //Developement purpose
        address = new Address__c();
        userAddrerss = new User_Address__c();
        surveyComp = New Door_Tag_Script__c();

        String query = '';
        String soqlQuery = 'SELECT Id,Section__c,FieldAPIName__c,PopupHelperClass__c,Industry__c,Order__c,Question__c,'+
                'OrderOutbound__c,QuestionOutbound__c,Section1Title__c,Section1_PreScript__c,Section1PostScript__c,Section2_Title__c,'+
                'Section2_PreScript__c,Section2_PostScript__c,Section3_Title__c,Section3_PreScript__c,Section3_PostScript__c,Section4_Title__c,'+
                'Section4_PreScript__c,Section4_PostScript__c,Section5_Title__c,Section5_PreScript__c,Section5_PostScript__c,Verbiage_Type__c,'+
                'DTSQuestion_Type__c,Question_Pretext__c,GiftBoxConfirmationQuestion__c,ConfirmationYes__c,Confirmation_No__c,'+
                'OutboundAgentSection1__c,ConfirmEmailSectionTitle__c,ConfirmEmailSectionPreScript__c,ConfirmEmailSectionPostScript__c,'+
                'Consent__c,OutboundAgentPostScript__c,InboundScriptTitle__c,InboundPreScript__c,InboundPostScript__c,SearsTransferTitle__c,'+
                'SearsTransferVerbage__c,ClosingSectionTitle__c,ClosingSectionVerbage__c FROM DTSQuestion__c ORDER BY Order__c,LastModifiedDate';
        
        for(DTSQuestion__c DTQ:Database.query(soqlQuery)){
            if( DTQ.Verbiage_Type__c == 'Inbound' || DTQ.Verbiage_Type__c == 'Outbound' ){
                if(outboundFlag && DTQ.Verbiage_Type__c == 'Outbound')
                    DTSVerbiageList.add(DTQ);
                if(outboundFlag == false && DTQ.Verbiage_Type__c == 'Inbound')
                    DTSVerbiageList.add(DTQ);
                
            }else If( DTQ.DTSQuestion_Type__c == queryFilter ){
                                
                If(DTQ.Section__c == 'Confirm Email')
                    DTSQuestionsConfirmEmail.add(DTQ);
                If(DTQ.Section__c == 'Section 1')
                    DTSQuestionsSection1.add(DTQ);
                If(DTQ.Section__c == 'Section 2')
                    DTSQuestionsSection2.add(DTQ);
                If(DTQ.Section__c == 'Section 3')
                    DTSQuestionsSection3.add(DTQ);
                If(DTQ.Section__c == 'Section 4')
                    DTSQuestionsSection4.add(DTQ);
                If(DTQ.Section__c == 'Section 5')
                    DTSQuestionsSection5.add(DTQ);
                If(DTQ.Section__c == 'Outbound')
                    DTSQuestionsOutbound.add(DTQ);
                If(DTQ.Section__c == 'Inbound')
                    DTSQuestionsInbound.add(DTQ);
            }
        }
       

        //Test class skipping for addFields
        List<DTSQuestion__c> fieldSetAllList = New List<DTSQuestion__c>();
        List<String> fieldList = New List<String>();
        fieldSetAllList.addAll(DTSQuestionsConfirmEmail);
        fieldSetAllList.addAll(DTSQuestionsSection1);
        fieldSetAllList.addAll(DTSQuestionsSection2);
        fieldSetAllList.addAll(DTSQuestionsSection3);
        fieldSetAllList.addAll(DTSQuestionsSection4);
        fieldSetAllList.addAll(DTSQuestionsSection5);
        fieldSetAllList.addAll(DTSQuestionsOutbound);
        fieldSetAllList.addAll(DTSQuestionsInbound);
        for(DTSQuestion__c DTS:fieldSetAllList){
                fieldList.add(DTS.FieldAPIName__c);
            }
        fieldSetAllList.clear();
        if (!Test.isRunningTest()) {
            stdController.addFields(new List<String>{'Survey_Details__c','IdentityTheftCreated__c','Account__c','User_Address__c','createdDate','Starting_Agent__c','Finishing_Agent__c','Starting_Date__c','Finishing_Date__c'});
            stdController.addFields(fieldList);
            stdController.addFields(new List<String>{'DailyCallCount__c','Last_Disposition_Date_Time__c','Call_Count__c','DispostionUser__c','Disposition_Date_Time__c','Disposition__c','Account__c','Identity_Theft__c','LifeLock__c','User_Address__c','CreatedDate','Starting_Agent__c','Finishing_Agent__c','Starting_Date__c','Finishing_Date__c'});
        }
        survey = (Door_Tag_Script__c)stdController.getRecord();
        system.debug('survey.survey_details__c value'+survey.survey_details__c);
        if(survey.survey_details__c != Null){
            String SoqlQuery2 = 'SELECT Id'+query+' FROM Door_Tag_Script__c WHERE Id=\''+survey.survey_details__c+'\'';
            system.debug('SoqlQuery'+SoqlQuery2);
            surveyComp = Database.query(SoqlQuery2);
        }
        userAddrerss = getUserAddress(this.survey.User_Address__c);        
        if(userAddrerss != Null){
            masterAcc = getAccount(userAddrerss.UserAccount__c); 
            address = getAddress(userAddrerss.Address__c);
            if(address != Null)
                propertyList = [SELECT Id,SQFT__c,Year_Built__c FROM Property__c WHERE Address__c = :address.Id];
        }
        
        List<DTSQuestion__c> DTSVerbiageList2 = New List<DTSQuestion__c>();
        for(DTSQuestion__c DTQ:DTSVerbiageList){
            String replaceName = DTQ.InboundPreScript__c;
            String outboundName = DTQ.OutboundAgentSection1__c;
            String outboundName2 = DTQ.OutboundAgentPostScript__c;
            String searsVerbiage = DTQ.SearsTransferVerbage__c;
            String giftBox = DTQ.GiftBoxConfirmationQuestion__c;
			system.debug('giftBox '+giftBox);
            if(survey.Starting_Agent__c != Null){
                system.debug('survey.Starting_Agent__r.Name value'+survey.Starting_Agent__r.Name);
                if( giftBox != '' && survey.Starting_Agent__r.Name != Null )
                    DTQ.GiftBoxConfirmationQuestion__c = giftBox.replace('<<First Agent>>', survey.Starting_Agent__r.Name);
            }
            if( searsVerbiage != Null )
                DTQ.SearsTransferVerbage__c = searsVerbiage.replaceAll('&lt;&lt;Name&gt;&gt;',masterAcc.Name);
            if( replaceName != Null )
                DTQ.InboundPreScript__c = replaceName.replace('&lt;&lt;Name&gt;&gt;',masterAcc.Name);
            if( outboundName != Null ){
                String currentUser1 = outboundName.replace('&lt;&lt;Name&gt;&gt;',masterAcc.Name);
                String agentName = currentUser1.replace('&lt;&lt;Agent Name&gt;&gt;', currentUser);
				if( survey.Starting_Agent__r.Name != Null )
                    DTQ.OutboundAgentSection1__c = agentName.replace('&lt;&lt;First Agent&gt;&gt;', survey.Starting_Agent__r.Name);
                else
                    DTQ.OutboundAgentSection1__c = agentName;
                }
            if( outboundName2 != Null )
                DTQ.OutboundAgentPostScript__c = outboundName2.replaceAll('&lt;&lt;Name&gt;&gt;', masterAcc.Name);
            DTSVerbiageList2.add(DTQ);
        }               

        if(DTSVerbiageList2.size() > 0)
            DTSVerbiage = DTSVerbiageList2[DTSVerbiageList2.size()-1];
        DTSVerbiageList2.clear();
        DTSVerbiageList2.addAll(DTSQuestionsOutbound);
        DTSQuestionsOutbound.clear();
        for(DTSQuestion__c DTQ:DTSVerbiageList2){
            String question = DTQ.Question__c;
            if(question != Null){
                String temp = question.replaceAll('<<Name>>', masterAcc.Name);
                if( survey.Starting_Agent__r.Name != Null )
                    DTQ.Question__c = temp.replaceAll('<<Starting Agent Name>>', survey.Starting_Agent__r.Name);
                else
                    DTQ.Question__c = temp;
            }
            DTSQuestionsOutbound.add(DTQ);
        }
        
        Id complianceRecordTypeId = Schema.SObjectType.Door_Tag_Script__c.getRecordTypeInfosByName().get('nuHome Door Tag Compliance').getRecordTypeId();
        system.debug('propertyList value'+propertyList);
        if(!propertyList.isEmpty()){
            SQFT = propertyList[0].SQFT__c;
            yearBuilt = propertyList[0].Year_Built__c;
        }
        
        
        userId = UserInfo.getUserId();
        currUserName = UserInfo.getName();
        if(survey.id != Null)
        {
            if(survey.recordtypeId == complianceRecordTypeId)
            {
                displayCompliance = True;
                //survey =  [SELECT id,person_account__c,survey_details__c,Restaurants__c from Door_Tag_Script__c WHERE Id = :survey.id];
                
            }
            
            else
            {
                displayDTS = True;
                //survey =  [SELECT id,Starting_Date__c,Finishing_Date__c, person_account__c from Door_Tag_Script__c WHERE Id = :survey.id];
                createdDateStr = this.survey.Starting_Date__c != null ? this.survey.Starting_Date__c.format('MM/dd/yyyy hh:mm a') : null;
                finishedDateStr = this.survey.Finishing_Date__c != null ? this.survey.Finishing_Date__c.format('MM/dd/yyyy hh:mm a') : null;
            }
            
            
        }
        
    }
    
    //Fetching account records.    
    public Account getAccount(String accId) {        
        List<Account> acc = [SELECT Id,Branch__c,PersonEmail,PersonContactId, verbal_consent__c, Name,Owner.Name,Primary_Shipping_Street__c, Primary_Shipping_City__c, Primary_Shipping_State__c, Primary_Shipping_Country__c, Primary_Shipping_Zip_Code__c, PrimaryShippingZip_Code_Plus_4_Lookup__c, County__c, Primary_Shipping_County__c, Phone,PersonMobilePhone from Account where ID=: accId];
        if(acc != null && acc.size() > 0){
            return acc.get(0);
        }
        return null;
    }
    
    // Fetching User Address Records.
    public User_Address__c getUserAddress(String userAddressId) {
        List<User_Address__c> userAddressLst = [SELECT id, UserAccount__c, Address__c,X1st_IB_Agent__c , Name FROM User_Address__c WHERE id =: userAddressId];        
        if(userAddressLst != null && userAddressLst.size() > 0){
            return userAddressLst.get(0);
        }
        return null;
    }
    
    // Fetching  Address Records.
    public Address__c getAddress(String addressId) {
        List<Address__c> addressLst = [SELECT id,City__c,Branch__r.name ,Zip_Plus_Four__c ,County__c,Country__c,State__c,Street__c,Zip_Code__c FROM Address__c WHERE id =: addressId];        
        if(addressLst != null && addressLst.size() > 0){
            return addressLst.get(0);
        }
        return null;
    }
    public pagereference Edit()
    {
        
        if(displayCompliance == True)
        {
            
            PageReference reference=new PageReference('/apex/nuHome_DoorTagCompliance?id='+survey.id+'&accountId='+survey.person_account__c);
            reference.setRedirect(true);     
            return reference;
            
        }
        else
        {
            
            PageReference reference=new PageReference('/apex/nuHome_statistics?id='+survey.id);
            reference.setRedirect(true);     
            return reference;
        }
        
        
    }
    
    
    public pagereference editSurvey()
    {
        
        PageReference reference=new PageReference('/apex/nuHome_statistics?id='+survey.survey_details__c);
        reference.setRedirect(true);     
        return reference;
        
    }
    
    
    
    
}