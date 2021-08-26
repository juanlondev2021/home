public virtual class DiacoSmsConsumerTest {

    public static void setup() {
        StreamingChannel ch = new StreamingChannel(Name = '/u/diaco-sms');
        insert ch;
        dsms__Phone_Number__c ph = new dsms__Phone_Number__c();
        ph.dsms__Phone_Number__c = '+1000';
        ph.Name = 'TestLongcode';
        ph.dsms__Country_Code__c='+1';
        insert ph;
        dsms__Phone_Number__c ph2 = new dsms__Phone_Number__c();
        ph2.dsms__Phone_Number__c = '+10001';
        ph2.Name = 'TestLongcode';
        ph2.dsms__Country_Code__c='+1';
        insert ph2;
        dsms__channel__c chan = new dsms__channel__c(
            dsms__Channel_Name__c = ch.Name,
            name = Ph.dsms__Phone_Number__c+' - +17608580583', 
            dsms__From__c = Ph.Id, 
            dsms__To__c = 'ada',
            dsms__ChannelId__c = ch.Id,
            dsms__isBlock__c=True
        );
        insert chan;
    }   
}