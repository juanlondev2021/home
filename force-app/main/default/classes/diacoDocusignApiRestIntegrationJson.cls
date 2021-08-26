public class diacoDocusignApiRestIntegrationJson {
    
    public static String Completion_Certificate_Template(String homeserviceId, String templateId ){
        
        Integer I = Date.today().toStartOfWeek().daysBetween(Date.today().addDays(3));
        Date dat1 = Date.today().addDays(5).toStartOfWeek();
        Date dat = (I>5?(I<8? dat1.addDays(I-5):dat1.addDays(3)):Date.today().addDays(3));
        Home_Services__c Home =[Select Id,Name,First_Name__c,Last_Name__c,Phone_1__c,Account__r.Homeowner_2_First_Name__c, Account__r.Homeowner_2_Last_Name__c,
                                Homeowner_2_Email__c,Account__r.Homeowner_2_Mobile__c,Account__r.Customer_2_SSN__c,Account__r.Customer_2_Employer__c,
                                Account__r.Customer_2_Employment_Position__c,Account__r.Customer_2_Employer_Phone__c,Account__r.Customer_2_Income__c,
                                Account__r.Customer_2_Length_of_Employment__c,Account__r.Customer_2_DOB__c,Femail__c,Account__r.Customer_1_SSN_E__c,
                                fAddress__c,Account__r.PersonMobilePhone, City__c, Account__r.Customer_1_Employer__c, Account__r.Customer_1_Employment_Position__c,
								Account__r.Customer_1_Length_of_Employment__c,Account__r.Customer_1_Employer_Phone__c,State__c,Zip__c,Account__r.Customer_1_Income__c,
                                Account__r.Customer_1_DOB__c,Requested_Install_Date__c,Account__r.Customer_1_City_Employer__c,Account__r.Customer_1_State_Employer__c,
                                Account__r.Customer_1_Zip_Employer__c,Account__r.Customer_1_Previous_Employer__c,Account__r.Customer_2_Previous_Employer__c,
                                Account__r.Customer_1_Other_Income__c,Account__r.Customer_2_Other_Income__c,Account__r.Customer_1_Occupation_Previous__c,
                                Account__r.Customer_2_Occupation_Previous__c,Account__r.Customer_1_Previous_Employer_Phone__c,Account__r.Customer_1_Per_1__c,Account__r.Customer_2_Per_2__c,
                                Street__c,Account__r.Customer_1_Employer_Address__c,Account__r.Customer_1_Per_Month__c,Account__r.Customer_2_Per_Month__c,
                                Sales_Rep__r.FirstName, Sales_Rep__r.LastName, Sales_Rep__r.Email,Account__r.Customer_2_Previous_Employer_Phone__c
                                From Home_Services__c where Id=:homeserviceId];
        
        PaymentMethod__c PayM = [Select RoutingNumber__c,Bank_Account_Name__c,BankAccountNumber__c from PaymentMethod__c where HomeService__c=:homeserviceId And PaymentMethodType__c='ACH' limit 1];
        List<DiacoAlarm__Diaco_Customer_Alarm__c> Alarm = new List<DiacoAlarm__Diaco_Customer_Alarm__c>();
		Alarm = [Select DiacoAlarm__DiacoModemSerialNumber__c,DiacoAlarm__DiacoPanelType__c From DiacoAlarm__Diaco_Customer_Alarm__c where Home_Service__c=:homeserviceId];
        Finance_Package__c pack = Finance_Package__c.getValues(homeserviceId);
        ///tech
        String json = '{'+
            '"status": "sent",'+
            '"emailSubject": "Pinnacle Contract Document",'+
            '"templateId": "'+templateId+'",'+
            '"templateRoles": ['+
            '{'+
            '"email": "'+(Home.Sales_Rep__r.Email!=null?Home.Sales_Rep__r.Email:'')+'",'+
            '"name": "'+((Home.Sales_Rep__r.FirstName!=null?Home.Sales_Rep__r.FirstName:'')+' '+ (Home.Sales_Rep__r.LastName!=null?Home.Sales_Rep__r.LastName:''))+'",'+
            '"roleName": "Seller",'+
            '"routingOrder": "1",'+
            '"recipientId": "1",'+
            '"tabs": {'+
            '"signHereTabs": ['+
            '{'+
            '"xPosition": "100",'+
            '"yPosition": "726",'+
            '"documentId": "1",'+
            '"pageNumber": "4"'+
            '},'+
            '{'+
            '"xPosition": "30",'+
            '"yPosition": "726",'+
            '"documentId": "1",'+
            '"pageNumber": "5"'+
            '}'+
            '],'+
            '"dateSignedTabs": ['+
            '{'+
            '"xPosition": "115",'+
            '"yPosition": "33",'+
            '"documentId": "1",'+
            '"pageNumber": "6"'+
            '},'+
            '{'+
            '"xPosition": "115",'+
            '"yPosition": "373",'+
            '"documentId": "1",'+
            '"pageNumber": "6"'+
            '},'+
            '{'+
            '"xPosition": "510",'+
            '"yPosition": "25",'+
            '"documentId": "1",'+
            '"pageNumber": "4"'+
            '},'+
            '{'+
            '"xPosition": "153",'+
            '"yPosition": "750",'+
            '"documentId": "1",'+
            '"pageNumber": "5"'+
            '}'+
            '],'+
            '"textTabs": ['+
            '{'+
            '"value": "'+(PayM.BankAccountNumber__c!=null?PayM.BankAccountNumber__c:'')+'",'+
            '"locked": "true",'+
            '"xPosition": "105",'+
            '"yPosition": "264",'+
            '"documentId": "1",'+
            '"pageNumber": "2"'+
            '},'+
            '{'+
            '"value": "",'+
            '"locked": "true",'+
            '"xPosition": "315",'+
            '"yPosition": "264",'+
            '"documentId": "1",'+
            '"pageNumber": "2"'+
            '},'+
            '{'+
            '"value": "'+(PayM.RoutingNumber__c!=null?PayM.RoutingNumber__c:'')+'",'+
            '"locked": "true",'+
            '"xPosition": "105",'+
            '"yPosition": "244",'+
            '"documentId": "1",'+
            '"pageNumber": "2"'+
            '},'+
            '{'+
            '"value":"'+Home.First_Name__c+' '+Home.Last_Name__c+(Home.Homeowner_2_Email__c!=null ?(', '+Home.Account__r.Homeowner_2_First_Name__c +' '+Home.Account__r.Homeowner_2_Last_Name__c):'')+'",'+
            '"xPosition": "16",'+
            '"yPosition": "54",'+
            '"locked": "true",'+
            '"documentId": "1",'+
            '"pageNumber": "4"'+
            '},'+
            '{'+
            '"value":"'+(Home.Street__c!=null?Home.Street__c:'')+'",'+
            '"xPosition": "16",'+
            '"yPosition": "83",'+
            '"locked": "true",'+
            '"documentId": "1",'+
            '"pageNumber": "4"'+
            '},'+
            '{'+
            '"value":"'+(Home.City__c!=null?Home.City__c:'')+'",'+
            '"xPosition": "16",'+
            '"yPosition": "117",'+
            '"locked": "true",'+
            '"documentId": "1",'+
            '"pageNumber": "4"'+
            '},'+
            '{'+
            '"value":"'+(Home.State__c!=null?Home.State__c:'')+'",'+
            '"xPosition": "115",'+
            '"yPosition": "117",'+
            '"locked": "true",'+
            '"documentId": "1",'+
            '"pageNumber": "4"'+
            '},'+
            '{'+
            '"value":"'+(Home.Zip__c!=null?Home.Zip__c:'')+'",'+
            '"xPosition": "205",'+
            '"locked": "true",'+
            '"yPosition": "117",'+
            '"documentId": "1",'+
            '"pageNumber": "4"'+
            '},'+
            '{'+
            '"value":"'+(Home.Phone_1__c!=null?Home.Phone_1__c:'')+'",'+
            '"xPosition": "16",'+
            '"locked": "true",'+
            '"yPosition": "143",'+
            '"documentId": "1",'+
            '"pageNumber": "4"'+
            '},'+
            '{'+
            '"value":"Alarm System",'+
            '"xPosition": "26",'+
            '"locked": "true",'+
            '"yPosition": "243",'+
            '"documentId": "1",'+
            '"pageNumber": "4"'+
            '},'+
            '{'+
            '"value":"'+(Alarm.size()>1?(Alarm[0].DiacoAlarm__DiacoPanelType__c!=null?Alarm[0].DiacoAlarm__DiacoPanelType__c:''):'')+'",'+
            '"xPosition": "225",'+
            '"yPosition": "243",'+
            '"locked": "true",'+
            '"documentId": "1",'+
            '"pageNumber": "4"'+
            '},'+
            '{'+
            '"value":"'+(Alarm.size()>1?(Alarm[0].DiacoAlarm__DiacoModemSerialNumber__c!=null?Alarm[0].DiacoAlarm__DiacoModemSerialNumber__c:''):'')+'",'+
            '"xPosition": "403",'+
            '"yPosition": "243",'+
            '"locked": "true",'+
            '"documentId": "1",'+
            '"pageNumber": "4"'+
            '},'+
            '{'+
            '"value":"'+'$ '+(pack.Purchase__c!=null?(pack.Purchase__c.setScale(2)).format():'')+'",'+
            '"xPosition": "433",'+
            '"yPosition": "265",'+
            '"locked": "true",'+
            '"documentId": "1",'+
            '"pageNumber": "4"'+
            '},'+
            '{'+
            '"value":"'+'$ '+(pack.Purchase__c!=null?(pack.Purchase__c.setScale(2)).format():'')+'",'+
            '"xPosition": "486",'+
            '"locked": "true",'+
            '"yPosition": "279",'+
            '"documentId": "1",'+
            '"pageNumber": "4"'+
            '},'+
            '{'+
            '"value":"'+'$ '+(pack.Purchase__c!=null?(pack.Purchase__c.setScale(2)).format():'')+'",'+
            '"xPosition": "486",'+
            '"locked": "true",'+
            '"yPosition": "311",'+
            '"documentId": "1",'+
            '"pageNumber": "4"'+
            '},'+
            '{'+
            '"value":"'+(pack.APR__c!=null?(pack.APR__c.setScale(2)).format():'')+'%",'+
            '"xPosition": "26",'+
            '"yPosition": "471",'+
            '"locked": "true",'+
            '"documentId": "1",'+
            '"pageNumber": "4"'+
            '},'+
            '{'+
            '"value":"'+'$ '+(((pack.Payment_Number__c!=null?pack.Payment_Number__c:0)*(pack.Monthly_Payment_PURCHASE__c!=null?pack.Monthly_Payment_PURCHASE__c:0)-(pack.Purchase__c!=null?pack.Purchase__c:0)).setScale(2).format())+'",'+
            '"xPosition": "142",'+
            '"yPosition": "471",'+
            '"locked": "true",'+
            '"documentId": "1",'+
            '"pageNumber": "4"'+
            '},'+
            '{'+
            '"value":"'+'$ '+(pack.Purchase__c!=null?(pack.Purchase__c.setScale(2)).format():'')+'",'+
            '"xPosition": "256",'+
            '"locked": "true",'+
            '"yPosition": "471",'+
            '"documentId": "1",'+
            '"pageNumber": "4"'+
            '},'+
            '{'+
            '"value":"'+'$ '+((pack.Payment_Number__c!=null?pack.Payment_Number__c.setScale(2):0)*(pack.Monthly_Payment_PURCHASE__c!=null?pack.Monthly_Payment_PURCHASE__c.setScale(2):0)).format()+'",'+
            '"xPosition": "365",'+
            '"locked": "true",'+
            '"yPosition": "471",'+
            '"documentId": "1",'+
            '"pageNumber": "4"'+
            '},'+
            '{'+
            '"value":"'+'$ '+((pack.Payment_Number__c!=null?pack.Payment_Number__c.setScale(2):0)*(pack.Monthly_Payment_PURCHASE__c!=null?pack.Monthly_Payment_PURCHASE__c.setScale(2):0)).format()+'",'+
            '"xPosition": "472",'+
            '"yPosition": "481",'+
            '"locked": "true",'+
            '"documentId": "1",'+
            '"pageNumber": "4"'+
            '},'+
            '{'+
            '"value":"'+(pack.Payment_Number__c!=null?(pack.Payment_Number__c.setScale(2)).format():'')+'",'+
            '"xPosition": "26",'+
            '"yPosition": "530",'+
            '"documentId": "1",'+
            '"pageNumber": "4"'+
            '},'+
            '{'+
            '"value":"'+'$ '+(pack.Monthly_Payment_PURCHASE__c!=null?(pack.Monthly_Payment_PURCHASE__c.setScale(2)).format():'')+'",'+
            '"xPosition": "175",'+
            '"yPosition": "530",'+
            '"locked": "true",'+
            '"documentId": "1",'+
            '"pageNumber": "4"'+
            '},'+
            '{'+
            '"value":"'+(String.valueOf(Date.today().addMonths(1).addDays(-1)))+'",'+//Monthly, Beginning
            '"xPosition": "410",'+
            '"locked": "true",'+
            '"yPosition": "530",'+
            '"documentId": "1",'+
            '"pageNumber": "4"'+
            '},'+
            '{'+
            '"value":"PROTECTION SOURCE.",'+
            '"xPosition": "16",'+
            '"yPosition": "240",'+
            '"documentId": "1",'+
            '"pageNumber": "6"'+
            '},'+
            '{'+
            '"value":"664 W Warner Rd",'+
            '"xPosition": "235",'+
            '"yPosition": "240",'+
            '"documentId": "1",'+
            '"pageNumber": "6"'+
            '},'+
            '{'+
            '"value":"Tempe",'+
            '"xPosition": "425",'+
            '"yPosition": "240",'+
            '"documentId": "1",'+
            '"pageNumber": "6"'+
            '},'+
            '{'+
            '"value":"AZ",'+
            '"xPosition": "495",'+
            '"yPosition": "240",'+
            '"documentId": "1",'+
            '"pageNumber": "6"'+
            '},'+
            '{'+
            '"value":"85284",'+
            '"xPosition": "530",'+
            '"yPosition": "240",'+
            '"documentId": "1",'+
            '"pageNumber": "6"'+
            '},'+
            '{'+
            '"value":"PROTECTION SOURCE.",'+
            '"xPosition": "16",'+
            '"yPosition": "592",'+
            '"documentId": "1",'+
            '"pageNumber": "6"'+
            '},'+
            '{'+
            '"value":"664 W Warner Rd",'+
            '"xPosition": "235",'+
            '"yPosition": "592",'+
            '"documentId": "1",'+
            '"pageNumber": "6"'+
            '},'+
            '{'+
            '"value":"Tempe",'+
            '"xPosition": "425",'+
            '"yPosition": "592",'+
            '"documentId": "1",'+
            '"pageNumber": "6"'+
            '},'+
            '{'+
            '"value":"AZ",'+
            '"xPosition": "495",'+
            '"yPosition": "592",'+
            '"documentId": "1",'+
            '"pageNumber": "6"'+
            '},'+
            '{'+
            '"value":"85284",'+
            '"xPosition": "530",'+
            '"yPosition": "592",'+
            '"documentId": "1",'+
            '"pageNumber": "6"'+
            '},'+
            ''+
            '{'+
            '"value":"Protection Source.",'+
            '"xPosition": "295",'+
            '"yPosition": "54",'+
            '"documentId": "1",'+
            '"pageNumber": "4"'+
            '},'+
            '{'+
            '"value":"664 W Warner Rd",'+
            '"xPosition": "295",'+
            '"yPosition": "83",'+
            '"documentId": "1",'+
            '"pageNumber": "4"'+
            '},'+
            '{'+
            '"value":"Tempe",'+
            '"xPosition": "295",'+
            '"yPosition": "117",'+
            '"documentId": "1",'+
            '"pageNumber": "4"'+
            '},'+
            '{'+
            '"value":"AZ",'+
            '"xPosition": "403",'+
            '"yPosition": "117",'+
            '"documentId": "1",'+
            '"pageNumber": "4"'+
            '},'+
            '{'+
            '"value":"85284",'+
            '"xPosition": "491",'+
            '"yPosition": "117",'+
            '"documentId": "1",'+
            '"pageNumber": "4"'+
            '},'+
            '{'+
            '"value":"602-875-0717",'+
            '"xPosition": "295",'+
            '"yPosition": "143",'+
            '"documentId": "1",'+
            '"pageNumber": "4"'+
            '},'+
            '{'+
            '"value":"'+((Home.Sales_Rep__r.FirstName!=null?Home.Sales_Rep__r.FirstName:'')+' '+ (Home.Sales_Rep__r.LastName!=null?Home.Sales_Rep__r.LastName:''))+'",'+
            '"xPosition": "290",'+
            '"locked": "true",'+
            '"yPosition": "740",'+
            '"documentId": "1",'+
            '"pageNumber": "4"'+
            '},'+
            '{'+
            '"value":"COMPANY REPRESENTATIVE",'+
            '"xPosition": "473",'+
            '"yPosition": "740",'+
            '"documentId": "1",'+
            '"pageNumber": "4"'+
            '},'+
            ''+
            '{'+
            '"value": "PROTECTION SOURCE.",'+
            '"xPosition": "270",'+
            '"locked": "true",'+
            '"yPosition": "132",'+
            '"documentId": "1",'+
            '"pageNumber": "1"'+
            '},'+
            '{'+
            '"value": "'+(String.valueOf(Date.today().addMonths(1).addDays(-1)))+'",'+//(security.Start_Install_Date__c != null ? string.valueOf(security.Start_Install_Date__c.addMonths(1).addDays(-1)) : '')
            '"xPosition": "344",'+
            '"locked": "true",'+
            '"yPosition": "380",'+
            '"documentId": "1",'+
            '"pageNumber": "1"'+
            '},'+
            '{'+
            '"value": "1 year",'+
            '"xPosition": "342",'+
            '"yPosition": "390",'+
            '"documentId": "1",'+
            '"pageNumber": "1"'+
            '},'+
            '{'+
            '"value": "'+(String.valueOf(Date.today().addMonths(1).addDays(-1)))+'",'+//(security.Start_Install_Date__c != null ? string.valueOf(security.Start_Install_Date__c) : '')
            '"xPosition": "344",'+
            '"yPosition": "550",'+
            '"locked": "true",'+
            '"documentId": "1",'+
            '"pageNumber": "1"'+
            '},'+
            '{'+
            '"value": "'+(String.valueOf(Date.today().addMonths(1).addDays(-1)))+'",'+//(security.Start_Install_Date__c != null ? string.valueOf(security.Start_Install_Date__c.addYears(1).addDays(-1)) : '')
            '"xPosition": "434",'+
            '"locked": "true",'+
            '"yPosition": "511",'+
            '"documentId": "1",'+
            '"pageNumber": "1"'+
            '},'+
            '{'+
            '"value": "'+(PayM.Bank_Account_Name__c!=null?PayM.Bank_Account_Name__c:'')+'",'+//(security.X2nd_Name_on_Accoun__c != null ? (security.X2nd_Name_on_Accoun__c) : '')
            '"xPosition": "105",'+
            '"locked": "true",'+
            '"yPosition": "185",'+
            '"documentId": "1",'+
            '"pageNumber": "2"'+
            '},'+
            '{'+
            '"value": "'+(Home.City__c!=null?Home.City__c:'')+'",'+
            '"xPosition": "110",'+
            '"locked": "true",'+
            '"yPosition": "204",'+
            '"documentId": "1",'+
            '"pageNumber": "2"'+
            '},'+
            '{'+
            '"value": "'+(Home.State__c!=null?Home.State__c:'')+'",'+
            '"xPosition": "295",'+
            '"yPosition": "204",'+
            '"locked": "true",'+
            '"documentId": "1",'+
            '"pageNumber": "2"'+
            '},'+
            '{'+
            '"value": "'+(Home.Zip__c!=null?Home.Zip__c:'')+'",'+
            '"xPosition": "325",'+
            '"locked": "true",'+
            '"yPosition": "204",'+
            '"documentId": "1",'+
            '"pageNumber": "2"'+
            '},'+
            '{'+
            '"value": "'+Home.First_Name__c+' '+Home.Last_Name__c+'",'+
            '"xPosition": "120",'+
            '"locked": "true",'+
            '"yPosition": "564",'+
            '"documentId": "1",'+
            '"pageNumber": "2"'+
            '},'+
            '{'+
            '"value": "'+(Home.Homeowner_2_Email__c!=null ?(Home.Account__r.Homeowner_2_First_Name__c +' '+Home.Account__r.Homeowner_2_Last_Name__c):'')+'",'+
            '"locked": "true",'+
            '"xPosition": "120",'+
            '"yPosition": "587",'+
            '"documentId": "1",'+
            '"pageNumber": "2"'+
            '},'+
            '{'+
            '"value": "'+Home.First_Name__c+' '+Home.Last_Name__c+'",'+
            '"xPosition": "20",'+
            '"yPosition": "93",'+
            '"locked": "true",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{'+
            '"value": "'+(Home.Account__r.Customer_1_SSN_E__c!=null?Home.Account__r.Customer_1_SSN_E__c:'')+'",'+
            '"xPosition": "302",'+
            '"locked": "true",'+
            '"yPosition": "93",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{'+
            '"value": "'+(Home.Account__r.Customer_1_DOB__c!=null?String.valueOf(Home.Account__r.Customer_1_DOB__c):'')+'",'+//(security.Date_of_Birth__c != null ? String.valueOf(security.Date_of_Birth__c) : '')
            '"xPosition": "400",'+
            '"locked": "true",'+
            '"yPosition": "93",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{'+
            '"value": "'+(Home.fAddress__c!=null?Home.fAddress__c:'')+'",'+
            '"xPosition": "20",'+
            '"locked": "true",'+
            '"yPosition": "120",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{'+
            '"value": "'+(Home.Phone_1__c!=null?Home.Phone_1__c:'') +'",'+
            '"locked": "true",'+
            '"xPosition": "400",'+
            '"yPosition": "120",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{'+
            '"value": "'+(Home.Account__r.PersonMobilePhone!=null?Home.Account__r.PersonMobilePhone:'')+'",'+
            '"xPosition": "500",'+
            '"locked": "true",'+
            '"yPosition": "120",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{'+
            '"value": "'+(Home.City__c!=null?Home.City__c:'')+'",'+
            '"xPosition": "20",'+
            '"locked": "true",'+
            '"yPosition": "147",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{'+
            '"value": "'+(Home.Account__r.Customer_1_Employer__c!=null?Home.Account__r.Customer_1_Employer__c:'')+'",'+
            '"xPosition": "16",'+
            '"locked": "true",'+
            '"yPosition": "172",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{'+
            '"value": "'+(Home.Account__r.Customer_1_Employment_Position__c!=null?Home.Account__r.Customer_1_Employment_Position__c:'')+'",'+
            '"xPosition": "302",'+
            '"yPosition": "172",'+
            '"locked": "true",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{'+
            '"value": "'+(Home.Account__r.Customer_1_Length_of_Employment__c!=null?Home.Account__r.Customer_1_Length_of_Employment__c:'')+'",'+
            '"xPosition": "400",'+
            '"locked": "true",'+
            '"yPosition": "172",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{  '+
            '"value": "'+(Home.Account__r.Customer_1_Employer_Address__c!=null?Home.Account__r.Customer_1_Employer_Address__c:'')+'",'+
            '"xPosition": "16",'+
            '"yPosition": "199",'+
            '"locked": "true",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{'+
            '"value": "'+(Home.Account__r.Customer_1_Employer_Phone__c!=null?Home.Account__r.Customer_1_Employer_Phone__c:'')+'",'+
            '"xPosition": "400",'+
            '"yPosition": "199",'+
            '"locked": "true",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{  '+
            '"value": "'+(Home.Account__r.Customer_1_City_Employer__c!=null?Home.Account__r.Customer_1_City_Employer__c:'')+'",'+
            '"xPosition": "16",'+
            '"yPosition": "224",'+
            '"locked": "true",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{'+
            '"value": "'+(Home.Account__r.Customer_1_State_Employer__c!=null?Home.Account__r.Customer_1_State_Employer__c:'')+'",'+
            '"xPosition": "302",'+
            '"locked": "true",'+
            '"yPosition": "224",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{'+
            '"value": "'+(Home.Account__r.Customer_1_Zip_Employer__c!=null?Home.Account__r.Customer_1_Zip_Employer__c:'')+'",'+
            '"xPosition": "400",'+
            '"yPosition": "224",'+
            '"locked": "true",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{  '+
            '"value": "'+(Home.Account__r.Customer_1_Previous_Employer__c!=null?Home.Account__r.Customer_1_Previous_Employer__c:'')+'",'+
            '"xPosition": "16",'+
            '"locked": "true",'+
            '"yPosition": "252",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{'+
            '"value": "'+(Home.Account__r.Customer_1_Occupation_Previous__c!=null?Home.Account__r.Customer_1_Occupation_Previous__c:'')+'",'+
            '"xPosition": "400",'+
            '"yPosition": "252",'+
            '"locked": "true",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{'+
            '"value": "'+(Home.Account__r.Customer_1_Previous_Employer_Phone__c!=null?Home.Account__r.Customer_1_Previous_Employer_Phone__c:'')+'",'+
            '"xPosition": "520",'+
            '"yPosition": "252",'+
            '"locked": "true",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{  '+
            '"value": "'+(Home.Account__r.Customer_1_Other_Income__c!=null?Home.Account__r.Customer_1_Other_Income__c:'')+'",'+
            '"xPosition": "16",'+
            '"yPosition": "277",'+
            '"locked": "true",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{'+
            '"value": "'+(Home.Account__r.Customer_1_Per_Month__c!=null?String.valueOf(Home.Account__r.Customer_1_Per_Month__c):'')+'",'+
            '"xPosition": "305",'+
            '"yPosition": "277",'+
            '"locked": "true",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{'+
            '"value": "'+(Home.Account__r.Customer_1_Length_of_Employment__c!=null?Home.Account__r.Customer_1_Length_of_Employment__c:'')+'",'+//How Long
            '"xPosition": "400",'+
            '"yPosition": "144",'+
            '"locked": "true",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{'+
            '"value": "'+(Home.State__c!=null?Home.State__c:'')+'",'+
            '"xPosition": "214",'+
            '"yPosition": "147",'+
            '"documentId": "1",'+
            '"locked": "true",'+
            '"pageNumber": "3"'+
            '},'+
            '{'+
            '"value": "'+(Home.Zip__c!=null?Home.Zip__c:'')+'",'+
            '"xPosition": "302",'+
            '"locked": "true",'+
            '"yPosition": "147",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{'+
            '"value": "'+(Home.Femail__c!=null?Home.Femail__c:'')+'",'+
            '"xPosition": "460",'+
            '"yPosition": "147",'+
            '"locked": "true",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{'+
            '"value": "'+(Home.Account__r.Customer_1_Income__c!=null?String.valueOf(Home.Account__r.Customer_1_Income__c):'')+'",'+
            '"xPosition": "498",'+
            '"yPosition": "170",'+
            '"locked": "true",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{'+
            '"value": "'+(Home.Account__r.Customer_1_Per_1__c!=null?Home.Account__r.Customer_1_Per_1__c:'')+'",'+
            '"xPosition": "560",'+
            '"locked": "true",'+
            '"yPosition": "170",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{'+
            '"value": "'+(Home.Homeowner_2_Email__c!=null ?(Home.Account__r.Homeowner_2_First_Name__c +' '+Home.Account__r.Homeowner_2_Last_Name__c):'') +'",'+//(security.Email_Co_Owner__c != null ? security.First_Name_Co_Owner__c+' '+security.Last_Name_Co_Owner__c : '')
            '"locked": "true",'+
            '"xPosition": "20",'+
            '"yPosition": "371",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{'+
            '"value": "'+(Home.Homeowner_2_Email__c!=null ?(Home.Account__r.Homeowner_2_Mobile__c!=null?Home.Account__r.Homeowner_2_Mobile__c:''):'')+'",'+
            '"locked": "true",'+
            '"xPosition": "514",'+
            '"yPosition": "371",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{'+
            '"value": "'+(Home.Homeowner_2_Email__c!=null ?(Home.Account__r.Customer_2_SSN__c!=null?Home.Account__r.Customer_2_SSN__c:''):'')+'",'+
            '"locked": "true",'+
            '"xPosition": "20",'+
            '"yPosition": "398",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{'+
            '"value": "'+(Home.Homeowner_2_Email__c!=null ?(Home.Account__r.Customer_2_DOB__c!=null?String.valueOf(Home.Account__r.Customer_2_DOB__c):''):'')+'",'+
            '"locked": "true",'+
            '"xPosition": "197",'+
            '"yPosition": "398",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{'+
            '"value": "'+(Home.Homeowner_2_Email__c!=null ?(Home.Homeowner_2_Email__c!=null?Home.Homeowner_2_Email__c:''):'')+'",'+
            '"locked": "true",'+
            '"xPosition": "335",'+
            '"yPosition": "398",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{'+
            '"value": "'+(Home.Homeowner_2_Email__c!=null ?(Home.Account__r.Customer_2_Employer__c!=null?Home.Account__r.Customer_2_Employer__c:''):'')+'",'+
            '"locked": "true",'+
            '"xPosition": "20",'+
            '"yPosition": "423",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{'+
            '"value": "'+(Home.Homeowner_2_Email__c!=null ?(Home.Account__r.Customer_2_Employment_Position__c!=null?Home.Account__r.Customer_2_Employment_Position__c:''):'')+'",'+
            '"locked": "true",'+
            '"xPosition": "305",'+
            '"yPosition": "423",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{'+
            '"value": "'+(Home.Homeowner_2_Email__c!=null ?(Home.Account__r.Customer_2_Length_of_Employment__c!=null?Home.Account__r.Customer_2_Length_of_Employment__c:''):'')+'",'+
            '"locked": "true",'+
            '"xPosition": "405",'+
            '"yPosition": "423",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{'+
            '"value": "'+(Home.Homeowner_2_Email__c!=null ?(Home.Account__r.Customer_2_Occupation_Previous__c!=null?Home.Account__r.Customer_2_Occupation_Previous__c:''):'')+'",'+
            '"locked": "true",'+
            '"xPosition": "405",'+
            '"yPosition": "448",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{'+
            '"value": "'+(Home.Homeowner_2_Email__c!=null ?(Home.Account__r.Customer_2_Previous_Employer_Phone__c!=null?Home.Account__r.Customer_2_Previous_Employer_Phone__c:''):'')+'",'+
            '"locked": "true",'+
            '"xPosition": "515",'+
            '"yPosition": "448",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{'+
            '"value": "'+(Home.Homeowner_2_Email__c!=null ?(Home.Account__r.Customer_2_Previous_Employer__c!=null?Home.Account__r.Customer_2_Previous_Employer__c:''):'')+'",'+
            '"locked": "true",'+
            '"xPosition": "20",'+
            '"yPosition": "450",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{'+
            '"value": "'+(Home.Homeowner_2_Email__c!=null ?(Home.Account__r.Customer_2_Other_Income__c!=null?String.valueOf(Home.Account__r.Customer_2_Other_Income__c):''):'')+'",'+
            '"locked": "true",'+
            '"xPosition": "20",'+
            '"yPosition": "475",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{'+
            '"value": "'+(Home.Homeowner_2_Email__c!=null ?(Home.Account__r.Customer_2_Per_Month__c!=null?String.valueOf(Home.Account__r.Customer_2_Per_Month__c):''):'')+'",'+
            '"locked": "true",'+
            '"xPosition": "305",'+
            '"yPosition": "475",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{'+
            '"value": "'+(Home.Homeowner_2_Email__c!=null ?(Home.Homeowner_2_Email__c!=null ?(String.valueOf(Home.Account__r.Customer_2_Income__c)):''):'')+'",'+
            '"xPosition": "499",'+
            '"yPosition": "420",'+
            '"locked": "true",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{'+
            '"value": "'+(Home.Homeowner_2_Email__c!=null ?(Home.Account__r.Customer_2_Per_2__c!=null?Home.Account__r.Customer_2_Per_2__c:''):'')+'",'+
            '"xPosition": "560",'+
            '"locked": "true",'+
            '"yPosition": "420",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{'+
            '"value": "",'+
            '"locked": "true",'+
            '"xPosition": "405",'+
            '"yPosition": "677",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{'+
            '"value": "",'+
            '"locked": "true",'+
            '"xPosition": "405",'+
            '"yPosition": "695",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{'+
            '"value": "",'+
            '"locked": "true",'+
            '"xPosition": "405",'+
            '"yPosition": "711",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{'+
            '"value": "'+String.valueOf(dat)+'",'+//String.valueOf(security.Noc_Deadline__c)
            '"xPosition": "190",'+
            '"locked": "true",'+
            '"yPosition": "278",'+
            '"documentId": "1",'+
            '"pageNumber": "6"'+
            '},'+
            '{'+
            '"value": "'+String.valueOf(dat)+'",'+//String.valueOf(security.Noc_Deadline__c)
            '"xPosition": "190",'+
            '"locked": "true",'+
            '"yPosition": "630",'+
            '"documentId": "1",'+
            '"pageNumber": "6"'+
            '}'+
            '],'+
            '"numberTabs": ['+
            '{'+
            '"value": "'+(pack.Purchase__c!=null?(pack.Purchase__c.setScale(2)).format():'')+'",'+
            '"xPosition": "352",'+
            '"locked": "true",'+
            '"yPosition": "353",'+
            '"documentId": "1",'+
            '"pageNumber": "1"'+
            '},'+
            '{'+
            '"value": "'+(pack.Monthly_Payment_PURCHASE__c!=null?(pack.Monthly_Payment_PURCHASE__c.setScale(2)).format():'')+'",'+
            '"xPosition": "352",'+
            '"locked": "true",'+
            '"yPosition": "365",'+
            '"documentId": "1",'+
            '"pageNumber": "1"'+
            '},'+
            '{'+
            '"value": "'+(pack.Monitoring__c!=null?(pack.Monitoring__c.setScale(2)).format():'')+'",'+
            '"xPosition": "352",'+
            '"locked": "true",'+
            '"yPosition": "537",'+
            '"documentId": "1",'+
            '"pageNumber": "1"'+
            '},'+
            '{'+
            '"value": "'+'$ '+(pack.Monthly_Payment_PURCHASE__c!=null?(pack.Monthly_Payment_PURCHASE__c.setScale(2)).format():'')+'",'+//Equipment_Payment_Before_Tax
            '"xPosition": "315",'+
            '"locked": "true",'+
            '"yPosition": "244",'+
            '"documentId": "1",'+
            '"pageNumber": "2"'+
            '},'+
            '{'+
            '"value": "'+'$ '+(pack.Monthly_Payment_PURCHASE__c!=null?(pack.Monthly_Payment_PURCHASE__c.setScale(2)).format():'')+'",'+
            '"xPosition": "100",'+
            '"locked": "true",'+
            '"yPosition": "475",'+
            '"documentId": "1",'+
            '"pageNumber": "2"'+
            '},{'+
            '"value": "",'+
            '"locked": "true",'+
            '"xPosition": "408",'+
            '"yPosition": "728",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{'+
            '"value": "",'+
            '"locked": "true",'+
            '"xPosition": "503",'+
            '"yPosition": "728",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '}'+
            '],'+
            '"checkboxTabs": ['+
            '{'+
            '"selected": "true",'+
            '"xPosition": "14",'+
            '"yPosition": "125",'+
            '"documentId": "1",'+
            '"pageNumber": "2"'+
            '},'+
            '{'+
            '"selected": "false",'+
            '"xPosition": "124",'+
            '"yPosition": "125",'+
            '"documentId": "1",'+
            '"pageNumber": "2"'+
            '}'+
            ']'+
            '}'+
            '},';
        //first customer
        json = json + '{'+
            '"email": "'+Home.Femail__c+'",'+
            '"name": "'+Home.First_Name__c+' '+Home.Last_Name__c+'",'+
            '"roleName": "Buyer",'+
            '"routingOrder": "2",'+
            '"recipientId": "2",'+
            '"tabs": {'+
            '"initialHereTabs": ['+
            '{'+
            '"xPosition": "74",'+
            '"yPosition": "122",'+
            '"documentId": "1",'+
            '"pageNumber": "1"'+
            '},'+
            '{'+
            '"xPosition": "74",'+
            '"yPosition": "186",'+
            '"documentId": "1",'+
            '"pageNumber": "1"'+
            '},'+
            '{'+
            '"xPosition": "74",'+
            '"yPosition": "238",'+
            '"documentId": "1",'+
            '"pageNumber": "1"'+
            '},'+
            '{'+
            '"xPosition": "74",'+
            '"yPosition": "273",'+
            '"documentId": "1",'+
            '"pageNumber": "1"'+
            '},'+
            '{'+
            '"xPosition": "74",'+
            '"yPosition": "383",'+
            '"documentId": "1",'+
            '"pageNumber": "1"'+
            '},'+
            '{'+
            '"xPosition": "74",'+
            '"yPosition": "519",'+
            '"documentId": "1",'+
            '"pageNumber": "1"'+
            '},'+
            '{'+
            '"xPosition": "500",'+
            '"yPosition": "637",'+
            '"documentId": "1",'+
            '"pageNumber": "4"'+
            '}'+
            '],'+
            '"signHereTabs": ['+
            '{'+
            '"xPosition": "215",'+
            '"yPosition": "637",'+
            '"documentId": "1",'+
            '"pageNumber": "1"'+
            '},'+
            '{'+
            '"xPosition": "120",'+
            '"yPosition": "618",'+
            '"documentId": "1",'+
            '"pageNumber": "2"'+
            '},'+
            '{'+
            '"xPosition": "15",'+
            '"yPosition": "660",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{'+
            '"xPosition": "220",'+
            '"yPosition": "728",'+
            '"documentId": "1",'+
            '"pageNumber": "5"'+
            '}'+
            ''+
            '],'+
            '"dateSignedTabs": ['+
            '{'+
            '"xPosition": "260",'+
            '"yPosition": "636",'+
            '"documentId": "1",'+
            '"pageNumber": "2"'+
            '},'+
            '{'+
            '"xPosition": "190",'+
            '"yPosition": "678",'+
            '"documentId": "1",'+
            '"pageNumber": "3"'+
            '},'+
            '{'+
            '"xPosition": "345",'+
            '"yPosition": "750",'+
            '"documentId": "1",'+
            '"pageNumber": "5"'+
            '}'+
            ']'+
            '}'+
            '}';
        
        //second customer
        if(Home.Homeowner_2_Email__c!=null){
            json = json + ',{'+
                '"email": "'+Home.Homeowner_2_Email__c+'",'+ 
                '"name": "'+Home.Account__r.Homeowner_2_First_Name__c +' '+Home.Account__r.Homeowner_2_Last_Name__c +'",'+
                '"roleName": "CoBuyer",'+
                '"routingOrder": "3",'+
                '"recipientId": "3",'+
                '"tabs": {'+
                '"initialHereTabs": ['+
                '{'+
                '"xPosition": "112",'+
                '"yPosition": "122",'+
                '"documentId": "1",'+
                '"pageNumber": "1"'+
                '},'+
                '{'+
                '"xPosition": "115",'+
                '"yPosition": "186",'+
                '"documentId": "1",'+
                '"pageNumber": "1"'+
                '},'+
                '{'+
                '"xPosition": "115",'+
                '"yPosition": "238",'+
                '"documentId": "1",'+
                '"pageNumber": "1"'+
                '},'+
                '{'+
                '"xPosition": "115",'+
                '"yPosition": "273",'+
                '"documentId": "1",'+
                '"pageNumber": "1"'+
                '},'+
                '{'+
                '"xPosition": "115",'+
                '"yPosition": "383",'+
                '"documentId": "1",'+
                '"pageNumber": "1"'+
                '},'+
                '{'+
                '"xPosition": "115",'+
                '"yPosition": "519",'+
                '"documentId": "1",'+
                '"pageNumber": "1"'+
                '},'+
                '{'+
                '"xPosition": "550",'+
                '"yPosition": "637",'+
                '"documentId": "1",'+
                '"pageNumber": "4"'+
                '}'+
                '],'+
                '"signHereTabs": ['+
                '{'+
                '"xPosition": "215",'+
                '"yPosition": "668",'+
                '"documentId": "1",'+
                '"pageNumber": "1"'+
                '},'+
                '{'+
                '"xPosition": "120",'+
                '"yPosition": "650",'+
                '"documentId": "1",'+
                '"pageNumber": "2"'+
                '},'+
                '{'+
                '"xPosition": "15",'+
                '"yPosition": "710",'+
                '"documentId": "1",'+
                '"pageNumber": "3"'+
                '},'+
                '{'+
                '"xPosition": "410",'+
                '"yPosition": "728",'+
                '"documentId": "1",'+
                '"pageNumber": "5"'+
                '}'+
                '],'+
                '"dateSignedTabs": ['+
                '{'+
                '"xPosition": "260",'+
                '"yPosition": "669",'+
                '"documentId": "1",'+
                '"pageNumber": "2"'+
                '},'+
                '{'+
                '"xPosition": "190",'+
                '"yPosition": "729",'+
                '"documentId": "1",'+
                '"pageNumber": "3"'+
                '},'+
                '{'+
                '"xPosition": "536",'+
                '"yPosition": "750",'+
                '"documentId": "1",'+
                '"pageNumber": "5"'+
                '}'+
                ']'+
                '}'+
                '}';
        }
        json += ']';
        json += '}';
        return json;
    }
    
    public static void main(){
        
        String body = diacoDocusignApiRestIntegrationJson.Completion_Certificate_Template('a041F000002WAfkQAG', '07a82c1e-95da-4b08-bd27-e7933d3100c9');

        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { '' };
        message.optOutPolicy = 'FILTER';
        message.subject = 'Opt Out Test Message';
        message.plainTextBody = body;
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

        if (results[0].success) 
        {
            System.debug('The email was sent successfully.');
        } else 
        {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
    }
}