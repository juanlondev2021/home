/**
* Diaco
* @author 			Jorge Martinez href=<jorgeality29@gmail.com>
* Project:			Contracts
* Description:		class responsible for handling DiacoContract Lightning component.
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		22/02/2019		Jorge Martinez (JM)		Initial implementation of the class.
* @version	1.0		21/03/2020		Álvaro Ortega (AO)		Changes.
* @version	1.0		17/06/2020		Fabian Pineda (FP)		Made Account "County" information retrievable and saveable.
**/
public class DiacoWaterContractController {
    @AuraEnabled
    public static Home_Services__c getDataHomeServicePricing(String RecordId){
        Home_Services__c home =  [select Id, Total_Cash_Selling_Price__c, Sales_Tax__c, Total_Cash_Price__c, Down_Payment__c,
                                  Trade_in_Allowance__c, Total_Down_Payment__c, Balance_Due__c, Total_Monthly_Investment__c
                                  from Home_Services__c 
                                  where id = :RecordId];
        return home;
    }
    @AuraEnabled
    public static Account getDataCustomerOne(String RecordId){
        system.debug('RecordId');
        system.debug(RecordId);
        Home_Services__c home =  [select Account__c from Home_Services__c where id = :RecordId];
        Account account = [select Id, FirstName, LastName, Customer_1_DOB__c, Customer_1_SSN_E__c,Customer_1_Drivers_License_Expiration__c, Customer_1_Drivers_License__c,
                           Drivers_license_Issuing_state_1__c,Score_Customer_1__c,Customer_1_Drivers_License_Issue_Date__c, Customer_1_Employer__c, Customer_1_Employer_Phone__c, Customer_1_Income__c,
                           Customer_1_Length_of_Employment__c, Customer_1_Employment_Position__c, Phone, PersonMobilePhone,Street__c ,Zip__c,City__c,State__c,PersonEmail,County__c,Gate_Code__c,
                           Customer_1_Per_Month__c, Customer_1_Previous_Employer_Phone__c, Customer_1_Occupation_Previous__c, Customer_1_Other_Income__c, Customer_1_Previous_Employer__c, Customer_1_City_Employer__c,
                           Customer_1_State_Employer__c, Customer_1_Zip_Employer__c, Customer_1_Street_Employer__c, Customer_1_Per_1__c,Mortgage_Payment__c,Number_of_Stories__c,Year_Built__c,Number_of_AC_Units__c,
                           Pool__c,WA_MonthsAtAddress__c, WP_CurrentResidenceType__c, WA_MonthsEmployed__c, WA_YearsAtAddress__c, WA_EmplTermType__c, WP_PayFrequency__c, Hire_Date__c, WP_HomeType__c
                           from Account 
                           where Id = :home.Account__c ];
        return account;
    }
    @AuraEnabled
    public static Account getDataCustomerTwo(String RecordId){
        Home_Services__c home =  [select Account__c from Home_Services__c where id = :RecordId];
        Account account = [select Id, Customer_2_DOB__c,Customer_2_Drivers_License_Issue__c, Customer_2_Drivers_License__c,Customer_2_Drivers_License_Expiration__c,
                           Drivers_license_Issuing_state_2__c, Homeowner_2_First_Name__c,Score_Customer_2__c,Homeowner_2_Last_Name__c, Customer_2_SSN__c, Homeowner_2_Phone_Number__c,
                           Homeowner_2_Mobile__c, Homeowner_2_Email__c, Customer_2_Employer__c, Customer_2_Employer_Phone__c, Customer_2_Income__c, Customer_2_Length_of_Employment__c,
                           Customer_2_Employment_Position__c, Customer_2_Per_Month__c, Customer_2_Occupation_Previous__c, Customer_2_Other_Income__c, Customer_2_Previous_Employer__c,
                           Customer_2_Per_2__c, Customer_2_Previous_Employer_Phone__c, Customer_2_Employer_type__c, Customer_2_Hire_Date__c,
                           Customer_2_Net_Income__c
                           from Account 
                           where Id = :home.Account__c ];
        return account;
    }
    @AuraEnabled
    public static Account saveAccount(Account account){
        upsert account;
        return account;
    }
    @AuraEnabled
    public static Account getDataLocationAndPayments(String RecordId){
        Home_Services__c home =  [select Account__c from Home_Services__c where id = :RecordId];
        Account account = [select Id, State__c, City__c, Street__c, Zip__c, Mortgage_Payment__c
                           from Account 
                           where Id = :home.Account__c ];
        return account;
    }
    @AuraEnabled
    public static Home_Services__c getInstallationDate(String RecordId){
        return [select Id, Sales_Rep__c, Requested_Install_Date__c,Requested_service_Date__c
                from Home_Services__c 
                where id = :RecordId];
    }
    @AuraEnabled
    public static String getSalesRepsName(String salesRepId){
        User use = [select Id, Name 
                    from User 
                    where Id = :salesRepId];
        return use.Name;
    }
    @AuraEnabled
    public static List<User> getSalesReps(){
        return [select Id, Name 
                from User];
    }
    @AuraEnabled
    public static User getSaleRepAssigned(String hsId){
        Home_Services__c hs=[select Id,Sales_Rep__c FROM Home_Services__c WHERE id=:hsId];
        system.debug(hsId);
       system.debug(hs);
        if(hs.Sales_Rep__c==null){
            return null;
        }else{
            return [select Id, Name from User where ID=:hs.Sales_Rep__c];
        }
    }
    
