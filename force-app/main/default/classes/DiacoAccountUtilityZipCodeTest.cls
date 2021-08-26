@isTest
public class DiacoAccountUtilityZipCodeTest {
    @isTest static void testAll(){
        Region__c region = new Region__c();
        region.Name = 'Test';
        insert region;
        Branch__c branch = new Branch__c();
        branch.Name = 'Test';
        branch.Region_MD__c = region.Id;
        branch.Carrier_ID__c = 'test';
        insert branch;
        List<ZipCode__c> zips = new List<ZipCode__c>();
        Account b = new Account(Name='test2');
        insert b;
        zips.add( new ZipCode__c(
        	name = '11111',
            Branch__c = branch.Id,
            Account__c=b.Id
        ));
        zips.add( new ZipCode__c(
        	name = '12345',
            Branch__c = branch.Id,
            Account__c=b.Id
        ));
        insert zips;
        List<Account> acct = new List<Account>();
        acct.add(new Account(Name='Unknown Utility',Zip__c='65482'));
        acct.add(new Account(Name='Invalid Zip',Zip__c='125'));
        acct.add(new Account(Name='test',Zip__c='11111'));
		acct.add(new Account(Name='test',Zip__c='65982'));
        acct.add(new Account(Name='test',Zip__c='126'));
        acct.add(new Account(Name='test'));
        insert acct;
        acct.remove(0);
        acct.remove(0);
		/*
		Account a2= new Account();
        a2.Name='test1';
        a2.Zip__c='00000';
        insert a2;
        */       
        //Zips[0].Account__c=acct[0].Id;
        update Zips;
        List<DiacoAccountUtilityZipCode.param> params = new List<DiacoAccountUtilityZipCode.param>();
        DiacoAccountUtilityZipCode.param param = new DiacoAccountUtilityZipCode.param();
		/*
        param.Id = a2.Id;
        param.Zip = a2.Zip__c;
        params.add(param);
        */
        System.debug('test1');
        System.debug(b);
        for(Account a : acct){
            System.debug(a);
            param=new DiacoAccountUtilityZipCode.param();
            param.Id = a.Id;
        	param.Zip = a.Zip__c;
            params.add(param);
        }
        test.startTest();
        DiacoAccountUtilityZipCode.utilityZipCode(params);
        test.stopTest();
        
    }
}