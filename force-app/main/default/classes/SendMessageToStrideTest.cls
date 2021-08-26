@isTest
public class SendMessageToStrideTest {
    /*
    @isTest static void testPostCallout() {
        
        testPostCallout3();
        // Set mock callout class 
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SettingHttpCalloutMock()); 
        
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock.       chat id : c8438aef-4dbc-4f8f-9e02-f991dbb52138
        HttpResponse response = SendMessageToStride.StrideCallout('test1','This is a Salesforce test @all');
        // Verify that the response received contains fake values
        String contentType = response.getHeader('Content-Type');
        System.assert(contentType == 'text/plain');
        String actualValue = response.getBody();
        System.debug('body response : '+response.getBody());
        //                             
        String expectedValue = '{"id": "32e2be66-7499-4188-83d5-757e3586fc20","timestamp": "2017-09-08T23:11:05Z 812195"}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, response.getStatusCode());
        Test.stopTest();
  }
    @isTest static void testPostCallout3() {
        
        // Set mock callout class 
        
        settings_page__c v =  new settings_page__c();
        v.Name = 'test1';
        v.Chat_App_Token__c = 'ZCHNo7WBTfcCSfrgD2a9';
        v.Site_id__c = '67c76118-6b02-4b27-af6f-86ce6f685344';
        v.Chat_id__c = '1fa8263c-e543-445a-9542-2a387c44f685';
        Database.insert(v);
        
  }
    @isTest static void testPostCallout2() {
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new SettingHttpCalloutMock()); 
        settings_page__c v =  new settings_page__c();
        v.Name = 'test1';
        v.Chat_App_Token__c = 'ZCHNo7WBTfcCSfrgD2a9';
        v.Site_id__c = '67c76118-6b02-4b27-af6f-86ce6f685344';
        v.Chat_id__c = '1fa8263c-e543-445a-9542-2a387c44f685';
        Database.insert(v);
        SendMessageToStride.StrideMessage('test1','This is a Salesforce test @all');
  }*/


}