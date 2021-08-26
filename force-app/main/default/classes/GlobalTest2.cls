@isTest(SeeAllData = true)
private class GlobalTest2 {
        static testMethod void testMethod1(){
            String recTypeId = [Select id from recordType where developerName='PersonAccount' limit 1].Id;
            
            Contact con = new Contact();
            con.LastName = 'testcontact';
            insert con;

            Product2 prod = new Product2(Name = 'Prime Front cards');
            insert prod;

            Pricebook2 standard = [Select Id, Name, IsActive From Pricebook2 where IsStandard = true LIMIT 1];

            PriceBook2 pb2=new PriceBook2();
            pb2.Name = 'test';
            pb2.IsActive = true;
            insert pb2;

            PricebookEntry one = new PricebookEntry();
            one.pricebook2Id = standard.id;
            one.product2id = prod.id;
            one.unitprice = 1249.0;
            one.isactive = true;
            insert one;

            PricebookEntry ret = new PricebookEntry();
            ret.pricebook2Id = pb2.id;
            ret.product2id = prod.id;
            ret.unitprice = 1250.0;
            ret.isactive = true;
            insert ret;

            
            Account acc = new Account();
            acc.lastname = 'TestAccount';
            acc.recordTypeId = recTypeId;
            acc.Primary_Shipping_Zip_Code__c = '72832';
            acc.Phone = '2222222222';
            try{
                insert acc;
            }
            catch(exception e){
                system.assert(false,'Failed to insert the Account record. '+e.getMessage());
            }
            Opportunity opp = new Opportunity();
            opp.accountId = acc.Id;
            opp.name='TestOpp';
            opp.closeDate = date.today();
            opp.Operational_Stages__c = 'Gift Card Client Approved';
            opp.Branch__c = 'Asheville-NC';
            opp.type = 'Existing Business';
            opp.DID__c = 'Test';
            opp.Back_pdf__c = 2;
            opp.Front_pdf__c = 2;
            opp.stageName = 'Value Proposition';
            try{
                insert opp;
            }
            catch(exception e){
                system.assert(false,'Failed to insert the opp'+e.getMessage());
            }
            list<Product2> eachProd = [select id,name from product2 where name = 'Prime Front cards' limit 1];
            list<PricebookEntry> peId = [Select id from PricebookEntry where product2Id =:eachProd[0].id limit 1];
            list<OpportunityLineItem> opllist = new list<OpportunityLineItem>();

            OpportunityLineItem opl = new OpportunityLineItem();
            opl.PricebookEntryId = peId[0].Id;
            opl.opportunityId = opp.id;
            opl.Quantity = 1;
            opl.totalPrice = 100;
            opllist.add(opl);

            OpportunityLineItem opl1 = new OpportunityLineItem();
            opl1.PricebookEntryId = peId[0].Id;
            opl1.opportunityId = opp.id;
            opl1.Quantity = 1;
            opl1.totalPrice = 100;
            opllist.add(opl1);

             try{
                insert opllist;
            }
            catch(exception e){
                system.assert(false,'Failed to insert the oppline'+e.getMessage());
            }
            try{
                delete opllist[0];
            }
            catch(exception e){
                system.assert(false,'Failed to delete the oppline'+e.getMessage());
            }
        }
}