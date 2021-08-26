public class DiacoTicketComponentController {
    @AuraEnabled
    public static List<Ticket__c> getAllTickets(){
        List<Ticket__c> ts = [select Id, Code__c, Name, Status__c, Name_Assign_To__c, Priority__c, Arrow_To_Show__c, Description__c
                             from Ticket__c
                             order by CreatedDate desc];
        
        return ts;
    }
    
    @AuraEnabled
    public static List<Ticket_Type__c> getAllTicketTypes(){
        List<Ticket_Type__c> ts = [select Id, Name
                                   from Ticket_Type__c
                                   where Active__c = True
                                   order by CreatedDate desc];
        
        return ts;
    }
    
    @AuraEnabled
    public static void deleteAttention(String recordId){
        Attention__c at = new Attention__c();
        at.Id = recordId;
        delete at;
        
    }

    @AuraEnabled
    public static List<Attention__c> getAttentions(String recordId){
        List<Attention__c> ass = [select Id, Name, Description__c, Personnel__r.Name, This_Closed_Ticket__c, Ticket__c
                                 from Attention__c
                                 where Ticket__c =:recordId
                                 order by CreatedDate desc];
        
        return ass;
    }
    
    @AuraEnabled
    public static List<Ticket__c> getAllFilterTickets(List<String> data){
        system.debug(data);
        
        List<Ticket__c> ts;
        
        if(data[4] == ''){
            ts = [select id, Code__c, Name, Status__c, Name_Assign_To__c, Priority__c, Arrow_To_Show__c, Description__c
                  from Ticket__c
                  where Code__c like :data[0] and Name like :data[1] and Name_Assign_To__c like :data[2] and Status__c like :data[3]
                  order by CreatedDate desc];
        }else{
            ts = [select id, Code__c, Name, Status__c, Name_Assign_To__c, Priority__c, Arrow_To_Show__c, Description__c
                  from Ticket__c
                  where Code__c like :data[0] and Name like :data[1] and Name_Assign_To__c like :data[2] and Status__c like :data[3] and Priority__c =:data[4]
                  order by CreatedDate desc];
        }

        return ts;
    }

}