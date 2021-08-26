public  class UpdateHsAppointmentApproved  implements Queueable {
    private List<Home_Services__c> myHomeS;
    
    public UpdateHsAppointmentApproved(List<Home_Services__c> records) {
        this.myHomeS = records;
    }
    
    public void execute(QueueableContext context) {
        
        List<Appointment__c> appomts = new List<Appointment__c>();
        List<Home_Services__c> homeServices = new List<Home_Services__c>();
        integer myHomesLength = myHomeS.size();
        for (Integer i = 0; i < myHomesLength; i++) 
        {
            Home_Services__c hs = myHomeS[i];
            if( hs.Appt_Sale_Status__c == 'Sale Approved' ) {
                if( hs.Appointment_Lookup__c != null ) {
                    appomts.add( 
                        new Appointment__c(
                            id = hs.Appointment_Lookup__c,
                            Status__c = 'Sale Approved'
                    ));
                }else {
                    Appointment_RecordType_mtd__c homeServiceRtype = Appointment_RecordType_mtd__c.getValues(hs.RecordTypeId);
                    if( homeServiceRtype != null ) {
                        appomts.add(
                            new Appointment__c(
                                RecordTypeId = homeServiceRtype.RT_Appointment_Id__c,
                                assigned__c = true,
                                Person_Account__c = hs.Account__c,
                                Home_Service__c = hs.Id,
                                Status__c = 'Sale Approved',
                                Lead_Source__c = 'Automation'
                            )
                        );
                    }
                }
            }
        }
        if ( !appomts.isEmpty() ) {
            upsert appomts;

            integer appomtsLength = appomts.size();
            for (Integer i = 0; i < appomtsLength; i++) 
            {
                Appointment__c appmt = appomts[i];
                if( appmt.Lead_Source__c == 'Automation' ) {
                    homeServices.add(
                        new Home_Services__c(
                            Id = appmt.Home_Service__c,
                            Appointment_Lookup__c = appmt.Id,
                            query__c = true
                        )
                    );
                }
            }
            update homeServices;
        }    
    }
    
}