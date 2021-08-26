/**************************************************************************************************************
Created By: MST
Description : Class to create chargent records based on account updates
***************************************************************************************************************/

public class nuHome_chargent_Handler {
    public static Integer testThis(){
        Return 2;
    }
/**************************************************************************************************************
    public static void CreateChargent(List<Account> AccList){
        list<ChargentOrders__ChargentOrder__c> chargent = new list<ChargentOrders__ChargentOrder__c>();
        list<Account> updateac = new list<Account>();        
        for(Account currAcc:AccList){
            //This block will execute only if credit card number or account number present in account, and will collect chargent record details from account.
            if(currAcc.Docusign_Credit_Card_Number__c!=Null||currAcc.Docusign_Account_Number__c!=Null){
                system.debug('Chargent Record creation');
                ChargentOrders__ChargentOrder__c currChargentOrder = new ChargentOrders__ChargentOrder__c();
                currChargentOrder.ChargentOrders__Account__c = currAcc.Id;
                currChargentOrder.ChargentOrders__Bank_Account_Number__c = currAcc.Docusign_Account_Number__c;
                currChargentOrder.ChargentOrders__Card_Type__c=currAcc.Docusign_Card_Type__c;
                currChargentOrder.ChargentOrders__Card_Number__c=currAcc.Docusign_Credit_Card_Number__c;                
                if(currAcc.Docusign_Card_Type__c=='American Express')
                    currChargentOrder.ChargentOrders__Card_Security_Code__c=currAcc.Docusign_CVV_Security_Code_AMEX__c;
                if(currAcc.Docusign_Card_Type__c=='Diners Club')
                    currChargentOrder.ChargentOrders__Card_Security_Code__c=currAcc.Docusign_CVV_Security_Code_Diners_Club__c;
                if(currAcc.Docusign_Card_Type__c=='Discover')
                    currChargentOrder.ChargentOrders__Card_Security_Code__c=currAcc.Docusign_CVV_Security_Code_Discover__c;
                if(currAcc.Docusign_Card_Type__c=='JCB Card')
                    currChargentOrder.ChargentOrders__Card_Security_Code__c=currAcc.Docusign_CVV_Security_Code_JCB__c;
                if(currAcc.Docusign_Card_Type__c=='Mastercard')
                    currChargentOrder.ChargentOrders__Card_Security_Code__c=currAcc.Docusign_CVV_Security_Code_Master__c;
                if(currAcc.Docusign_Card_Type__c=='MC Eurocard')
                    currChargentOrder.ChargentOrders__Card_Security_Code__c=currAcc.Docusign_CVV_Security_Code_MC__c;
                if(currAcc.Docusign_Card_Type__c=='UK Maestro')
                    currChargentOrder.ChargentOrders__Card_Security_Code__c=currAcc.Docusign_CVV_Security_Code_UK__c;
                if(currAcc.Docusign_Card_Type__c=='Visa')
                    currChargentOrder.ChargentOrders__Card_Security_Code__c=currAcc.Docusign_CVV_Security_Code_Visa__c;                
                currChargentOrder.ChargentOrders__Card_Expiration_Month__c=currAcc.Docusign_Expiration_Month__c;
                currChargentOrder.ChargentOrders__Card_Expiration_Year__c=currAcc.Docusign_Expiration_Year__c;
                currChargentOrder.ChargentOrders__Bank_Account_Name__c=currAcc.Docusign_Name_On_Account__c;
                currChargentOrder.ChargentOrders__Billing_First_Name__c =currAcc.Docusign_Name_On_Credit_Card__c;
                currChargentOrder.ChargentOrders__Billing_Last_Name__c =currAcc.Docusign_Last_Name__c;
                currChargentOrder.ChargentOrders__Bank_Routing_Number__c=currAcc.Docusign_Routing_Number__c;
                currChargentOrder.ChargentOrders__Billing_Address__c = currAcc.Docusign_Address_Line_1__c;
                currChargentOrder.ChargentOrders__Billing_State__c = currAcc.Docusign_State__c;
                currChargentOrder.ChargentOrders__Billing_City__c = currAcc.Docusign_City__c;
                currChargentOrder.ChargentOrders__Billing_Zip_Postal__c = currAcc.Docusign_Zip__c;
                currChargentOrder.ChargentOrders__Bank_Name__c = currAcc.Docusign_Banking_Institution__c;
                currChargentOrder.ChargentOrders_Origin__c = 'DocuSign';
                //Adding chargent records to chargent object list.
                chargent.add(currChargentOrder);
            }            
        }
        system.debug('Chargent Record creation list size'+chargent.size());
        if(chargent.size()>0)
            insert chargent;
        
        
    }
    //MST added for Delivery 2 object update 02/11
    public static void DeliveryUpdate(List<Account> AccountList,Map<Id,Account> oldMap){
        Set<Id> accIdset = new Set<Id>();
        List<Delivery_Object__c> DeliveryList = new List<Delivery_Object__c>();
        for(Account accountIns : AccountList){
            if( accountIns.Respond_date__c != null && oldMap.get(accountIns.Id).Respond_date__c == Null )
                accIdset.add(accountIns.id);
        }

        for(Delivery_Object__c Delivery : [SELECT Id,Name,Parent_Gift_Card_Order__c,Hung_Status__c FROM Delivery_Object__c WHERE
                                           Person_Account__c IN :accIdset  AND Parent_Gift_Card_Order__r.Name ='Cheetah Gift Card Order' AND Hung_Status__c ='Sent To Cheetah' AND Name = '2']){
                                               Delivery_Object__c deliveryIns = New Delivery_Object__c();
                                               deliveryIns.Id = Delivery.Id;
                                               deliveryIns.Hung_Status__c = 'Remove: Responded';
                                               DeliveryList.add(deliveryIns);
                                           }
        if(DeliveryList.size()>0)
            update DeliveryList;

    }
    
    

***************************************************************************************************************/
}