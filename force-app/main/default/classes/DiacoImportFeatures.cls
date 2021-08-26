/*

 Diaco
 @author 			Jeison Hernandez Sanchez  href=<jeison14.99@gmail.com>
 Project:			Jitterbit Replacement
 Description:		Support the account import process
     
 Changes (Version)
 _________________________________________

            No.		Date			Author					Description
            ____	__________      ____________________    _____________________________________
@version	1.0		07/10/2019		Jeison Hernandez (JH)	Initial implementation  of the class.
*/
public with sharing class DiacoImportFeatures {
    @AuraEnabled
    public static List<csvRecord> GetCsvData(Id contentdocumentId) {
        try{
            List<ContentVersion> objVersion = [Select Id, VersionData FROM ContentVersion WHERE ContentDocumentId =: contentdocumentId];
            List<csvRecord> csvRecords = new List<csvRecord>();
            if(!objVersion.isEmpty()){
                String stringData = objVersion[0].VersionData.toString();
                String[] csvFileLines = stringData.split('\n');
                for(Integer i=1;i<csvFileLines.size();i++){
                    string[] csvRecordData = csvFileLines[i].split(',');
                    csvRecord rec = new csvRecord();
                    rec.index=i-1;
                    rec.Hometype=csvRecordData[0].replace('"','');
                    rec.iNew=csvRecordData[2].replace('"','');
                    rec.SalePrice=Double.valueOf(csvRecordData[3]!=''?csvRecordData[3]:'0');
                    rec.Down=Double.valueOf(csvRecordData[4]!=''?csvRecordData[4]:'0');
                    rec.Firstname=csvRecordData[5].replace('"','');
                    rec.Lastname=csvRecordData[6].replace('"','');
                    rec.address=csvRecordData[8].replace('"','');
                    rec.city=csvRecordData[9].replace('"','');
                    rec.state=csvRecordData[10].replace('"','');
                    rec.zip=csvRecordData[12].replace('"','');
                    List<String> temp = csvRecordData[13].replace('"','').split('/');
                    rec.iDATE=Date.valueOf(temp[2]+'-'+temp[0]+'-'+temp[1]);
                    rec.County=csvRecordData[16].replace('"','');
                    rec.FileNumber=csvRecordData[17].replace('"','');
                    csvRecords.add(rec);
                }
            }
            return csvRecords;
        }catch (Exception e){ throw new AuraHandledException(e.getMessage());}
    }
    
    public static void sendEmail(String Body, String[] targets){
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = targets;
       	message.optOutPolicy = 'FILTER';
        message.subject = 'Daily Import Register Log';
        message.plainTextBody = Body;
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
       	Messaging.SendEmailResult[] results =  new Messaging.SendEmailResult[]{};
       	if(!Test.isRunningTest()){results = Messaging.sendEmail(messages);}
        if (!results.isEmpty() && results[0].success) {
            System.debug('The email was sent successfully.');
        } else if(!results.isEmpty()){
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
    }
    
    @future(callout=true)
    public static void ImportRecords(Id CronId, String JobName){
        try{
            HttpRequest request = new httpRequest();
            request.setMethod('GET');
            request.setEndpoint('https://salesforcewebsiteapi.herokuapp.com/api/v1.0/IonImport');
            request.setHeader('Content-Type', 'application/json; charset=UTF-8');
            request.setHeader('Accept', 'application/json');
            request.setHeader('Connection','keep-alive');
            request.setHeader('origin','localhost:3001'/*URL.getSalesforceBaseUrl().toExternalForm()*/);
            system.debug(URL.getSalesforceBaseUrl().toExternalForm());
            httpResponse response = New Http().send(request);
            String body = response.getBody();
            String message = '';
            Boolean send = false;
            if(response.getStatusCode()==200){
                map<string,object> ok = (map<string,object>)JSON.deserializeUntyped(body);
                if(Boolean.valueOf(ok.get('ok'))){
                    List<Account> result1 = (List<Account>)JSON.deserialize(body.substring(body.lastIndexOf('"Accts":')).substringBetween('"Accts":',']')+']', List<Account>.class);
                    List<Address__c> result2 = (List<Address__c>)JSON.deserialize(body.substring(body.lastIndexOf('"Address":')).substringBetween('"Address":',']')+']', List<Address__c>.class);
                    List<User_Address__c> result3 = (List<User_Address__c>)JSON.deserialize(body.substring(body.lastIndexOf('"Uaddress":')).substringBetween('"Uaddress":',']')+']', List<User_Address__c>.class);
                    Integer repeatCount = Integer.valueOf(ok.get('repeatCount'));
                    Boolean options=true;
                    if(repeatCount>0){
                        String repeat = EncodingUtil.base64Decode(String.valueOf(ok.get('repeat'))).toString();
                        options=false;
                        String contractName = 'Import Duplicates - '+String.valueOf(Date.today());
                        ContentVersion cv = new ContentVersion();
                        cv.ContentLocation = 'S';
                        cv.PathOnClient = '.csv';
                        cv.Title = contractName;
                        cv.VersionData = blob.valueOf(repeat);
                        insert cv;
                        Id documentId = [Select contentdocumentId from ContentVersion where Id=:cv.Id].contentdocumentId;
                        message = 'Go to https://myhomeservices--preprod.lightning.force.com/lightning/n/Daily_Import_process\n'+
                                                'Ingrese el Id '+String.valueOf(documentId)+' en el componente';
                        send=true;
                    }
                    if(!result1.isEmpty() && !result2.isEmpty() && !result3.isEmpty()){
                        DiacoImportFeaturesSchedule p1 = new DiacoImportFeaturesSchedule();
                        p1.executionType=true;
                        p1.accounts=result1;
                        p1.address=result2;
                        p1.uaddress=result3;
                        p1.options=options;
                        Datetime tem = Datetime.now().addSeconds(15);
                        String cron = tem.second()+' '+tem.minute()+' '+tem.hour()+' '+tem.day()+' '+tem.month()+' ?';
                        system.schedule(JobName+'_inserts', cron, p1);
                    }
                }else{
                    if(!JobName.contains('_child')){
                        JobName = JobName+'_child';
                    }
                    switch on String.valueOf(ok.get('errorMessage')) {
                        when  'Email not found with the criteria' {
                            DiacoImportFeaturesSchedule p = new DiacoImportFeaturesSchedule();
                            Datetime tem = Datetime.now();
                            if(tem.hour()==9){
                                message = 'The Import file was not arrive yet, check manually';
                                send=true;
                            }
                            if(tem.hour()<10){
                                tem = tem.addMinutes(20);
                                String cron = tem.second()+' '+tem.minute()+' '+tem.hour()+' '+tem.day()+' '+tem.month()+' ?';
                            	system.schedule(JobName, cron, p);
                            }
                        }
                        when 'More than one file was retrieved' {
                            message = 'More than one file was retrieved, make Import process manually';
                            send=true;
                        }
                        when else {
                            message = 'A Error was capture: \n '+String.valueOf(ok.get('errorMessage'));
                            send=true;
                        }
                    }
                }
            }else{
                System.debug(body);
            }
            if(send){
                sendEmail(message,new String[] {'jeison14.99@gmail.com'});
            }
        }catch(Exception e){System.debug(e);}
    }
    
    @AuraEnabled
    public static string recordsInsert(List<Account> accounts, List<Address__c> address, List<User_Address__c> uaddress,Boolean options){
        try {
            List<DiacoImportFeaturesBatch.importPackage> packages = new List<DiacoImportFeaturesBatch.importPackage>();
            for (Integer i=0;i<accounts.size();i++){
                packages.add(new DiacoImportFeaturesBatch.importPackage(accounts[i],address[i],uaddress[i]));
            }
            DiacoImportFeaturesBatch bat = new DiacoImportFeaturesBatch(packages);
            if(options){
                bat = new DiacoImportFeaturesBatch(packages,options);
            }
            Database.executebatch(bat,50);
            return 'OK';
        } catch (Exception e) { throw new AuraHandledException(e.getMessage());}
    }

    @AuraEnabled
    public static void createDeliveries(){
        //Create Deliveries (Execute both query1 and query2)
        //Query 1
        String query1 = 'SELECT Id,Address__r.Branch__c,Address__r.Zip_code__c,CreatedDate,UserAccount__r.CreatedDate,Sales_Price__c,Recording_Date__c,Sale_Date__c,Assessed_Value__c FROM User_Address__c WHERE User_Address_Type__c = \'Primary Owner\' AND Active__c = true AND UserAccount__r.IsPersonAccount = true AND Address__r.Branch__r.name NOT IN (null,\'Invalid Zip Code\',\'ZZ-Not Mapped\',\'ZZ-No_Delivery\') AND (Sale_Date__c != null OR Recording_Date__c != null) AND (Address__r.Home_Type__c = \'SF\' OR Address__r.Home_Type__c = \'Sfr\') AND Id NOT IN (SELECT User_Address__c FROM Delivery_object__c WHERE Name = \'1\') ORDER BY CreatedDate DESC LIMIT 500000';
        //Query 2
        String query = 'SELECT Id,Name,fbranch__c,Hung_Status__c,Branch_Object__c,User_address__r.createddate,User_Address__r.Address__r.Branch__c,Delivery_Parameter__r.Days_Until_Next_Delivery__c,Delivery_Date__c,Person_Account__c,User_Address__r.Sales_Price__c,User_Address__r.Assessed_Value__c,User_Address__r.Address__r.Zip_Code__c,User_Address__r.Sale_Date__c,User_Address__r.Recording_Date__c,Person_Account__r.createddate,lastmodifieddate,User_Address__r.Respond_Date__c FROM Delivery_Object__c WHERE Hung_Status__c = \'Hung\' AND Delivery_Date__c != null AND Person_Account__r.isPersonAccount = true AND User_Address__r.Address__r.Branch__c != null AND (User_Address__r.Sale_Date__c != null OR User_Address__r.Recording_Date__c != null) AND User_Address__r.Respond_Date__c = null AND IsRecent__c = true';

		/*
        List<SObject> lstObjects1 = Database.query(query1);

        List<SObject> lstObjects2 = Database.query(query);
        Integer totalType1 =  execute(lstObjects1).size();
        Integer totalType2 = execute(lstObjects2).size();
        Long totalImported = totalType1 + totalType2;
        String channelName = label.InternalChannelName;
        String message = 'Import Report \n Total imported tipo 1: --> '+ totalType1 + '\n Total imported tipo 2: --> '+ totalType2 + '\n Total imported: --> '+ totalImported;
        diaco__diacoSlackApp__c app = [select Id, name, diaco__tokenApp__c, diaco__byDefault__c
        from diaco__diacoSlackApp__c
        where Name = :label.InternalAppSlackName];*/
        database.executebatch(new CreateDeliveryTwoRecordsForPA(query),200); //Maximum batch size is 200.
        Database.Executebatch(new CreateDeliveryOneRecordsForPA(query1),200); //Maximum batch size is 200
        /*String paramType1 = '1';
        String paramType2 = '2';
        String queryType1 = 'SELECT Id,Name from Delivery_Object__c where Name = :paramType1 and CreatedDate >= TODAY';
        String queryType2 = 'SELECT Id,Name from Delivery_Object__c where Name = :paramType2 and CreatedDate >= TODAY';
*/

		/*
        try {
            diaco.diacoHttpRequestsToSlack.slackSendMessage(channelName, message, app.id);
        }
        catch(Exception e) {
            System.debug('ErrorMessage-->' + e.getMessage() + 'TraicingError-->'+e.getStackTraceString());
        }*/
    }

	/*
    public static  List<Delivery_Object__c>  execute(List<User_Address__c> userAddressList) {

        List<Delivery_Object__c> deliveriesToInsert = new List<Delivery_Object__c>();
        Map<Id,User_Address__c> userAddressMap = new Map<Id,User_Address__c>();
        Map<String,Delivery_Parameter__c> branchWithDeliveryParam = new Map<String,Delivery_Parameter__c>();
        Set<Id> branchIds = new Set<Id>();

        // Get all the accounts has no delivery records associated to it. Also get the branch of the account
        for(User_Address__c userAddress : userAddressList){
            userAddressMap.put(userAddress.Id,userAddress);
            branchIds.add(userAddress.Address__r.Branch__c);
        }

        // Get the delivery parameter record based on the branch of the account.
        if(branchIds.size() > 0){
            List<Delivery_Parameter__c> deliveryParamList = [SELECT Id,Branch__c,Branch__r.Name,Included_ZipCodes__c,Min_Sales_Price__c,
                    Max_Sales_Price__c,Create_Date_in_SFDC__c,Close_Date__c,Delivery_Number__c ,Selected_Products__c FROM
                    Delivery_Parameter__c WHERE Active__c = true AND Branch__r.Branch_stage__c = 'Delivering' AND Branch__c IN: branchIds order by Delivery_Number__c ASC ];
            if(deliveryParamList.size() > 0){
                for(Delivery_Parameter__c deliveryParam : deliveryParamList){
                    if(!branchWithDeliveryParam.containsKey(deliveryParam.Branch__c)){
                        branchWithDeliveryParam.put(deliveryParam.Branch__c,deliveryParam);
                    }
                }
            }
        }
        // Create the delivery records based on the appropriate account values
        if(userAddressMap.size() > 0 && branchWithDeliveryParam.size() > 0 ){
            //System.debug('##accountMap: '+accountMap.keyset());
            for(Id userAddressId : userAddressMap.keyset()){
                User_Address__c userAddress = userAddressMap.get(userAddressId);
                //System.debug('##UtilClass.validateAccAddress(account): '+UtilClass.validateAccAddress(account));

                if(branchWithDeliveryParam.containskey(userAddress.Address__r.Branch__c)){
                    Delivery_Parameter__c deliveryParam = branchWithDeliveryParam.get(userAddress.Address__r.Branch__c);
                    // Check if the Zip code of the account is included in the Delivery parameter or not.
                    if(deliveryParam.Included_ZipCodes__c != null && deliveryParam.Included_ZipCodes__c.contains(userAddress.Address__r.Zip_Code__c)){
                        //Check the sales price/Assessed value of the account is in the minimum and maximum price range of the delivery parameter.
                        Decimal price = userAddress.Sales_Price__c != null ? userAddress.Sales_Price__c : (userAddress.Assessed_Value__c != null ? userAddress.Assessed_Value__c : 0.0);
                        // Date tempDate = userAddress.Sale_Date__c != null ? userAddress.Sale_Date__c : userAddress.Recording_Date__c ;
                        Date tempDate;
                        //Either of sale date or Recording date must have value, because we have add this initial query condition
                        if(userAddress.Sale_Date__c != Null && userAddress.Recording_Date__c != Null ){
                            tempDate = (userAddress.Sale_Date__c > userAddress.Recording_Date__c ? userAddress.Sale_Date__c : userAddress.Recording_Date__c);
                        }else{
                            tempDate = userAddress.Sale_Date__c != null ? userAddress.Sale_Date__c : userAddress.Recording_Date__c;
                        }
                        //Check the created date and the recording date of the account falls on the future date when compared to the 'Close date'
                        // and 'Create Date in SFDC' field values in the related delivery parameter record.
                        if((price != 0.0 ?  price <= deliveryParam.Max_Sales_Price__c && price >= deliveryParam.Min_Sales_Price__c : price == 0.0)
                                && userAddress.CreatedDate >= deliveryParam.Create_Date_in_SFDC__c && tempDate!= Null && tempDate >= deliveryParam.Close_Date__c){
                            deliveriesToInsert.add(new Delivery_Object__c(Person_Account__c = userAddress.UserAccount__c, User_Address__c = userAddress.Id,Name = String.valueOf((Integer)deliveryParam.Delivery_Number__c),Delivery_Parameter__c = deliveryParam.id, Product_Details__c = UtilClass.genarateJson(deliveryParam.Selected_Products__c),Branch_Object__c = deliveryParam.Branch__c,
                                    Parent_Gift_Card_Order__c = UtilClass.getCheetahGiftCardOrderId(),Driver__c = UtilClass.getDriverId('Cheetah','Driver')));
                        }
                    }
                }
            }
        }
        // Create delivery record
       return deliveriesToInsert;
    }*/
    public class csvRecord{
        
        @AuraEnabled
        public Integer index {get;set;}
        @AuraEnabled
        public String Hometype {get; set;}
        @AuraEnabled
        public String iNew {get;set;}
        @AuraEnabled
        public Double SalePrice {get;set;}
        @AuraEnabled
        public Double Down {get;set;}
        @AuraEnabled
        public String Firstname {get;set;}
        @AuraEnabled
        public String Lastname {get;set;}
        @AuraEnabled
        public String address {get;set;}
        @AuraEnabled
        public String city {get;set;}
        @AuraEnabled
        public String state {get;set;}
        @AuraEnabled
        public String zip {get;set;}
        @AuraEnabled
        public Date iDATE {get;set;}
        @AuraEnabled
        public String County {get;set;}
        @AuraEnabled
        public String FileNumber {get;set;}
    }
}