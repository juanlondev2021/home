public class businessAccountClass {
    public Account controller;
    public Contact Contacts{get; set;}
    public List<Contact> ListContacts{get; set;}
    public List<Event> ListEvents{get; set;}
    public Event Appoint{get;set;}
    public string SelectedChatId { get; set; }
    public string month { get; set; }
    public string day { get; set; }
    public string year { get; set; }
    public string hour { get; set; }
    
    public businessAccountClass(ApexPages.StandardController controller){
        this.controller = (Account)controller.getRecord();
        
        Contacts = new Contact();
        Appoint = new Event();
        Appoint.WhatId = this.controller.Id;
        loadData();
        loadDataEvent();
    }


    public void loadData(){
        ListContacts = [select id, Name, Phone, MobilePhone, Email 
                        from Contact 
                        where AccountId =:this.controller.Id];
    }  
    public void loadDataEvent(){
        ListEvents = [select id, Subject, StartDateTime, EndDateTime, IsAllDayEvent, WhoId, WhatId, OwnerId, Location 
                        from Event 
                        where WhatId =:this.controller.Id];
    }   
    
    public void SaveContact(){
        Contacts.AccountId = this.controller.Id;
        insert Contacts;
        loadData();
        Contacts = new Contact();

    }
    public List<SelectOption> getItems() {
            List<SelectOption> options = new List<SelectOption>();
        	String [] months =new String[]{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'};
            Integer i = 1;    
            for(String m : months){
                options.add(new SelectOption(i+'',m));
                i++;
            }
            
            return options;
     }
    public List<SelectOption> getDays() {
            List<SelectOption> options = new List<SelectOption>();
            for(Integer i = 1; i < 32 ; i++ ){
                    options.add(new SelectOption(i+'',i+''));
            }
            
            return options;
     }
    public List<SelectOption> getHours() {
            List<SelectOption> options = new List<SelectOption>();
        	String [] hour =new String[]{'00','30'};
            for(Integer i = 8; i < 23 ; i++ ){
                for(String h : hour){
                    options.add(new SelectOption(i+':'+h,i+':'+h));
                }
            }
            
            return options;
     }

    public void SaveEvent(){
        Appoint.WhatId = this.controller.Id;
        List<String> res = hour.split(':');
        Appoint.StartDateTime = DateTime.newInstance(integer.valueof(year), integer.valueof(month), integer.valueof(day), integer.valueof(res[0]), integer.valueof(res[1]), 0);
        Appoint.EndDateTime = Appoint.StartDateTime.addHours(1);
        insert Appoint;
        loadDataEvent();
        Appoint = new Event();
        
       
        
    }
    public void DeleteContact(){
      // if for any reason we are missing the reference
      if (SelectedChatId == null) {
         return;
      }
      // find the account record within the collection
      Contact tobeDeleted = null;
      for(Contact a : ListContacts)
       if (a.Id == SelectedChatId) {
          tobeDeleted = a;
          break;
       }
      //if account record found delete it
      if (tobeDeleted != null) {
       Delete tobeDeleted;
      }
        loadData();
      //refresh the data
      
   }
    
    
    
    
}