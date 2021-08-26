@isTest
public class DiacoMyHomeServicesManageControllerTest {
    @isTest static void testAll(){
        
        test.startTest();
        DiacoMyHomeServicesManageController.getHomeServices();
        
        List<String> data = new List<String>{'True,False', 'True,False', 'True,False', 'True,False', ''};
        DiacoMyHomeServicesManageController.getFilterHomeServices(data, Date.today(), null);
        
        test.stopTest();
        
    }
}