/* --------------------------
 * Created By : MST Solutions
 * Created Date : 
 * Description : This test class created for nuHome_Multiple_ZipCodes_AC apex class.

* Modified By: Ganesh
 * Modified on:
 * Description: This test class covers nuHome_Multiple_ZipCodes_AC class.
 				Updated the test class as per best practices. 
-----------------------------
*/
@isTest(seealldata=false)
private class nuHome_Multiple_ZipCodes_AC_Test {
    @testsetup static void createtestdata(){
        //insert Product2 record
        Product2 prod = new Product2(Name = 'AL-Birmingham-Garage Doors', 
                                     ProductCode = 'CPL-1000-322',
                                     Available_ZipCodes__c = '35005;35006;35051;35061;35062;35063;35064;35068;35071;35073;',
                                     Exclude_Zip_Codes__c='35080;35085;35091;');
        insert prod;
        system.assertNotEquals(null, prod);
    }
    static testmethod void updateprod(){
        
        product2 prod = [select id,Name,ProductCode,Available_ZipCodes__c,Exclude_Zip_Codes__c from product2 where ProductCode = 'CPL-1000-322' limit 1];
        Test.startTest();
        nuHome_Multiple_ZipCodes_AC zipCodes = new nuHome_Multiple_ZipCodes_AC(new ApexPages.StandardController(prod));
        zipCodes.getunSelectedValues();
        zipCodes.getSelectedValues();
        zipCodes.editZip();
        zipCodes.leftSelected.add('35080');
        zipCodes.selectClick();
        zipCodes.rightSelected.add('35080');
        zipCodes.unSelectClick();
        zipCodes.saveZip();
        Test.stopTest();
    }
}