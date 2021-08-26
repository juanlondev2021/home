/**
* Diaco
* @author 			Esnayder Morales href=<emorales@diaco.us>
* Project:			Contracts
* Description:		Manage information to contract ASP, SRP and ED3
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					    Description
*			-----	----------		--------------------	    ---------------
* @version	1.0		15/06/2020		Esnayder Morales (EM)		Initial version.
**/
public class DiacoContractAPS {

    //Atribute
    private final Home_Services__c hs;
    public decimal totalModule {get; set;}
    public decimal totalInverter {get; set;}
    private final List<PaymentMethod__c> pm;
    public boolean cash {get; set;}
    public boolean finance {get; set;}
    public boolean lease {get; set;}
    public boolean other {get; set;}


    /**
     * This constructor the class
     * 
     * 
     * @param ApexPages.StandardController stdController
     * @return nothing
     **/
    public DiacoContractAPS(ApexPages.StandardController stdController){
       this.hs = (Home_Services__c)stdController.getRecord();
       this.pm = getPaymentMethods();
       setMethod();
    }

    /**
     * This method is responsible to get cash method value if exist
     * 
     * This method is used in:
     * ContractSolarAPS.page, NergiSolutions_LLC_SRP.page
     * 
     * @param nothing
     * @return Boolean
     **/
    public boolean getCash(){
        return cash;
    }

    /**
     * This method is responsible to get finance method value if exist
     * 
     * This method is used in:
     * ContractSolarAPS.page, NergiSolutions_LLC_SRP.page
     * 
     * @param nothing
     * @return Boolean
     **/
    public boolean getFinance(){
        return finance;
    }

    /**
     * This method is responsible to get lease method value if exist
     * 
     * This method is used in:
     * ContractSolarAPS.page, NergiSolutions_LLC_SRP.page
     * 
     * @param nothing
     * @return Boolean
     **/
    public boolean getLease(){
        return lease;
    }

    /**
     * This method is responsible to get other method value if exist
     * 
     * This method is used in:
     * ContractSolarAPS.page, NergiSolutions_LLC_SRP.page
     * 
     * @param nothing
     * @return Boolean
     **/
    public boolean getOther(){
        return other;
    }

    /**
     * This method is responsible to set the true or false value to payment method
     * 
     * This method is used in:
     * DiacoContractAPS method
     * 
     * @param nothing
     * @return nothing
     **/
    public void setMethod(){
        String look = '';
        for(PaymentMethod__c item : pm){
            if(!look.contains(item.PaymentMethodType__c)){
                look += item.PaymentMethodType__c;
                finance = look.contains('Finance');
                cash = look.contains('Cash');
                lease = look.contains('Lease');
                other = look.contains('ACH') || look.contains('Credit Card') || look.contains('Checking');
            }
        }
    }

    /**
     * This method is responsible to get the fields that doesn´t return standarcontroller
     * 
     * This method is used in:
     * ContractSolarAPS.page, NergiSolutions_LLC_SRP.page
     * 
     * @param nothing
     * @return Home_Services__c
     **/
    public Home_Services__c getHs(){
        return [select way_restricted_or_impeded__c, Explain_SRP__c,
        Sales_Representative__c,Send_Utility_Solar__c, Battery_Use_Backup_Power__c,
        Battery_Use_Energy_Demand_Reduction__c, Battery_Use_Solar_Self_consumption__c,
        Battery_Location_Garage__c, Battery_Location_Inside__c, Battery_Location_Outside__c
        from Home_Services__c where Id=:this.hs.Id];
    }

    /**
     * This method is responsible to get payments method
     * 
     * This method is used in:
     * ContractSolarAPS.page, NergiSolutions_LLC_SRP.page
     * 
     * @param nothing
     * @return List<PaymentMethod__c>
     **/
    public List<PaymentMethod__c> getPaymentMethods(){
        List<PaymentMethod__c> PaymentMethods = new List<PaymentMethod__c>();
        System.debug(hs.Id);
        if(hs.Id!=null){
            PaymentMethods = [select Id, Name, AccountNumberChecking__c, Amount__c, Bank_Account_Name__c,
            BankAccountNumber__c, BankName__c, BankAccountType__c, CardExpirationMonth__c,  
            Card_Expiration_Year__c, CardNumber__c, CardType__c, CSV__c, 
            FinanceCompany__c, FinancedAmount__c, NameOnCard__c, Payment_Destination__c, 
            Payment_Frequency__c, PaymentMethodType__c, RoutingNumber__c from PaymentMethod__c where HomeService__c =:this.hs.Id];
            System.debug(PaymentMethods);
        }
        return PaymentMethods;
    }

    /**
     * This method is responsible to get products
     * 
     * This method is used in:
     * ContractSolarAPS.page, NergiSolutions_LLC_SRP.page
     * 
     * @param nothing
     * @return List<Line_Item__c>
     **/
    public List<Line_Item__c> getProducts(){
        List<Line_Item__c> listItems = new List<Line_Item__c>();
        if(hs.Id!=null){
            listItems = [select Product__r.Name, Product__r.Manufacture__c
            from Line_Item__c where Home_Service__c =:this.hs.Id];
        }
        return listItems;
    }

