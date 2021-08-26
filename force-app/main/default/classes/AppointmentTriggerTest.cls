@isTest
public class AppointmentTriggerTest {
	@isTest
    static void testA(){
        List<Appointment_RecordType_mtd__c> res = new List<Appointment_RecordType_mtd__c>();
        List<String> Rtypes = new List<String>{ 'Home Automation','Water Filtration','Solar',
            									'Pest Control','Kitchen Remodel'};
        List<String> HRtypes = new List<String>{'Home Automation Sales','Water Treatment Sales',
            									'Solar Sales','Pest Control Sales','Remodel Sales'};
        Account ac = new Account(Name='test Acc');
        Account ac3 = new Account(Name='test Acc3');
        Account ac2 = new Account(Name='My Home Services LLC');
        insert ac2;
        ac.ParentId=ac2.Id;
        insert ac;
        ac3.Pool__c='Yes';
        insert ac3;
        
        List<Appointment__c> app = new List<Appointment__c>();
        for(Integer i=0 ; i<4; i++){
            Id TypeId = Schema.SObjectType.Appointment__c.getRecordTypeInfosByName().get(Rtypes[i]).getRecordTypeId();
            Id HTypeId = Schema.SObjectType.Home_Services__c.getRecordTypeInfosByName().get(HRtypes[i]).getRecordTypeId();
            res.add(new Appointment_RecordType_mtd__c(Name = TypeId, RT_Home_Service_Id__c = HTypeId, PartnerId__c = ac.Id));
        }
        insert res;
        for(String s: Rtypes){
            Id EventRecordTypeId = Schema.SObjectType.Appointment__c.getRecordTypeInfosByName().get(s).getRecordTypeId();
            Appointment__c a = new Appointment__c(Name=s);
            a.recordTypeId                    = EventRecordTypeId;
            a.Number_of_People_in_the_home__c = 12;
            a.Person_Account__c               = ac3.Id;
            a.Appointment_Start_Time__c       = Datetime.now();
            a.Appointment_End_Time__c         = Datetime.now().addMinutes(30);
            app.add(a);
        }
		//app[0].Account_Pool__c = 'Yes';
        app[0].Pool__c                       = true;
        app[0].Number_of_Stories_Picklist__c = '2';
        app[2].Pool__c                       = true;
        app[2].Project_Type__c               = 'Solar';
        app[3].Project_Type__c               = 'Solar';
        app[3].Pets__c                       = 'Dog(s)';
        Test.startTest();
        insert app;
        Test.stopTest();
    }
}