/********************************************************
Description : It will return the record types values dynamically based on the input parameter.
********************************************************/

Public class UtilClass{
    //Used to store some default driver record Id.
    static Id driverId;  
    //Used to verify incoming driver name and its contains combination of driver firstname & driver lastname
    static string tempDriverName;
    //Used to store cheetah Gift Card Order Id.
    static Id cheetahGiftCardOrderId;
    //Used to verify incoming products are same or not
    static String tempSelectedProducts;
    //
    static String jsonProductNames;
    //Used to store branchId for given branch name
    static Id branchId;
    //Used to verify incoming branch is same or not
    static String tempBranchName;
    
    // It will return record type info based on the input object.
    public static Map<Id,String> getRecordTypeDetails(String objectname){
        Schema.DescribeSObjectResult sobjectResult = Schema.getGlobalDescribe().get(objectname).getDescribe();
        List<Schema.RecordTypeInfo> recordTypeInfo = sobjectResult.getRecordTypeInfos();
        Map<Id,String> mapofCaseRecordTypeNameandId = new Map<Id,String>();
        for(Schema.RecordTypeInfo info : recordTypeInfo){
            mapofCaseRecordTypeNameandId.put(info.getRecordTypeId(),info.getName());
        }
        return mapofCaseRecordTypeNameandId;
    }
    //Used to get the driver id by passing firstName & lastName. Since we have some default driver in our Nuhome so,
    //Driver = Cheetah (first name) Driver (last name) => To get cheetah driver id
    //Driver = Invalid (first name) Driver (last name) => To get Invalid driver id
    public static Id getDriverId(String firstName,String lastName){
        if(tempDriverName == firstName+lastName){
            return driverId;
        }
        else{
            List<Driver__c> driverList = [SELECT Id,First_Name__c,Last_Name__c FROM Driver__c WHERE First_Name__c =: firstName AND Last_Name__c =: lastName];   
            if(driverList.size() > 0){                
                tempDriverName = driverList.get(0).First_Name__c+driverList.get(0).Last_Name__c;
                driverId = driverList.get(0).id;
            }
        }
        return driverId;
    }
    //Used to get the Cheetah Gift Card Order id
    public static Id getCheetahGiftCardOrderId(){
        if(cheetahGiftCardOrderId == null){
            List<Gift_card_orders__c> giftCardOrderList = [SELECT Id,Name FROM Gift_Card_Orders__c WHERE Name = 'Cheetah Gift Card Order'];
            if(giftCardOrderList.size() > 0){
                cheetahGiftCardOrderId = giftCardOrderList.get(0).id;
            }
        }
        return cheetahGiftCardOrderId;
    }
    //Used to get selected values from selectList
    public static String getValuesFromSelectList(List<SelectOption> selectedValues){
        Boolean first = true;
        String values;
        if(selectedValues.size() > 0){
            for ( SelectOption so : selectedValues ) {
                if(!first){
                    values += ',' + so.getlabel();
                }
                else{
                    values = so.getlabel(); 
                }            
                first = false;
            }
        }
        else{//No values in selectedValues then return empty.
            values = '';
        } 
        return values;
    }
    //Used to validate user account address
    public static boolean validateAccAddress(Account acc){
        if(acc.Primary_Shipping_City__c != null && acc.Primary_Shipping_Country__c != null && acc.Primary_Shipping_State__c != null
           && acc.Primary_Shipping_Zip_Code__c != null && acc.Primary_Shipping_Street__c != null){
               return true;
           }
        return false;
    }
    public static string genarateJson(String StrToJson){
        if(StrToJson == null){
            return null;
        }
        if(tempSelectedProducts == StrToJson){
            return jsonProductNames;
        }
        else{
            tempSelectedProducts = StrToJson;
            Set<String> productNames = new Set<String>();
            productNames.addAll(StrToJson.split(','));
            List<Delivery_Product__c> prodList = [SELECT id,name FROM Delivery_Product__c WHERE Name =: productNames];
            if(prodList.size() > 0){
                jsonProductNames = json.serialize(prodList);  
            }
        }
        return jsonProductNames;
    }
    //Used to get the Cheetah Gift Card Order id
    public static Id getBranchId(String branchName){
        if(tempbranchName == branchName){
            return branchId;
        }
        else{
            List<Branch__c> branchList = [SELECT Id,name FROM Branch__c WHERE Name =: branchName];
            if(branchList.size() > 0){
                tempbranchName = branchList.get(0).name;
                branchId = branchList.get(0).id;
            }            
            return branchId;
        }
    }
    //Used to format the given phone number. Fg, (987) 654-3211  
    public static string getPhoneFormat(String phone){
        Pattern p = Pattern.compile('[-() ]');
        String tempPhone = p.matcher(Phone).replaceAll('');
        if(tempPhone.length() == 10){
            return '('+tempPhone.substring(0, 3) + ') '+tempPhone.substring(3, 6) + '-' + tempPhone.substring(6, 10);
        }
        return null;
    }
}