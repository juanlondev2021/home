/**
* Diaco
* @author 			Jorge Martinez href=<jorgeality29@gmail.com>
* Project:			Contracts
* Description:		class responsible for handling diacoHSSettings Lightning component.
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		22/05/2019		Jorge Martinez (JM)		Initial implementation of the class.
**/
public class customSettings {
    
    Text_Settings_Appt__c Setting;
    Text_Settings_Appt__c CSetting;
	List<Text_Settings_Appt__c> listsetting;
    public Boolean Confirmed_HA{get; set;}
    public Boolean Confirmed_SO{get; set;}
    public Boolean Confirmed_WA{get; set;}
    public Boolean Confirmed_WI{get; set;}
    public Boolean Set_HA{get; set;}
    public Boolean Set_SO{get; set;}
    public Boolean Set_WA{get; set;}
    public Boolean Set_WI{get; set;}
   
    
    public customSettings(ApexPages.StandardController controller){
        this.Setting = (Text_Settings_Appt__c)controller.getRecord();
		this.listsetting = [select Id, 
                                  Name, 
                                  Appt_Confirmed_HA__c, 
                                  Appt_Confirmed_SO__c, 
                                  Appt_Confirmed_WA__c,
                                  Appt_Confirmed_WI__c,
                                  Appt_Set_HA__c, 
                                  Appt_Set_SO__c, 
                                  Appt_Set_WA__c,
                                  Appt_Set_WI__c
                       		from Text_Settings_Appt__c];
        this.CSetting = listsetting[0]; 
        this.Confirmed_HA = this.CSetting.Appt_Confirmed_HA__c;
        this.Confirmed_SO = this.CSetting.Appt_Confirmed_SO__c;
        this.Confirmed_WA = this.CSetting.Appt_Confirmed_WA__c;
        this.Confirmed_WI = this.CSetting.Appt_Confirmed_WI__c;
        this.Set_HA = this.CSetting.Appt_Set_HA__c;
        this.Set_SO = this.CSetting.Appt_Set_SO__c;
        this.Set_WA = this.CSetting.Appt_Set_WA__c;
        this.Set_Wi = this.CSetting.Appt_Set_WI__c;
        updateSettings();
        
       
    }
    
    
    public Text_Settings_Appt__c getcustomsetting(){
        return this.Setting;
    }
    
    @AuraEnabled
    public static Text_Settings_Appt__c getRecordId(){
        Text_Settings_Appt__c sett = [select Id, Sale_Confirmation_Text_Home_Automation__c, Sale_Confirmation_Text_Pest_Control__c, Sale_Confirmation_Text_Solar__c, 
                                      Sale_Confirmation_Text_Water__c, Sale_Confirmation_Text_Window__c, Sale_New_Appointment_Home_Automation__c, Sale_New_Appointment_Pest_Control__c,
                                      Sale_New_Appointment_Solar__c, Sale_New_Appointment_Water__c, Sale_New_Appointment_Window__c, Sale_In_Transit_Home_Automation__c, 
                                      Sale_In_Transit_Pest_Control__c, Sale_In_Transit_Solar__c, Sale_In_Transit_Water__c, Sale_In_Transit_Window__c,
                                      Installation_Confirmation_Text_Home_A__c, Installation_Confirmation_Text_Pest_C__c, Installation_Confirmation_Text_Solar__c,
                                      Installation_Confirmation_Text_Water__c, Installation_Confirmation_Text_Window__c, Installation_New_Appointment_Home_Aut__c,
                                      Installation_New_Appointment_Pest_Con__c, Installation_New_Appointment_Solar__c, Installation_New_Appointment_Water__c,
                                      Installation_New_Appointment_Window__c, Installation_In_Transit_Home_Automati__c, Installation_In_Transit_Pest_Control__c,
                                      Installation_In_Transit_Solar__c, Installation_In_Transit_Water__c, Installation_In_Transit_Window__c, Sale_Confirmation_C_Home_Automation__c,
                                      Sale_Confirmation_C_Pest_Control__c, Sale_Confirmation_C_Solar__c, Sale_Confirmation_C_Water__c, Sale_Confirmation_C_Window__c,
                                      Sales_Review_Rep_HA__c, Sales_Review_Rep_Pest_Control__c, Sales_Review_Rep_SO__c, Sales_Review_Rep_WA__c, Sales_Review_Rep_WI__c,
                                      Instatllation_Review_Rep_HA__c, Instatllation_Review_Rep_Pest_Control__c, Instatllation_Review_Rep_SO__c, Instatllation_Review_Rep_WA__c,
                                      Instatllation_Review_Rep_WI__c
                                      from Text_Settings_Appt__c LIMIT 1];
        
        return sett;
    }
    
	@AuraEnabled
    public static Text_Settings_Appt__c  SaveInformation(Text_Settings_Appt__c custom){
        upsert custom;
        return custom;
    }

    public void updateSettings(){
        this.Setting.Id =  this.CSetting.Id;
        this.Setting.Name = this.CSetting.Name;
        this.Setting.Appt_Confirmed_HA__c = this.Confirmed_HA;
        this.Setting.Appt_Confirmed_SO__c = this.Confirmed_SO;
        this.Setting.Appt_Confirmed_WA__c = this.Confirmed_WA;
        this.Setting.Appt_Confirmed_WI__c = this.Confirmed_WI;
        this.Setting.Appt_Set_HA__c = this.Set_HA;
        this.Setting.Appt_Set_SO__c = this.Set_SO;
        this.Setting.Appt_Set_WA__c = this.Set_WA;
        this.Setting.Appt_Set_WI__c = this.Set_WI;
    }
    
   
    public void updateCSettings(){
        this.CSetting.Appt_Confirmed_HA__c = this.Setting.Appt_Confirmed_HA__c;
        this.CSetting.Appt_Confirmed_SO__c = this.Setting.Appt_Confirmed_SO__c;
        this.CSetting.Appt_Confirmed_WA__c = this.Setting.Appt_Confirmed_WA__c;
        this.CSetting.Appt_Confirmed_WI__c = this.Setting.Appt_Confirmed_WI__c;
        this.CSetting.Appt_Set_HA__c = this.Setting.Appt_Set_HA__c;
        this.CSetting.Appt_Set_SO__c = this.Setting.Appt_Set_SO__c;
        this.CSetting.Appt_Set_WA__c = this.Setting.Appt_Set_WA__c;
        this.CSetting.Appt_Set_WI__c = this.Setting.Appt_Set_WI__c;
    }
    
    
    
    
    public PageReference test() {
        updateSettings();
        updateCSettings();
        Database.update(this.CSetting);
        return null;
    }
    

}