    @AuraEnabled
    public static Home_Services__c saveHomeService(Home_Services__c Home_Services){
        upsert Home_Services;
        return Home_Services;
    }
    @AuraEnabled
    public static Home_Services__c saveHomeServiceSalesRep(String hsId,String SalesRepId){
        Home_Services__c hs=New  Home_Services__c(Id=hsId,Sales_Rep__c=SalesRepId);
        upsert hs;
        return hs;
    }
    @AuraEnabled
    public static Home_Services__c getDataHomeService(String RecordId){
        Home_Services__c home =  [select Id, Account__c, Hardness_gpg__c, Ph__c, Iron_Algae__c, Iron_ppm__c, Hyd_Supl_ppm__c, No_Reg__c, Other__c, Special_Instructions__c 
                                  from Home_Services__c 
                                  where id = :RecordId];
        return home;
    }
    @AuraEnabled
    public static Account getDataHomeServiceAgreement(String RecordId){
        Home_Services__c home =  [select Account__c from Home_Services__c where id = :RecordId];
        Account account = [select Id, FirstName, LastName, Phone, PersonEmail, Homeowner_2_First_Name__c, Homeowner_2_Last_Name__c, Homeowner_2_Phone_Number__c,
                           Homeowner_2_Email__c, State__c, City__c, Street__c, Zip__c, Billing_Information_From__c, Billing_First_Name__c, Billing_Last_Name__c, 
                           Billing_Phone__c, Billing_Fax__c, Billing_Company__c, Primary_Billing_State__c, Primary_Billing_City__c, Primary_Billing_Street__c, 
                           Primary_Billing_Zip_Code__c, Billing_Email__c, PersonMobilePhone, Fax,
                           Billing_Information_From_Service__c,Billing_First_Name_Service__c, Billing_Last_Name_Service__c, 
                           Billing_Phone_Service__c, Billing_Email_Service__c, Billing_Fax_Service__c, Billing_Company_Service__c,
                           Primary_Billing_State_Service__c, Primary_Billing_City_Service__c,Primary_Billing_Street_Service__c,
                           Primary_Billing_Zip_Code_Service__c, Billing_Address_Same_As_Service_Address__c, Billing_Address_Same_As_Product__c 
                           from Account 
                           where Id = :home.Account__c ];
        return account;
    }
    @AuraEnabled
    public static Home_Services__c getPaymentMethods(String RecordId){
        Home_Services__c home =  [select Id, 
                                  /*Payment solar*/
                                  Balance_Due__c, FirstPayment__c, SecondPayment__c, ThirdPayment__c,
                                  /*products pay methods*/
                                  Method_Of_Payment__c,
                                  /*credit card field to fill*/
                                  Credit_Card_Type_System__c,Name_On_Card_System__c,Card_Number__c,last4numbers__c, Credit_Card_CSV__c,Expiration_Month__c, Expiration_Year__c,
                                  /*credit card field to show*/
                                  Card_Type__c, Name_on_Card__c, Account_Number__c, Card_Last_4__c, CSV__c, Card_Expiration_Month__c, Card_Expiration_Year__c,
                                  /*checking field to fill*/
                                  Bank_Account_Type_System__c, Bank_Account_Number__c, Bank_Account_Name_System__c, Bank_Name_System__c, Bank_Routing_Number__c, Check_Number__c,
                                  /*checking field to show*/
                                  Bank_Account_Type__c, Bank_Account_Number_Encrypted__c, Bank_Account_Name__c, Bank_Name__c, Routing_Number__c, Account_Number_Checking__c,
                                  /*finance field to fill and show*/
                                  Finance_Company__c, Financed_Amount__c,
                                  /*services pay methods*/
                                  Method_Of_Payment_Service_System__c,
                                  /*credit card field to fill*/
                                  Account_Number_Credit_Card_Service_Syste__c, Card_Expiration_Month_Service_System__c, Card_Expiration_Year_Service_System__c, Card_Last_4_Service_System__c,
                                  Card_Type_Service_System__c, Name_On_Card_Service_System__c, CSV_Service_System__c,
                                  /*checking field to fill*/
                                  Account_Number_Checking_Servicio_System__c, Bank_Account_Name_Service_System__c, Bank_Account_Type_Service_System__c, Bank_Account_Number_Servicio_System__c,
                                  Bank_Name_Service_System__c, Routing_Number_Service_System__c,
                                  /*credit card field to show*/
                                  Account_Number_Credit_Card_Service__c, Card_Expiration_Month_Service__c, Card_Expiration_Year_Service__c, Card_Last_4_Service__c, Card_Type_Service__c,
                                  Name_On_Card_Service__c, CSV_Service__c,
                                  /*checking field to show*/
                                  Account_Number_Checking_Service__c, Bank_Account_Name_Service__c, Bank_Account_Type_Service__c, Bank_Account_Number_Service__c, Bank_Name_Service__c, 
                                  Routing_Number_New__c,
                                  envelopeId__c, EnvelopeAgreeId__c,
                                  Account__r.FirstName, Account__r.LastName
                                  from Home_Services__c 
                                  where id = :RecordId];
        return home;
    }
    @AuraEnabled
    public static Home_Services__c saveHomeService3(Home_Services__c Home_Services){
        upsert Home_Services;
        return getPaymentMethods(Home_Services.Id);
    }
    
    /**
 	 * Fetches all County records. Used to populate account County__c picklists.
 	 * 
 	 * This method is used in:
 	 * 	- diacoContractFirstCustomer.cmp
 	 * 	- diacoCreateAndUpdateAccount.cmp
 	 *  - diacoLeadFormAccount.cmp
 	 * 	- DiacoCmpFlowController.apxc
 	 *  - DiacoLeadFormsManageController.apxc
 	 * 
 	 * @return A map of unique County IDs to county names.
 	 **/
    @AuraEnabled
    public static Map<String, String> getCountyData() {
        Map<String, String> output = new Map<String, String>();
        List<County__c> counties = [SELECT County_Name__c FROM County__c ORDER BY County_Name__c];
        
        for (County__c county: counties) {
            output.put(county.County_Name__c, county.County_Name__c);
        }
        
        return output;
    }
}