    /**
     * This method is responsible to get inverte products 
     * 
     * This method is used in:
     * ContractSolarAPS.page, NergiSolutions_LLC_SRP.page
     * 
     * @param nothing
     * @return List<Line_Item__c>
     **/
    public List<Line_Item__c> getProductsInverter(){
        List<Line_Item__c> listItems = new List<Line_Item__c>();
        if(hs.Id!=null){
            listItems = [select Product__r.Name, Product__r.Manufacture__c,
            Product__r.Product_Type__c, Product__r.Part_Number__c, Quantity__c,
            Product__r.Nameplate_rating_kW_AC__c, Product__r.Max_power_rating_watts__c
            from Line_Item__c where Home_Service__c =:this.hs.Id and Product__r.Remodel_Category__c='Inverter'];
        }
        return listItems;
    }

    /**
     * This method is responsible to get modules products
     * 
     * This method is used in:
     * ContractSolarAPS.page, NergiSolutions_LLC_SRP.page
     * 
     * @param nothing
     * @return List<Line_Item__c>
     **/
    public List<Line_Item__c> getProductsModules(){
        List<Line_Item__c> listItems = new List<Line_Item__c>();
        if(hs.Id!=null){
            listItems = [select Product__r.Name, Product__r.Manufacture__c,
            Product__r.Product_Type__c, Product__r.Part_Number__c, Quantity__c,
            Product__r.Nameplate_rating_kW_AC__c, Product__r.Tilt__c, 
            Product__r.Azimuth__c, Product__r.Max_power_rating_watts__c
            from Line_Item__c where Home_Service__c =:this.hs.Id and Product__r.Remodel_Category__c='Module'];
        }
        return listItems;
    }

    /**
     * This method is responsible to get demands products
     * 
     * This method is used in:
     * ContractSolarAPS.page, NergiSolutions_LLC_SRP.page
     * 
     * @param nothing
     * @return List<Line_Item__c>
     **/
    public List<Line_Item__c> getProductsDemands(){
        List<Line_Item__c> listItems = new List<Line_Item__c>();
        if(hs.Id!=null){
            listItems = [select Product__r.Name, Product__r.Manufacture__c,
            Product__r.Product_Type__c, Product__r.Part_Number__c, Quantity__c,
            Product__r.Nameplate_rating_kW_AC__c, Product__r.Tilt__c, 
            Product__r.Azimuth__c, Product__r.Max_power_rating_watts__c
            from Line_Item__c where Home_Service__c =:this.hs.Id and Product__r.Remodel_Category__c='Demand Management System'];
        }
        return listItems;
    }

    /**
     * This method is responsible to get battery storage
     * 
     * This method is used in:
     * ContractSolarAPS.page, NergiSolutions_LLC_SRP.page
     * 
     * @param nothing
     * @return List<Line_Item__c>
     **/
    public List<Line_Item__c> getProductsBatteryStorage(){
        List<Line_Item__c> listItems = new List<Line_Item__c>();
        if(hs.Id!=null){
            listItems = [select Product__r.Name, Product__r.Manufacture__c,
            Product__r.Product_Type__c, Product__r.Part_Number__c, Quantity__c,
            Product__r.Nameplate_rating_kW_AC__c, Product__r.Tilt__c, 
            Product__r.Power_kW_DC__c, Product__r.Energy_kWh_DC__c
            from Line_Item__c where Home_Service__c =:this.hs.Id and Product__r.Remodel_Category__c='Battery Storage'];
        }
        return listItems;
    }

    public List<Line_Item__c> getProductsBatteryInverter(){
        List<Line_Item__c> listItems = new List<Line_Item__c>();
        if(hs.Id!=null){
            listItems = [select Product__r.Name, Product__r.Manufacture__c,
            Product__r.Product_Type__c, Product__r.Part_Number__c, Quantity__c,
            Product__r.Nameplate_rating_kW_AC__c, Product__r.Tilt__c, 
            Product__r.Power_kW_DC__c
            from Line_Item__c where Home_Service__c =:this.hs.Id and Product__r.Remodel_Category__c='Battery Inverter'];
        }
        return listItems;
    }


    /**
     * This method is responsible to get total product inverter
     * 
     * This method is used in:
     * ContractSolarAPS.page, NergiSolutions_LLC_SRP.page
     * 
     * @param nothing
     * @return decimal
     **/
    public decimal getTotalProductInverter(){
        List<Line_Item__c> listItems = getProductsInverter();
        decimal response = 0.0;
        if(listItems.size()>0){
            for(Line_Item__c li : listItems){
                if( li.Product__r.Nameplate_rating_kW_AC__c != null &&
                li.Quantity__c != null){
                    System.debug('NamePlate');
                    System.debug(li.Product__r.Nameplate_rating_kW_AC__c);
                    System.debug(li.Quantity__c);
                    response += li.Product__r.Nameplate_rating_kW_AC__c * li.Quantity__c;
                }
                
            }
        }
        System.debug(response);
        totalInverter = response;
        return response;
    }

    /**
     * This method is responsible to get total product modules
     * 
     * This method is used in:
     * ContractSolarAPS.page, NergiSolutions_LLC_SRP.page
     * 
     * @param nothing
     * @return decimal
     **/
    public decimal getTotalProductModules(){
        List<Line_Item__c> listItems = getProductsModules();
        decimal response = 0.0;
        if(listItems.size()>0){
            for(Line_Item__c li : listItems){
                if( li.Product__r.Max_power_rating_watts__c != null &&
                li.Quantity__c != null){
                    response += li.Product__r.Max_power_rating_watts__c * li.Quantity__c;
                }
            }
        }
        System.debug(response);
        totalModule = response;
        return response;
    }

}