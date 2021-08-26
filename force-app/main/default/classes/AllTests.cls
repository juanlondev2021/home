@isTest
private class AllTests {
    
    // Test all triggers
    //
    static testMethod void validateTriggers() {
        Settings_page.test();
        SendMessageToStride.test();
        /*
        // Create test data
        //
        TestData.CreateHardwareCatalog();
        TestData.CreateServiceCatalog();
        TestData.CreateDefaultServices();
        
        // Create IT Requests
        //
        TestData.CreateItRequests();
        
        // Create IT_HardwareRequest__c and IT_ServiceRequest__c records
        // This causes the triggers to execute.
        TestData.AssignHardwareSoftware();
        */
        
    }
    
    static testMethod void validateVfPages() {
        /*
        // Create test data
        //
        TestData.CreateHardwareCatalog();
        TestData.CreateHardwareCatalog();
        TestData.CreateServiceCatalog();
        TestData.CreateDefaultServices();
        TestData.CreateItRequests();
        
        // Get IT_Request
        //
        IT_Request__c itr = [Select i.Status__c, i.Name, i.Id From IT_Request__c i where Name = 'Test request 0' LIMIT 1];
        IT_Hardware_Catalog__c itrhw = [Select i.Name, i.Id From IT_Hardware_Catalog__c i where Name = 'Test Hardware 1' LIMIT 1];
        IT_Service_Catalog__c itrsv = [Select i.Name, i.Id From IT_Service_Catalog__c i where Name = 'Test Service 1' LIMIT 1];
        
        // Instanciate Page
        //
        PageReference ItrPage = Page.ITRequestAdvancedEdit;
        Test.setCurrentPage(ItrPage);
        ApexPages.currentPage().getParameters().put('id', itr.id);

        //Instanciate IT_Hardware_Request__c list
        //
        ITRequestHardware rhController = new ITRequestHardware();
        String rhId = rhController.getRequestId();      
        IT_Hardware_Request__c[] ihrList = rhController.getHardwareGridData();
        rhController.getHardwareStatusText();
        
        String rhInsertFlag = rhController.getHardwareInsertFlag();
        PageReference addHwPage = rhController.addHardwareRequest();
        rhInsertFlag = rhController.getHardwareInsertFlag();
        PageReference cancelHwPage = rhController.CancelHardwareRequest();
        
        addHwPage = rhController.addHardwareRequest();
        ihrList = rhController.getHardwareGridData();
        ihrList[ihrList.size()-1].IT_Hardware__c = itrhw.id;
        rhController.setHardwareGridData(ihrList);
        PageReference saveHwPage = rhController.saveHardwareRequest();

        //Instanciate IT_Service_Request__c list
        //
        ITRequestServices rsController = new ITRequestServices();
        String rsId = rsController.getRequestId();
        IT_Service_Request__c[] isrList = rsController.getServiceGridData();
        rsController.getServiceStatusText();
        
        String rsInsertFlag = rsController.getServiceInsertFlag();
        PageReference addSvPage = rsController.addServiceRequest();
        rsInsertFlag = rsController.getServiceInsertFlag();
        PageReference cancelSvPage = rsController.CancelServiceRequest();
        
        addSvPage = rsController.addServiceRequest();
        isrList = rsController.getServiceGridData();
        isrList[isrList.size()-1].IT_Service__c = itrsv.id;
        rsController.setServiceGridData(isrList);
        PageReference saveSvPage = rsController.saveServiceRequest();
                    */
    }
    
}