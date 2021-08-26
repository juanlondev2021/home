public class diacoRenderContractController {
    private final Home_Services__c hs;
    public List<PaymentMethod__c> paymentMethodsProd{get; set;}
    public List<PaymentMethod__c> paymentMethodsServ{get; set;}
    public list<String> communicationByList{get;set;}
    public list<String> eventGroupsToForwardList{get;set;}
    public list<String> monthlySecurityServicesList {get;set;}
    public list<String> alarmcomAdditionalServicesList {get;set;}
    public List<Line_Item__c> productList {get;set;}
    public List<Line_Item__c> ServiceList {get;set;}
    public boolean existWarranty {get;set;}
    public decimal monitoring {get;set;}
    public Date notLaterThanMidnightOf {get; set;}
    public boolean isService {get; set;}
    public String CSIDNumber {get; set;}
    public Map<String, String> AddOnFeatures {get; set;}

    
    public diacoRenderContractController(ApexPages.StandardController stdController){
        
        this.hs = (Home_Services__c)stdController.getRecord();
        
        if(this.hs.Id !=null){
            notLaterThanMidnightOf =AddBusinessDays(system.today(),3);
            paymentMethodsProd = paymentMethodList(this.hs.Id,'Products');
            paymentMethodsServ = paymentMethodList(this.hs.Id,'Services');
            productList = getLineItems(this.hs.Id,false);
            ServiceList = getLineItems(this.hs.Id,true);
            monitoring = getMonitoringInvestment(ServiceList);
            existWarranty = verifyWarranty(ServiceList);
            Home_Services__c homeService = [select Customer_Alarm__c from Home_Services__c where id = :hs.Id];
            if (String.isNotblank(homeService.Customer_Alarm__c)) {
                List<DiacoAlarm__DiacoSiteAvantguard__c>  diacoSitesAvantguard =
                [select id, DiacoAlarm__DiacoTransmitterCode__c, DiacoAlarm__Diaco_Customer_Alarm__r.DiacoAlarm__DiacoAddOnFeatures__c from DiacoAlarm__DiacoSiteAvantguard__c where
                        DiacoAlarm__Diaco_Customer_Alarm__c =:homeService.Customer_Alarm__c];
                if (!diacoSitesAvantguard.isEmpty()) {
                    CSIDNumber = diacoSitesAvantguard.get(0).DiacoAlarm__DiacoTransmitterCode__c;
                    AddOnFeatures = getValuesAndLabels(DiacoAlarm__Diaco_Customer_Alarm__c.DiacoAlarm__DiacoAddOnFeatures__c,
                            diacoSitesAvantguard.get(0).DiacoAlarm__Diaco_Customer_Alarm__r.DiacoAlarm__DiacoAddOnFeatures__c.split(';'));
                }
            }
            getHomeServiceInfo(this.hs.Id);     
        }



    }

   

    public List<PaymentMethod__c> paymentMethodList(Id homeServiceId,String paymentDestination){

        List<PaymentMethod__c> paymentMethods = [SELECT AccountNumberChecking__c,BankAccountNumber__c,
        BankAccountType__c,BankName__c,CardExpirationMonth__c,
        CardNumber__c,CardType__c,Card_Expiration_Year__c,
        CSV__c,FinanceCompany__c,FinancedAmount__c,Id,NameOnCard__c,
        PaymentMethodType__c,RoutingNumber__c,Bank_Account_Name__c 
        FROM PaymentMethod__c where HomeService__c =: homeServiceId and Payment_Destination__c =: paymentDestination];

        //return paymentMethodsProd;
        return paymentMethods;

    }

    public Decimal getMonitoringInvestment(List<Line_Item__c> ServiceList){

        decimal monitoringInvestment = 0.0;
        for (Line_Item__c service : ServiceList) {
            if (service.Name == 'Alarm Monitoring') {
                monitoringInvestment = service.Monthly_Investment__c;
                break;
            }       
        }

        return monitoringInvestment;
    }

    public boolean verifyWarranty(List<Line_Item__c> ServiceList){
    
        boolean existWarranty = false;
        for (Line_Item__c service : ServiceList) {
            if (service.Name == 'Warranty') {
                existWarranty = true;
                break;
            }       
        }

        return existWarranty;
    }

    public List<PaymentMethod__c> getPMChecking(){
        List<PaymentMethod__c> pm  = new List<PaymentMethod__c>();
        System.debug('Payment Services');
        System.debug(this.hs.Id);
        for(PaymentMethod__c item: paymentMethodsProd){
            if(item.PaymentMethodType__c =='Checking'){
                pm.add(item);
                break;
            }
        }
        return pm;
    }

    public list<DiacoAlarm__DiacoSiteContact__c> getContacts() {
        return [SELECT id,
                DiacoAlarm__DiacoFirstName__c,
                DiacoAlarm__DiacoLastName__c,
                DiacoAlarm__DiacoPhone__c 
                FROM DiacoAlarm__DiacoSiteContact__c 
                WHERE  DiacoAlarm__DiacoCustomerAlarm__r.Home_Service__c =:this.hs.Id LIMIT 4];        
    }

    public void getHomeServiceInfo(Id homeServiceId){
        
        Home_Services__c hsElement = [select Id,X2_Story__c,
                                      Customer_Alarm__c, Communication_By__c, 
                                      Monthly_Security_Services__c, Alarm_com_Additional_Services__c,
                                      Customer_Alarm__r.DiacoAlarm__DiacoCsEventGroupsToForward__c
                                      from Home_Services__c where Id=:this.hs.Id];
        
        list<String> communicationValue = new list<String>();
        
        if(hsElement.Communication_By__c != null){
            communicationByList = hsElement.Communication_By__c.split(';');
        }
        
        if(hsElement.Monthly_Security_Services__c != null){
            monthlySecurityServicesList = hsElement.Monthly_Security_Services__c.split(';');
            isService = hsElement.Monthly_Security_Services__c.contains('Service');

        }
        
        if(AddOnFeatures != null && !AddOnFeatures.isEmpty()){

            alarmcomAdditionalServicesList = new List<String> (getSelectedAddons()); //hsElement.Alarm_com_Additional_Services__c.split(';');
        }
        
        if(hsElement.Customer_Alarm__r.DiacoAlarm__DiacoCsEventGroupsToForward__c != null){
            eventGroupsToForwardList = hsElement.Customer_Alarm__r.DiacoAlarm__DiacoCsEventGroupsToForward__c.split(';');
        }  
    }

    public Set<String> getSelectedAddons() {
        Set<String> selectedAddons = new Set<String>();

        Map<String, String> posiblesValues = getValuesAndLabels(Home_Services__c.Alarm_com_Additional_Services__c, null);
        if (this.AddOnFeatures != null) {
            for (String addon: this.AddOnFeatures.keySet()) {
                if (posiblesValues.containsKey(addon)) {
                    selectedAddons.add(addon);
                }
                else if ('Locks' == addon) {
                    selectedAddons.add('Lock Service');
                }
                else if (addon.contains('Thermostat')) {
                    selectedAddons.add('Thermostat Service');
                }
                else if (addon.contains('Lights')) {
                    selectedAddons.add('Lights Service');
                }
                else if (addon.contains('Doorbell Camera')) {
                    selectedAddons.add('Doorbell Camera');
                }

                else if (addon.contains('Two-Way Voice')) {
                    selectedAddons.add('Two-Way Voice');
                }

                else if (addon == 'Pro Video') {
                    selectedAddons.add('Pro Video 3-4 Cameras');
                }

                else if (addon == 'Pro Video Plus') {
                    selectedAddons.add('Pro Video Plus 5-8 Cameras');
                }
            }
        }
        return selectedAddons;
    }

    /**
    * Method responsible to get the values for a picklist.
    *
    * @param picklistToGet schema the picklist that wish to get.
    *
    * @return values for the picklist.
    */
    public static Map<String, String> getValuesAndLabels(SObjectField picklistToGet, List<String> selectedAddons1) {
        Map<String,String> optionsValues = new Map<String, String>();
        Set<String> selectedAddons = null;
        if (selectedAddons1 != null) {
            selectedAddons = new Set<String> (selectedAddons1);
        }
        for( Schema.PicklistEntry f :  picklistToGet.getDescribe().getPicklistValues())
        {
            if (selectedAddons != null) {
                if (selectedAddons.contains(f.getValue())) {
                    optionsValues.put(f.getLabel(), f.getValue());
                }
            }
            else {
                optionsValues.put(f.getLabel(), f.getValue());
            }
        }
        return optionsValues;
    }
    public Home_Services__c getHs(){
        return [select Account__r.Billing_First_Name__c, Account__r.Billing_Last_Name__c,
        Account__r.Primary_Billing_Street__c, Account__r.Billing_Phone__c,
        Account__r.Primary_Billing_City__c, Account__r.Primary_Billing_State__c,
        Account__r.Primary_Billing_Zip_Code__c, Account__r.Billing_Email__c, Account__r.Number_of_Stories__c
        from Home_Services__c where Id=:this.hs.Id];
    }

    public List<Line_Item__c> getLineItems(Id homeServiceId,boolean areServices){
        
        List<Line_Item__c> LineItemList = new List<Line_Item__c>();
        
        if(homeServiceId != null){
            
            LineItemList = [select Id,Name,Quantity__c,Sales_Price__c,Part_Number__c,
                        Total_Price__c,Home_Service__c,Billing_Frequency__c, Monthly_Investment__c 
                        from Line_Item__c where Home_Service__c =:homeServiceId and Product__r.Service__c =: areServices];
            
            if(!areServices){
                Integer element = 10 - LineItemList.size();
                System.debug(element);
                if(LineItemList.size() < 10){
                    for (Integer i = 0, j = 0; i < element; i++) {
                        LineItemList.add(new Line_Item__c());
                    }
                }  
            }
        }
        System.debug('--------------');
        System.debug(LineItemList.size());
        System.debug('--------------');
        return LineItemList;
    }
    
   public static Boolean IsWeekendDay(Date dateParam)
   {
      boolean result = false;
      system.debug('dateParam = '+dateParam); 
      //Recover the day of the week
      Date startOfWeek   = dateParam.toStartOfWeek();
      system.debug('startOfWeek = '+startOfWeek);
      Integer dayOfWeek  = dateParam.day() - startOfWeek.day();
      system.debug('dayOfWeek = '+dayOfWeek);   
      result = dayOfWeek == 0 || dayOfWeek == 6 ? true : false;
      system.debug('result = '+result); 
      return result;
   } 
   
   
   public static Date AddBusinessDays(Date StartDate, integer BusinessDaysToAdd )
   {
      //Add or decrease in BusinessDaysToAdd days 
      Date finalDate = StartDate;
      system.debug('finaldate = '+finalDate);
      integer direction = BusinessDaysToAdd < 0 ? -1 : 1;
      system.debug('direction = '+direction);
       while(BusinessDaysToAdd != 0)
       {
           finalDate = finalDate.AddDays(direction);
           system.debug('BusinessDaysToAdd = '+BusinessDaysToAdd);            
           system.debug('finaldate = '+finalDate);
           if (!isWeekendDay(finalDate))
           {
               BusinessDaysToAdd -= direction;
               
           }
       }

       return finalDate;
   }
 
    public Date getExpirationDate(){
        Date today=Date.today();
        Date expirationDate=today.addYears(1);
        return expirationDate.addDays(-1);
    }
    
     public List<String> getPickListValuesIntoList(){
       List<String> pickListValuesList= new List<String>();

		Schema.DescribeFieldResult fieldResult = DiacoAlarm__Diaco_Customer_Alarm__c.DiacoAlarm__DiacoPackageId__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry pickListVal : ple){
			pickListValuesList.add(pickListVal.getLabel());
		}     
		return pickListValuesList;
    }
    
     public List<String> getPickListValuesIntoListCommunication(){
       List<String> pickListValuesList= new List<String>();

		Schema.DescribeFieldResult fieldResult = Home_Services__c.Communication_By__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry pickListVal : ple){
			pickListValuesList.add(pickListVal.getLabel());
		}     
		return pickListValuesList;
    }
    
    public list<String> getPickListValuesMonthlySecurity(){
        
        List<String> pickListValuesList= new List<String>();
        
        Schema.DescribeFieldResult fieldResult = Home_Services__c.Monthly_Security_Services__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }     
        return pickListValuesList;
    }
    
       public list<String> getPickListValueAlarmcomAdditionalServices(){
        
        List<String> pickListValuesList= new List<String>();
        
        Schema.DescribeFieldResult fieldResult = Home_Services__c.Alarm_com_Additional_Services__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }     
        return pickListValuesList;
    }
    
     public list<String> getPickListValueAlarmCommunication(){
        
        List<String> pickListValuesList= new List<String>();
        
        Schema.DescribeFieldResult fieldResult = DiacoAlarm__Diaco_Customer_Alarm__c.DiacoAlarm__DiacoCsEventGroupsToForward__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }     
        return pickListValuesList;
    }   
    
    public Decimal getWarrantyAmount(){
        Integer size = ServiceList.size();
        Decimal response = 0;
        for(Integer i = 0; i<size; i++){
            if(ServiceList[i].Name == 'Warranty'){
                response+=ServiceList[i].Monthly_Investment__c;
            }
        }
        System.debug('####RESPONSE####');
        System.debug(response);
        return response;
    }
}