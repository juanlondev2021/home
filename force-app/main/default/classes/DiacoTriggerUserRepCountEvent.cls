/*Diaco
@author 			Álvaro José Ortega Vargas href=<aoargassf@gmail.com>
Project:			DiacoTriggerUserRepCountEvent
Description:		Event counter, re calculate for the user the total of event  es[i].Current_Status__c=='Closed Won' and the total events, if it has a personnel related object, it will do the same

Changes (Version)
_________________________________________

No.		Date			Author					Description
____	__________      __________________      _____________________________________
@version	1.0		05/04/2019		Álvaro Ortega (AO)	    User Event counter.
@version	2.0		24/06/2019		John Hernandez (AO)	    New version for better performance using Aggregate Soql and now processing all records at once.*/
public class DiacoTriggerUserRepCountEvent {

    public static void executeV2 (set<ID> usersId){
        system.debug('-----V2----------');
        Map<ID,User> users = New Map<ID,User>([ Select Id,Personnel__c From User WHERE Id IN :usersId]);//New list of users to get personnel field
        if(users.size()>0){
            Date actualDate=date.today();
            DateTime toDate=actualDate.toStartOfWeek();
            toDate=toDate.addHours(7); //It's in weeks so it will be updated every week
            DateTime fromDate=toDate.addDays(-84);  //84 days same 12 weeks
            
            list<AggregateResult> totalEventsAggregated=[SELECT COUNT(id) total,OwnerId FROM Event 
                                                         WHERE OwnerId IN :usersId and Current_Appointment__c=True
                                                         and CreatedDate>=:fromDate and CreatedDate<=:toDate 
                                                         GROUP BY OwnerId];//Query for getting all users with the total of appointments       
            
            list<AggregateResult> totalEventsClosedWonAggregated=[SELECT COUNT(id) total,OwnerId FROM Event 
                                                                  WHERE OwnerId IN :usersId and Current_Appointment__c=True
                                                                  and CreatedDate>=:fromDate and CreatedDate<=:toDate 
                                                                  and Current_Status__c='Closed Won'
                                                                  GROUP BY OwnerId];//Query for getting all users with the total of appointments  closed won
            
            Map<ID,Integer> mapUserTotalEvent=getUserEventMap(usersId,totalEventsAggregated);
            Map<ID,Integer> mapUserTotalEventClosedWon=getUserEventMap(usersId,totalEventsClosedWonAggregated);
            List<User> usersToUpdate= NEW List<User>();
            List<Personnel__c> personnelsToUpdate = NEW List<Personnel__c>();
            
            for(ID userI:usersId){
                User currentUser=users.get(userI);
                User newUser= NEW User();
                newUser.Id=userI;
                newUser.Total_Of_Event__c=mapUserTotalEvent.get(userI);
                newUser.Event_Sales_Approved__c=mapUserTotalEventClosedWon.get(userI);
                usersToUpdate.add(newUser);
                //                system.debug(mapUserTotalEvent.get(userI));
                if(currentUser.Personnel__c!=null && currentUser.Personnel__c!=''){
                    Personnel__c p=new Personnel__c();
                    p.Id=currentUser.Personnel__c;
                    p.Total_Of_Event__c=mapUserTotalEvent.get(userI);
                    p.Event_Sales_Approved__c=mapUserTotalEventClosedWon.get(userI);
                    personnelsToUpdate.add(p); 
                }
            }
            try{
               
            update personnelsToUpdate;
            update usersToUpdate; 
            }catch(Exception e) {
                System.debug('An exception occurred: ' + e.getMessage());
                
            }
            
        }
        
    }
    //This method will organize for each user his proper total of event and events with status closed won. using the Aggregate queries used before, if it's not in the query its value will be 0;
    public static Map<ID,Integer> getUserEventMap (set<ID> usersId,list<AggregateResult> aggregateList){
        Map<ID,Integer> listID_Total=New Map<ID,Integer>();
        for(ID userId:usersId){
            Integer total=0;
            for(AggregateResult result:aggregateList){
                if(String.valueOf(result.get('OwnerId')) ==userId){
                    total= Integer.valueOf(result.get('total'));
                }
            }
            listID_Total.put(userId,total);
            
        }
        
        return listID_Total;
    }
}