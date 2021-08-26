public with sharing class Settings_page {
    public static void test() {}
   /*public List<settings_page__c> accs { get; set; }
   public settings_page__c AcSiteId{ get; set; }
   public Boolean displayFirstPopUp {get;set;} 
   public Boolean displayPopup {get;set;}
   public settings_page__c NewChat;
    
   //used to get a hold of the account record selected for deletion
   public string SelectedChatId { get; set; }
   //public string SelectedAccountId { get; set; }
   public Settings_page() {
       NewChat = new settings_page__c();
       if(loadChat().size() == 0){
           
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Doesn\'t exist any chat. Please create one!!'));
           showFirstPopup();
       }else{
            //load account data into our DataTable
           LoadData();
           AcSiteId = accs[0]; 
            
       }
      
       
   }
   private void LoadData() {
       accs = [select Name, Chat_id__c, Site_id__c, Chat_App_Token__c, CreatedById from settings_page__c];
   }
    private list<settings_page__c> loadChat() {
       	accs = [select Name, Chat_id__c, Site_id__c, Chat_App_Token__c, CreatedById from settings_page__c];
        return accs;
   }
    
   public settings_page__c getNewChat(){
        return this.NewChat;
    }
    
   public void UpdatesiteId(){
        
        for(settings_page__c chat : accs)
        {
            chat.Site_id__c = this.AcSiteId.Site_id__c;   
        }
        update accs;
       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Side Id Updated!'));
        
   }
    public void saveRecord(){
       
        if(loadChat().size() == 0){
            insert this.NewChat;
            displayFirstPopUp = false;
           
        }else{
            this.NewChat.Site_id__c = AcSiteId.Site_id__c;
            insert this.NewChat;
            displayPopup = false;
            NewChat.Chat_id__c = '';
            NewChat.Chat_App_Token__c = '';
            NewChat.Site_id__c = '';
            NewChat.Name = '';  
        }
		NewChat = new settings_page__c();        
        LoadData();
        AcSiteId = accs[0];
        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'the new chat has been created successfully!');
        ApexPages.addMessage(msg);
        //ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.CONFIRM,'the new chat has been created successfully!'));
    }
    
    
    
   public void DeleteChat(){
      // if for any reason we are missing the reference
      if (SelectedChatId == null) {
         return;
      }
      // find the account record within the collection
      settings_page__c tobeDeleted = null;
      for(settings_page__c a : accs)
       if (a.Id == SelectedChatId) {
          tobeDeleted = a;
          break;
       }
      //if account record found delete it
      if (tobeDeleted != null) {
       Delete tobeDeleted;
      }
      //refresh the data
      LoadData();
       if(loadChat().size() == 0){
           System.debug('se se cumple');
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Doesn\'t exist any chat. Please create one!!'));
           showFirstPopup();
       }
      //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'Record Deleted'));
   }
    
    public void closePopup() {
        this.NewChat.Site_id__c = AcSiteId.Site_id__c;
        NewChat.Chat_id__c = '...';
        NewChat.Chat_App_Token__c = '...';
        NewChat.Name = '...';
        insert this.NewChat;
        displayPopup = false;
        delete this.NewChat;
        this.NewChat =  new settings_page__c();
       
    }
    public void showPopup(){
    	displayPopup = true;
    }
    public void showFirstPopup(){
    	displayFirstPopUp = true;
    }*/
    
}