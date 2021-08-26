/**
* Diaco
* @author 			<a href = "mailto:crstian.mosquera@globant.com">Cristian Jose Mosquera Puello </a>
* Project:			MyHomeService
* Description:		Class responsible to execute batch for refresh slack objects automatically.
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		15/12/20		Cristian Mosquera (CM)		Initial implementation of the class .
**/
global class DiacoRefreshSlackObjectsBatch implements Schedulable, Database.AllowsCallouts {

    /**
     * @see Database.Schedulable.execute(Database.SchedulableContext)
     */
    global void execute(SchedulableContext param1) {

        DiacoRefreshSlackObjectsBatch.executeFuture();
        //System.schedule('ScheduledApexTest',CRON_EXP,  new DiacoRefreshSlackObjectsBatch());
    }

    @Future (Callout = true)
    global static void executeFuture () {
        List<diaco__diacoSlackChat__c> diacoSlackChats =
                diaco.diacoSlackCmpController.requestNewChannels();
        List<diaco__diacoSlackUser__c> diacoSlackUsers =
                diaco.diacoSlackCmpController.requestNewUsers();
        if(!diacoSlackChats.isEmpty()) {
            diaco.diacoSlackCmpController.SaveNewChannels(diacoSlackChats);
        }

        if(!diacoSlackUsers.isEmpty()) {
            diaco.diacoSlackCmpController.saveNewUsers(diacoSlackUsers);
        }
    }
}