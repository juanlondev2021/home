/**
* Diaco
* @author 			<a href = "mailto:crstian.mosquera@globant.com">Cristian Jose Mosquera Puello </a>
* Project:			Appointments
* Description:		Class responsible to execute the unit test for the Class Diaco_ManageChannelUsersLWCController
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		10/01/21		Cristian Mosquera (CM)		Initial implementation of the class .
**/
@IsTest
public class Diaco_ManageChannelUsersLWCControllTest {

    /**
     * Method resposible to test the method searchUserByParameters
     */
    @IsTest
    static void searchUserByParametersTest () {
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

        User u = new User(
                ProfileId = [SELECT Id FROM Profile WHERE Name = 'Chatter External User'].Id,
                LastName = 'last',
                FirstName = 'first',
                Email = 'puser000@amamama.com',
                Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US'


        );

        insert u;
        Test.startTest();
        Diaco_ManageChannelUsersLWCController.ManageChannelUsersInOutput channelUsersInOutput =
                new Diaco_ManageChannelUsersLWCController.ManageChannelUsersInOutput();
        channelUsersInOutput.user = new User(FirstName = 'first');
        Diaco_ManageChannelUsersLWCController.ManageChannelUsersInOutput result =
                Diaco_ManageChannelUsersLWCController.searchUserByParameters
                    (JSON.serialize(channelUsersInOutput));
        System.assert(!result.records.isEmpty());



        channelUsersInOutput =
                new Diaco_ManageChannelUsersLWCController.ManageChannelUsersInOutput();
        channelUsersInOutput.user = new User(LastName = 'last');
        result = Diaco_ManageChannelUsersLWCController.searchUserByParameters
                        (JSON.serialize(channelUsersInOutput));
        System.assert(!result.records.isEmpty());

        channelUsersInOutput =
                new Diaco_ManageChannelUsersLWCController.ManageChannelUsersInOutput();
        channelUsersInOutput.user = new User(Username = 'puser');
        result = Diaco_ManageChannelUsersLWCController.searchUserByParameters
                (JSON.serialize(channelUsersInOutput));
        System.assert(!result.records.isEmpty());
        Test.stopTest();
    }


    /**
    * Method resposible to test the method updateUser
    */
    @IsTest
    static void updateUserTest () {
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

        User u = new User(
                ProfileId = [SELECT Id FROM Profile WHERE Name = 'Chatter External User'].Id,
                LastName = 'last',
                FirstName = 'first',
                Email = 'puser000@amamama.com',
                Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US'


        );

        insert u;
        Test.startTest();
        Diaco_ManageChannelUsersLWCController.ManageChannelUsersInOutput channelUsersInOutput =
                new Diaco_ManageChannelUsersLWCController.ManageChannelUsersInOutput();
        channelUsersInOutput.user = new User(FirstName = 'first');
        Diaco_ManageChannelUsersLWCController.ManageChannelUsersInOutput result =
                Diaco_ManageChannelUsersLWCController.searchUserByParameters
                        (JSON.serialize(channelUsersInOutput));
        System.assert(!result.records.isEmpty());

        User userToUpdate = result.records.get(0);
        userToUpdate.Slack_Channel__c = 'test1';

        userToUpdate.Installation_Slack_Channel__c = 'test2';

        userToUpdate.Service_Slack_Channel__c = 'test3';

        channelUsersInOutput.userToSave = userToUpdate;
        result =
                Diaco_ManageChannelUsersLWCController.updateUser
                        (JSON.serialize(channelUsersInOutput));

        Test.stopTest();
    }
}