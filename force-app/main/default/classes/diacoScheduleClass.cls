/**
* Diaco
* @author 			Jorge Martinez href=<jorgeality29@gmail.com>
* Project:			SalesRabbit Integration
* Description:		this class together with diacoScheduleClass are in charge for updating data each time a request is made to salesrabbit and delete lead from salesrabbit.
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		18/08/2018		Jorge Martinez (JM)		Initial implementation of the trigger.
**/
global class diacoScheduleClass implements Schedulable {
   global void execute(SchedulableContext SC) {
      diacoRequestSalesRabbitToUpdateInSF schedule = new diacoRequestSalesRabbitToUpdateInSF(); 
   }
}