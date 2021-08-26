@isTest(SeeAllData=true)
public class DiacoSignedContractControllerTest {
    @isTest static void testAll(){
        Account Acc = new Account();
        Acc.FirstName = 'Account ';
        Acc.LastName = 'Test';
        Acc.RecordTypeId ='012410000012NOKAA2';
        Acc.Street__c='test';
        Acc.City__c='test';
        Acc.State__c='AZ';
        Acc.Zip__c='test';
        insert Acc;
        
        Personnel__c per = new Personnel__c();
        per.Name = 'test';
        per.First_Name__c = 'test';
        per.Last_Name__c = 'test';
        per.Kunnect_ID__c = 'none';
        insert per;
        
        Home_Services__c hs = new  Home_Services__c();
        hs.Account__c = Acc.Id;
        hs.RecordTypeId = '012410000013G9OAAU';
        hs.Card_Number__c = '123456789';
        hs.CSV__c = '123';
        hs.Method_Of_Payment__c = 'Credit Card';		 
        hs.ApptSetter__c = per.Id;
        hs.Exp_Date__c = '7/24';
        hs.Name='test test test test';
        hs.Home_Services_Status__c='Schedule';
        hs.Sales_Event_Current_Status__c='Schedule';
        hs.Event_Count__c=1;
        //hs.Sales_Rep__c = u.Id;
        insert hs;
        
        List<Attachment> atts = [select Id, Name, ParentId ,Parent.Name
                                 From Attachment 
                                 where (not name like '%certificate%') and Parent.Name like 'env-%' 
                                 limit 1];
        
        if(atts.size() > 0){
            ddsign__Envelope__c env = new ddsign__Envelope__c();
            env.Id = atts[0].ParentId;
            env.Home_Service__c = hs.Id;
            update env;
        }
        
        test.startTest();
       List<ddsign__Envelope__c> evs= [select Id, Name,ddsign__status__c,LastModifiedDate,ddsign__Pre_Designed_Envelope__r.name
                                         from ddsign__Envelope__c
                                         where (ddsign__status__c = 'signed' or ddsign__status__c = 'completed')
                                         order by LastModifiedDate desc
                                         limit 1];
        String preDesignName=evs[0].ddsign__Pre_Designed_Envelope__r.name;
		DiacoSignedContractController.signedContract(hs.Id);
        DiacoSignedContractController.signedContractByName(hs.Id,preDesignName);
        DiacoSignedContractController.getRecordTypeFromHS(hs.Id);
        
        test.stopTest();
        
    }
}