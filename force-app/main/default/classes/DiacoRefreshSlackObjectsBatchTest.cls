/**
* Diaco
* @author 			<a href = "mailto:crstian.mosquera@globant.com">Cristian Jose Mosquera Puello </a>
* Project:			MyHomeService
* Description:		Class responsible to execute the unit test for the Class DiacoRefreshSlackObjectsBatch
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		15/12/20		Cristian Mosquera (CM)		Initial implementation of the class .
**/
@IsTest
public class DiacoRefreshSlackObjectsBatchTest {



    @IsTest
    static void testExecute () {
        diaco__diacoSlackApp__c app1 = new diaco__diacoSlackApp__c(
                Name = 'test1',
                diaco__tokenApp__c = 'xoxa-408782345031-419122738544-419859988770-6b6f61c477d9067446e812035c7d14ac',
                diaco__byDefault__c = true);

        insert app1;
        diaco__diacoSlackChat__c channelsapp = new diaco__diacoSlackChat__c(
                Name = 'testChannel',
                diaco__channelId__c = 'CBZMYR96D',
                diaco__Slack_App__c = app1.Id,
                diaco__members__c = 'UBZMYR69G,UBZMYR69G'
        );
        insert channelsapp;
        diaco__diacoSlackUser__c slackUser = new diaco__diacoSlackUser__c(
                name = 'test',
                diaco__slackUserId__c = 'UBZMYR69D',
                diaco__Slack_App__c = app1.Id
        );
        insert slackUser;
        Test.startTest();
        List<diaco__diacoSlackApp__c> app = [select Id, Name, diaco__tokenApp__c, diaco__byDefault__c
        from diaco__diacoSlackApp__c
        where diaco__byDefault__c = true];
        System.assertEquals(1, app.size());

        list<diaco__diacoSlackChat__c> ChannelsInDataBase = [select Id, Name, diaco__channelId__c, diaco__members__c, diaco__members_number__c from diaco__diacoSlackChat__c where diaco__Slack_App__c = :app[0].Id];
        System.assertEquals(1, ChannelsInDataBase.size());
        System.debug('response -->' + diaco.diacoHttpRequestsToSlack.slackGetChannels('').getBody());
        System.assert(!diaco.diacoSlackCmpController.requestNewChannels().isEmpty());
        DiacoRefreshSlackObjectsBatch batch = new DiacoRefreshSlackObjectsBatch();
        batch.execute(null);
        Test.stopTest();
    }


}