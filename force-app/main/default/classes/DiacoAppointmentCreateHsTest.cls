@isTest
public class DiacoAppointmentCreateHsTest {
     
    @isTest
    public static void test(){
        
        List<Appointment_RecordType_mtd__c> res = new List<Appointment_RecordType_mtd__c>();
        List<String> Rtypes = new List<String>{'Home Automation','Water Filtration','Solar','Pest Control','Kitchen Remodel'};
        List<String> HRtypes = new List<String>{'Home Automation Sales','Water Treatment Sales','Solar Sales','Pest Control Sales','Remodel Sales'};
        Account ac = new Account(Name='test Acc');
        insert ac;
        List<Appointment__c> apps = new  List<Appointment__c>();
        for(Integer i=0 ; i<4; i++){
            Id TypeId = Schema.SObjectType.Appointment__c.getRecordTypeInfosByName().get(Rtypes[i]).getRecordTypeId();
            Id HTypeId = Schema.SObjectType.Home_Services__c.getRecordTypeInfosByName().get(HRtypes[i]).getRecordTypeId();
            res.add(new Appointment_RecordType_mtd__c(Name=TypeId,RT_Home_Service_Id__c=HTypeId));
        }
        insert res;
        for(String s: Rtypes){
            Id EventRecordTypeId = Schema.SObjectType.Appointment__c.getRecordTypeInfosByName().get(s).getRecordTypeId();
            Appointment__c a = new Appointment__c(Name='test Appointment');
            a.recordTypeId=EventRecordTypeId;
            a.Number_of_People_in_the_home__c=12;
            a.Person_Account__c=ac.Id;
            a.Appointment_Start_Time__c=Datetime.now();
            a.Appointment_End_Time__c=Datetime.now().addMinutes(30);
            apps.add(a);
        }
        apps[0].Pool__c=true;
        apps[0].Number_of_Stories_Picklist__c='2';
        apps[2].Pool__c=true;
        apps[2].Project_Type__c='Solar';
        apps[3].Project_Type__c='Solar';
        apps[3].Pets__c='Dog(s)';
        insert apps;
        Test.startTest();
        DiacoAppointmentCreateHs.createHs(apps);
        Test.stopTest();
    }
}