/*********************************************************************************
*Created by  : MST
*Description : This Schedule class is to auto creation of Billing and the Billing Line records for CPL,SPEC,SUB,Hot lead and DTS weekly,
*so that billing person can generate the Invoices for the Business Accounts correctly.
If there are multiple Inventory for which the Person Account and the Business Account is the same, 
then just one Billing record and the Billing Line record needs to be created.
If there are multiple Person Accounts associated to the same business account, then one billing record should be created and 
multiple billing line record needs to be created under the same billing record.
*************************************************************************************/


Public class BatchBillingHandler {
    
    Public static void donothing(){
        String hoy = 'Today';
    }
    
    // It will create billing records for CPL, SPEC, OB Campaign, DTS and Hot lead.
    /*
    Public Static void ProcessUnMatchingBillingRecords(Map<id, Set<ID>> unMatchingAccountMap,Map<Id,Set<Id>> cplOppMap,Map<id,Inventory__C> inventoryMap,Map<string,inventory__C> personAccountMap,String recordTypeName,Map<Id,Inventory__c> inventoryToUpdateMap,Map<String, List<OpportunityLineITem>> productLineItemMap) {
        
        List<AcctSeed__Billing__c>  accSetBillingList = NEW List<AcctSeed__Billing__c>();
        List<AcctSeed__Billing_Line__c> accSetBillingLineList = NEW List<AcctSeed__Billing_Line__c>();
        Map<id, AcctSeed__Billing__c> billlingAccountMap = NEW Map<id, AcctSeed__Billing__c>();
        Map<id,AcctSeed__Billing__c> BillingMap = NEW Map<id,AcctSeed__Billing__c>();
        Map<String, AcctSeed__GL_Account__c> glAccountIdMap = new Map<String, AcctSeed__GL_Account__c>();
        
        Set<String> glAccountNamesSet = new Set<String>();
        glAccountNamesSet.add('4210-CPL-Telemarketing');
        glAccountNamesSet.add('4220-CPL-NonTelemarket');
        glAccountNamesSet.add('4100-Recurring Subscription Revenue');
        glAccountNamesSet.add('4230 - DT Survey Leads');
        glAccountNamesSet.add('4200-Direct Leads');
        
        for(AcctSeed__GL_Account__c currGL : [SELECT id, Name FROM AcctSeed__GL_Account__c WHERE Name IN :glAccountNamesSet])
        {
            glAccountIdMap.put(currGL.Name, currGL);
        }
        
        // Checking billing record already existing for the business account.
        For(AcctSeed__Billing__c accBilling:[SELECT ID,MSA_Metro_Area__c,Inventory_Creation_Date__c,Account_Name__c,Price__c,Appointment_Date_and_Time__c,Phone__c,AcctSeed__Billing_PostalCode__c,AcctSeed__Billing_Street__c,AcctSeed__Billing_State__c,AcctSeed__Billing_City__c,AcctSeed__Customer__c FROM AcctSeed__Billing__c WHERE AcctSeed__Customer__c IN: unMatchingAccountMap.keyset() AND AcctSeed__Status__c = 'In Process' AND Type__C =:recordTypeName])
            BillingMap.put(accBilling.AcctSeed__Customer__c,accBilling);
        
        
        for (ID idSet : unMatchingAccountMap.keyset()) {
               
                AcctSeed__Billing__c  accBill;
                accBill = NEW AcctSeed__Billing__c();
                accBill.AcctSeed__Customer__c = idSet;
                accBill.AcctSeed__Billing_City__c = inventoryMap.get(idSet).idCPL_Billing_Opportunity__r.Account.Primary_Billing_City__c;
                accBill.AcctSeed__Billing_State__c = inventoryMap.get(idSet).idCPL_Billing_Opportunity__r.Account.Primary_Billing_State__c;
                accBill.AcctSeed__Billing_Street__c = inventoryMap.get(idSet).idCPL_Billing_Opportunity__r.Account.Primary_Billing_Street__c;
                accBill.AcctSeed__Billing_PostalCode__c = inventoryMap.get(idSet).idCPL_Billing_Opportunity__r.Account.Primary_Billing_Zip_Code__c; 
                accbill.AcctSeed__Billing_Country__c = inventoryMap.get(idSet).idCPL_Billing_Opportunity__r.Account.Primary_Billing_country__c; 
                
                // accBill.Phone__c = inventoryMap.get(idSet).idCPL_Billing_Opportunity__r.Account.Phone;
                
                //   if(recordTypeName.equalsIgnoreCase('nuHome OB Campaign'))
                //   accBill.Appointment_Date_and_Time__c = inventoryMap.get(idSet).OB_Call_Center_Appointment_Date__c;
                
                //  accBill.Account_Name__c = inventoryMap.get(idSet).Name;
                //  accBill.Inventory_Creation_Date__c = inventoryMap.get(idSet).createdDate;
                //  accBill.MSA_Metro_Area__c = inventoryMap.get(idSet).Account__r.MSA__c;
                accBill.Type__c = recordTypeName;
         
            
            if(Test.isRunningTest())
            {
                accBill.AcctSeed__Accounting_Period__c = 'a0vj0000001dusW';
                accbill.AcctSeed__Billing_Format__c = 'a1hj0000000xvEz';
                
            }
            accSetBillingList.add(accBill);
        }
        
        if (!accSetBillingList.isEmpty())
            UPSERT accSetBillingList; //  Billing record creation.
        
        for (AcctSeed__Billing__c accBilling : accSetBillingList) {
            
            if (accBilling.AcctSeed__Customer__c <> NULL && accBilling.ID <> NULL)
                billlingAccountMap.put(accBilling.AcctSeed__Customer__c, accBilling);
        }
        
        if (!billlingAccountMap.isEmpty()) {
            
            
            for (ID idSet : billlingAccountMap.keyset()) {
                
                if (unMatchingAccountMap.containsKey(idSet)) {
                    
                    for (ID idSetVal : unMatchingAccountMap.get(idSet)) {
                        
                        for(String currOpp : cplOppMap.get(idSet))
                        {
                            
                            if(personAccountMap.containsKey(currOpp+'-'+idSetVal))
                            {
                                AcctSeed__Billing_Line__c accBill = NEW AcctSeed__Billing_Line__c();
                                accBill.AcctSeed__Billing__c = billlingAccountMap.get(idSet).id;
                                
                                accbill.City__c = personAccountMap.get(currOpp+'-'+idSetVal).User_Address__r.Address__r.City__c;
                                accbill.State__c = personAccountMap.get(currOpp+'-'+idSetVal).User_Address__r.Address__r.State__c;
                                accbill.Street__c = personAccountMap.get(currOpp+'-'+idSetVal).User_Address__r.Address__r.Street__c;
                                accbill.Email__c =  personAccountMap.get(currOpp+'-'+idSetVal).fAccount_Email__c;
                                accbill.Industry__c = personAccountMap.get(currOpp+'-'+idSetVal).fBilling_Opp_Industry__c;
                                accbill.country__c = personAccountMap.get(currOpp+'-'+idSetVal).User_Address__r.Address__r.Country__c;
                                
                                if(personAccountMap.get(currOpp+'-'+idSetVal).account__r.phone != Null)
                                    accbill.Phone__c = personAccountMap.get(currOpp+'-'+idSetVal).account__r.phone;
                                else if(personAccountMap.get(currOpp+'-'+idSetVal).account__r.PersonMobilePhone != Null)
                                    accbill.Phone__c = personAccountMap.get(currOpp+'-'+idSetVal).account__r.PersonMobilePhone;
                                
                                String ProductName = personAccountMap.get(currOpp+'-'+idSetVal).user_address__r.address__r.Branch__r.name+'-'+personAccountMap.get(currOpp+'-'+idSetVal).fBilling_Opp_Industry__c;
                                String key = personAccountMap.get(currOpp+'-'+idSetVal).idCPL_Billing_Opportunity__c+'-'+ProductName;
                                
                                accBill.AcctSeed__List_Price__c  = 0;
                                accBill.AcctSeed__Hours_Units__c = 0;
                                accBill.AcctSeed__Rate__c = 0;
                                
                                
                                
                                if(recordTypeName != 'nuHome nuCard SUB')
                                {
                                    if(personAccountMap.get(currOpp+'-'+idSetVal).Product_Price__c == Null)
                                    {
                                        if(productLineItemMap.containsKey(key))
                                        {
                                            for(OpportunityLineItem currItem : productLineItemMap.get(key))
                                            {
                                                accBill.AcctSeed__List_Price__c = currItem.ListPrice;
                                                if(currItem.quantity!= Null)
                                                accBill.AcctSeed__Hours_Units__c = currItem.quantity;
                                                else
                                                accBill.AcctSeed__Hours_Units__c = 0;
                                                accBill.AcctSeed__Rate__c = currItem.unitPrice;
                                                accbill.Product_Name__c = currItem.product2.Name;
                                            }
                                        }
                                        else
                                        {
                                            accBill.AcctSeed__List_Price__c  = 0;
                                            accBill.AcctSeed__Hours_Units__c = 0;
                                            accBill.AcctSeed__Rate__c = 0;
                                            
                                        }
                                    }
                                    
                                    else
                                    {
                                        accBill.AcctSeed__List_Price__c = personAccountMap.get(currOpp+'-'+idSetVal).List_Price__c;
                                        if(personAccountMap.get(currOpp+'-'+idSetVal).Quantity__c !=null)
                                        accBill.AcctSeed__Hours_Units__c = personAccountMap.get(currOpp+'-'+idSetVal).Quantity__c;
                                        else
                                        accBill.AcctSeed__Hours_Units__c = 0;
                                        
                                        accBill.AcctSeed__Rate__c = personAccountMap.get(currOpp+'-'+idSetVal).Product_Price__c;
                                        accbill.Product_Name__c = personAccountMap.get(currOpp+'-'+idSetVal).product_Name__c;
                                        
                                    }
                                    
                                }
                                
                                else
                                {
                                    accBill.AcctSeed__List_Price__c  = 0;
                                    accBill.AcctSeed__Hours_Units__c = 0;
                                    accBill.AcctSeed__Rate__c = 0;
                                }   
                                
                                if(recordTypeName == 'nuHome nuCard SUB')
                                {
                                    
                                    if(glAccountIdMap.containsKey('4100-Recurring Subscription Revenue'))
                                        accbill.AcctSeed__Revenue_GL_Account__c = glAccountIdMap.get('4100-Recurring Subscription Revenue').id;
                                }   
                                
                                else if(recordTypeName == 'nuHome nuCard CPL' || recordTypeName == 'nuHome nuCard SPEC')
                                {
                                    if(glAccountIdMap.containsKey('4220-CPL-NonTelemarket'))
                                        accbill.AcctSeed__Revenue_GL_Account__c = glAccountIdMap.get('4220-CPL-NonTelemarket').id;
                                }   
                                
                                else if(recordTypeName == 'nuHome OB Campaign')
                                {
                                    if(glAccountIdMap.containsKey('4210-CPL-Telemarketing'))
                                        accbill.AcctSeed__Revenue_GL_Account__c = glAccountIdMap.get('4210-CPL-Telemarketing').id;
                                }   
                                
                                else if(recordTypeName == 'nuHome Hot Lead')
                                {
                                    if(glAccountIdMap.containsKey('4200-Direct Leads'))
                                        accbill.AcctSeed__Revenue_GL_Account__c = glAccountIdMap.get('4200-Direct Leads').id;
                                }  
                                
                                
                                accbill.Inventory_Creation_Date__c = personAccountMap.get(currOpp+'-'+idSetVal).createddate;
                                accBill.Inventory_Name__c =  personAccountMap.get(currOpp+'-'+idSetVal).Name;
                                accbill.Appointment_Date_and_Time__c = personAccountMap.get(currOpp+'-'+idSetVal).OB_Call_Center_Appointment_Date__c;
                                accBill.MSA_Metro_Area__c = personAccountMap.get(currOpp+'-'+idSetVal).user_Address__r.Address__r.MSA__c;
                                
                                if(accBill.phone__c != Null)
                                    accBill.Phone_Validation__c = true;
                                if(personAccountMap.containsKey(currOpp+'-'+idSetVal))
                                    accbill.Account_Name__c = personAccountMap.get(currOpp+'-'+idSetVal).Account__r.Name;
                                
                                if(Test.isRunningTest())
                                {
                                    accbill.AcctSeed__Revenue_GL_Account__c = 'a21j0000000bi4v';
                                    accBill.AcctSeed__List_Price__c  = 0;
                                    accBill.AcctSeed__Hours_Units__c = 0;
                                    accBill.AcctSeed__Rate__c = 0;
                                }  
                                
                                
                                accSetBillingLineList.add(accBill);    
                            }
                        } 
                    }
                }
            }
            
            System.debug('accSetBillingLineList' + accSetBillingLineList);
            
            if (!accSetBillingLineList.isempty())
            {
                INSERT accSetBillingLineList; // Creating billing line items.
                UPDATE inventoryToUpdateMap.values(); // Updating inventory records are processed.
            }
            
        }
    }
    
    
    // It will create billing records DTS inventory records.
    
    Public Static void ProcessDoorTagScriptBillingRecords( Map<Id,List<Inventory__c>> businessAccountMap,String recordTypeName,Map<id,Inventory__C> inventoryMap,Map<Id,Inventory__c> inventoryToUpdateMap)
    {
        
        List<AcctSeed__Billing__c>  accSetBillingList = NEW List<AcctSeed__Billing__c>();
        List<AcctSeed__Billing_Line__c> accSetBillingLineList = NEW List<AcctSeed__Billing_Line__c>();
        Map<ID, AcctSeed__Billing__c> billlingAccountMap = NEW Map<ID, AcctSeed__Billing__c>();
        Map<id,AcctSeed__Billing__c> BillingMap = NEW Map<id,AcctSeed__Billing__c>();
        
        List<AcctSeed__GL_Account__c> currGL = [SELECT id, Name FROM AcctSeed__GL_Account__c WHERE Name = '4200-Direct Leads' ];
        
        Map<String, OpportunityLineItem> inventoryPriceMap = new Map<String,OpportunityLineItem>();
        Set<String> lineItemsSet = new Set<String>();
        Set<String> inventoryIds = new Set<String>();
        
        // Checking billing record is already existing for business account or not.
        
        For(AcctSeed__Billing__c accBilling: [SELECT ID,MSA_Metro_Area__c,Inventory_Creation_Date__c,Account_Name__c,Price__c,
                                              Appointment_Date_and_Time__c,Phone__c,
                                              AcctSeed__Billing_PostalCode__c,AcctSeed__Billing_Street__c,AcctSeed__Billing_State__c,
                                              AcctSeed__Billing_City__c,AcctSeed__Customer__c FROM AcctSeed__Billing__c 
                                              WHERE AcctSeed__Customer__c IN: businessAccountMap.keyset() AND AcctSeed__Status__c = 'In Process' AND Type__C =:recordTypeName])
            BillingMap.put(accBilling.AcctSeed__Customer__c,accBilling);
        
        
        for (ID idSet : businessAccountMap.keyset()) {
               
                AcctSeed__Billing__c  accBill;
                accBill = NEW AcctSeed__Billing__c();
                accBill.AcctSeed__Customer__c = idSet;
                accBill.AcctSeed__Billing_City__c = inventoryMap.get(idSet).idCPL_Billing_Opportunity__r.Account.Primary_Billing_City__c;
                accBill.AcctSeed__Billing_State__c = inventoryMap.get(idSet).idCPL_Billing_Opportunity__r.Account.Primary_Billing_State__c;
                accBill.AcctSeed__Billing_Street__c = inventoryMap.get(idSet).idCPL_Billing_Opportunity__r.Account.Primary_Billing_Street__c;
                accBill.AcctSeed__Billing_PostalCode__c = inventoryMap.get(idSet).idCPL_Billing_Opportunity__r.Account.Primary_Billing_Zip_Code__c; 
                accbill.AcctSeed__Billing_Country__c = inventoryMap.get(idSet).idCPL_Billing_Opportunity__r.Account.Primary_Billing_country__c; 
                // accBill.Phone__c = inventoryMap.get(idSet).ANI__c;
                // accBill.Account_Name__c = inventoryMap.get(idSet).Name;
                //  accBill.Inventory_Creation_Date__c = inventoryMap.get(idSet).createdDate;
                //  accBill.MSA_Metro_Area__c = inventoryMap.get(idSet).Account__r.MSA__c;
                accBill.Type__c = recordTypeName;
                
                if(Test.isRunningTest())
                {
                    accBill.AcctSeed__Accounting_Period__c = 'a0vj0000001dusW';
                    accbill.AcctSeed__Billing_Format__c = 'a1hj0000000xvEz';
                    
                }
        
            accSetBillingList.add(accBill);
        }
        
        
        
        if (!accSetBillingList.isEmpty())
        {
            
            UPSERT accSetBillingList; // creating billing record.
        }
        
        for (AcctSeed__Billing__c accBilling : accSetBillingList) {
            
            if (accBilling.AcctSeed__Customer__c <> NULL && accBilling.ID <> NULL)
                billlingAccountMap.put(accBilling.AcctSeed__Customer__c, accBilling);
        }
        
        
        
        if (!billlingAccountMap.isEmpty()) {
            
            for (ID idSet : billlingAccountMap.keyset()) {
                
                if (businessAccountMap.containsKey(idSet)) {
                    
                    for (Inventory__c currInv : businessAccountMap.get(idSet)) {
                        
                        AcctSeed__Billing_Line__c accBillLine = NEW AcctSeed__Billing_Line__c();
                        accBillLine.AcctSeed__Billing__c = billlingAccountMap.get(idSet).id;
                        // accBillLine.AcctSeed__Rate__c = 1;
                        // accBillLine.AcctSeed__Hours_Units__c = 1;
                        accBillLine.City__c = currInv.User_Address__r.Address__r.City__c;
                        accBillLine.State__c = currInv.User_Address__r.Address__r.State__c;
                        accBillLine.Street__c = currInv.User_Address__r.Address__r.Street__c;
                        accBillLine.Email__c = currInv.fAccount_Email__c;
                        accBillLine.Industry__c = currInv.fBilling_Opp_Industry__c;
                        accBillLine.country__c = currInv.User_Address__r.Address__r.Country__c;
                        
                        if(currInv.account__r.phone != Null)
                            accBillLine.Phone__c = currInv.account__r.phone;
                        else
                            accBillLine.Phone__c = currInv.account__r.personmobilephone;
                        accBillLine.Inventory_Creation_Date__c = currInv.createddate;
                        accBillLine.Appointment_Date_and_Time__c = currInv.OB_Call_Center_Appointment_Date__c;
                        
                        accBillLine.MSA_Metro_Area__c = currInv.user_Address__r.Address__r.MSA__c;
                        accBillLine.Survey_Question__c  = currInv.Survey_Question__c;
                        accBillLine.Survey_Response__c = currInv.Survey_Response__c;
                        if(currInv.Phone_Mobile__c != Null)
                            accBillLine.Phone_Validation__c = true;
                        
                        accBillLine.Account_Name__c = currInv.account__r.name;
                        accBillLine.Inventory_Name__c = currInv.name;
                        
                        if(currInv.List_Price__c != Null)
                            accBillLine.AcctSeed__List_Price__c = currInv.List_Price__c;
                        else
                            accBillLine.AcctSeed__List_Price__c = 0;
                        
                        if(currInv.Product_Price__c != Null)  
                            accBillLine.AcctSeed__Rate__c = currInv.Product_Price__c;
                        else
                            accBillLine.AcctSeed__Rate__c =0;
                        
                        if(currInv.Quantity__c != Null)    
                            accBillLine.AcctSeed__Hours_Units__c = currInv.Quantity__c;
                        else
                            accBillLine.AcctSeed__Hours_Units__c = 0;
                        
                        if( accBillLine.Product_Name__c != Null)
                            accBillLine.Product_Name__c = currInv.Product_Name__c;
                        
                        if(currGL.size() > 0)
                            accBillLine.AcctSeed__Revenue_GL_Account__c = currGL[0].id;
                        
                        if(Test.isRunningTest())
                        {
                            accBillLine.AcctSeed__Revenue_GL_Account__c = 'a21j0000000bi4v';
                        } 
                        
                        
                        accSetBillingLineList.add(accBillLine); 
                        
                    }
                }
            }
            
            System.debug('accSetBillingLineList' + accSetBillingLineList);
            
            if(!accSetBillingLineList.isempty())
            { 
                INSERT accSetBillingLineList;  // creating billing line item
                UPDATE inventoryToUpdateMap.values(); // updating inventory records are processed.
            }
            
        }
        
    }
    */
}