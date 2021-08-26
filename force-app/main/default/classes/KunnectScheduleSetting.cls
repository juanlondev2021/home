/**
 * Diaco
 * @author             Jull Quintero Daza
 * Project:            kunnect Integrations
 * Testclass           KunnectScheduleSettingTest
 * Description:        DTO Setting Shedule
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version    1.0    12/04/2021         Jull Quintero D         Initial implementation of the class.
 **/

public class KunnectScheduleSetting {
    public static final List<String> ZIPCODES = new List<String>{
        '85006','85007','85008','85009','85012','85014','85020','85022','85023','85024','85027','85028','85029','85032','85034','85050','85053','85054','85083','85085','85086','85087','85225','85253','85254','85255','85258','85259','85260','85262','85266','85301','85307','85308','85309','85310','85323','85326','85331','85335','85337','85338','85340','85345','85351','85354','85355','85361','85363','85373','85374','85375','85379','85382','85383','85387','85395','85396'};
    public static final List<String> SOURCETABLES = new List<String>{
        'source_contact_01_security','source_contact_01_water','source_contact_windows_and_blinds','source_contact_pest_control','source_contact_hvac','source_contact_solar','source_contact_srp_solar'};
    public static final List<String> GRAVELTABLES = new List<String>{
        'gravel_contact_security','gravel_contact_water','gravel_contact_remodel','gravel_contact_hvac','gravel_contact_pest_control','gravel_contact_solar'};
    public string name;
    public integer recordSize;
    public Boolean newUserAddress;
    public Datetime nextRun;
    public integer start;
    public integer currentUserAddreSize;
    private List<User_Address__c> records;

    public Map<String,String> emailReport = new Map<String,String>();

    /**
    * @author Jull Quintero | 9/04/2021 
    * @description: Outbound - Get user address, SOQL for Gravel and Proteccion source
    **/
    public List<User_Address__c> getOutboundSourceUserAddress() {
        if( this.newUserAddress ) {
            this.records = [
                SELECT Id,
                Kunnect_Sync__c,
                fFirstName__c, 
                fLastName__c,
                Phone__c, 
                Email__c, 
                Confirmation_Number__c, 
                Recording_Date__c, 
                Respond_Date__c,  
                Sales_Price__c,
                Address__r.Street__c,  
                Address__r.City__c, 
                Address__r.State__c, 
                Address__r.Zip_Code__c 
                FROM User_Address__c 
                WHERE Phone__c != '' AND Respond_Date__c = YESTERDAY AND Verbal_Consent__c='Yes' AND 
                Kunnect_Sync__c EXCLUDES(:String.join(SOURCETABLES, ';')) 
                ];
                this.currentUserAddreSize = this.records.size();
                this.start = 0;
        }
        return records;
    }

        /**
    * @author Jull Quintero | 9/04/2021 
    * @description: Outbound - Get user address, SOQL for Gravel and Proteccion source
    **/
    public List<User_Address__c> getOutboundGravelUserAddress() {
        if( this.newUserAddress ) {
            this.records = [
                SELECT Id,
                Kunnect_Sync__c,
                fFirstName__c, 
                fLastName__c,
                Phone__c, 
                Email__c, 
                Confirmation_Number__c, 
                Recording_Date__c, 
                Respond_Date__c,  
                Sales_Price__c,
                Address__r.Street__c,  
                Address__r.City__c, 
                Address__r.State__c, 
                Address__r.Zip_Code__c 
                FROM User_Address__c 
                WHERE Phone__c != '' AND Respond_Date__c = YESTERDAY AND Verbal_Consent__c='Yes' AND 
                Kunnect_Sync__c EXCLUDES(:String.join(GRAVELTABLES, ';')) 
                ];
                this.currentUserAddreSize = this.records.size();
                this.start = 0;
        }
        return records;
    }


    /**
    * @author Jull Quintero | 9/04/2021 
    * @description: Inbound - Get user address
    **/
    public List<User_Address__c> getInboundUserAddress() {
        if( this.newUserAddress ) {
            this.records = [
                SELECT 
                Email__c,
                Recording_Date__c,
                Sale_Date__c,
                External_ID__c, 
                Confirmation_Number__c, 
                Phone__c, 
                Sales_Price__c, 
                fFirstName__c, 
                fLastName__c,
                Address__r.Name,
                Address__r.City__c, 
                Address__r.State__c, 
                Address__r.Street__c, 
                Address__r.Zip_Code__c,
                Kunnect_Sync__c
                FROM User_Address__c 
                WHERE CreatedDate = TODAY AND
                Kunnect_Sync__c EXCLUDES('contact_metro_inbound')];
                this.currentUserAddreSize = this.records.size();
                this.start = 0;
        }
        return records;
    }

    /**
    * @author Jull Quintero | 27/04/2021 
    * @description: set nextRun param
    **/
    public Boolean sendEmail(integer start) {
        Boolean sendEmail = false;
        this.start = start;
        if( this.start >= this.currentUserAddreSize ) {
            this.newUserAddress = true;
            integer year  =System.Date.today().year();
            integer month = System.Date.today().month();
            integer day  = System.Date.today().day() + 1;
            if ( this.name == 'inboundUserAddress' ) {
                this.nextRun = System.now().addMinutes(35);
            }else if ( this.name == 'outboundGravel' ) {
                DateTime dTime = DateTime.newInstance(year, month, day, 2, 50, 0);
                this.nextRun = dTime;
            }else if(this.name == 'outboundSource') {
                DateTime dTime = DateTime.newInstance(year, month, day, 2, 20, 0);
                this.nextRun = dTime;
            }
            this.emailReport.clear();
            sendEmail = true;
        }
        return sendEmail;
    }
    /**
    * @author Jull Quintero | 9/04/2021 
    * @description: parse Json to KunnectScheduleSetting object
    * @param json(String) 
    **/
    public static KunnectScheduleSetting parse(String json) { 
        return (KunnectScheduleSetting)System.JSON.deserialize(json, KunnectScheduleSetting.class);
    }

    /**
    * @author Jull Quintero | 9/04/2021 
    * @description: parse Json to KunnectScheduleSetting object
    * @param obj(KunnectScheduleSetting) 
    **/
    public static String createJson(KunnectScheduleSetting obj) {            
        return (String) System.JSON.serialize(obj);
    } 

}