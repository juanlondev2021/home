/**
* Diaco
* @author 			<a href = "mailto:crstian.mosquera@globant.com">Cristian Jose Mosquera Puello </a>
* Project:			MyHomeServices
* Description:		Class responsible to manage the UI opereations for the lightning component
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		26/12/20		Cristian Mosquera (CM)		Initial implementation of the class .
**/
public class Diaco_ManageChannelUsersLWCController {

    @AuraEnabled(cacheable = false)
    public static ManageChannelUsersInOutput searchUserByParameters(String inputJson) {
        ManageChannelUsersInOutput channelUsersInput = (ManageChannelUsersInOutput)
                JSON.deserialize(inputJson, ManageChannelUsersInOutput.class);
       ManageChannelUsersInOutput results = new ManageChannelUsersInOutput();
        try {

            String query = 'select id, Name, FirstName, LastName, Username,' +
                    'Installation_Slack_Channel__c, Service_Slack_Channel__c,' +
                    'Slack_Channel__c  from User ';

            String strWhere = '';
            String name = channelUsersInput.user.name;
            String firstName = channelUsersInput.user.firstName;
            String username = channelUsersInput.user.username;
            String lastName = channelUsersInput.user.lastName;
            System.debug('inputJson-->' +inputJson);
            if (((String.isNotBlank(channelUsersInput.user.name) &&
                    channelUsersInput.user.name.length() > 3)
                    || (String.isNotBlank(channelUsersInput.user.firstName) &&
                    channelUsersInput.user.firstName.length() > 3 )
                    || (String.isNotBlank(channelUsersInput.user.username) &&
                    channelUsersInput.user.username.length() > 3 )
                    || (String.isNotBlank(channelUsersInput.user.lastName) &&
                    channelUsersInput.user.lastName.length() > 3 ))) {
                strWhere +=  'where ';
                if (String.isNotBlank(channelUsersInput.user.username)) {
                    username = '%' + username + '%';
                    strWhere += 'Username like :username and ';
                }
                if (String.isNotBlank(channelUsersInput.user.name)) {
                    name = '%' + name + '%';
                    strWhere += 'Name like :name and ';
                }
                if (String.isNotBlank(channelUsersInput.user.firstName)) {
                    firstName = '%' + firstName + '%';
                    strWhere += 'FirstName like :firstName and ';
                }

                if (String.isNotBlank(channelUsersInput.user.lastName)) {
                    lastName = '%' + lastName + '%';
                    strWhere += 'LastName like :lastName and ';
                }

                strWhere = strWhere.removeEnd('and ');
            }
            query += strWhere + ' limit 100';
            List<User> users = Database.query(query);

            diaco__diacoSlackApp__c app = [
                    select Id, name, diaco__tokenApp__c, diaco__byDefault__c
                    from diaco__diacoSlackApp__c
                    where diaco__byDefault__c = true
            ];

            List<diaco__diacoSlackChat__c> channels1 = [
                    select Name, diaco__channelId__c, diaco__Slack_App__c
                    from diaco__diacoSlackChat__c
                    where diaco__Slack_App__c = :app.Id
            ];


            results.channels = channels1;
            results.records = users;
        }
        catch (Exception e) {
            results.responseCode = '500';
            results.message = e.getMessage();
            System.debug('ErrorMessage-->' + results.message);
            System.debug('TracingError-->' + e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
        return results;

    }

    @AuraEnabled(cacheable = false)
    public static ManageChannelUsersInOutput updateUser(String inputJson) {
        ManageChannelUsersInOutput channelUsersInput = new ManageChannelUsersInOutput();
        try {
            channelUsersInput = (ManageChannelUsersInOutput)
                    JSON.deserialize(inputJson, ManageChannelUsersInOutput.class);

            update (channelUsersInput.userToSave);
            return searchUserByParameters(inputJson);
        }
        catch (Exception e) {
            channelUsersInput.responseCode = '500';
            channelUsersInput.message = e.getMessage();
            System.debug('ErrorMessage-->' + channelUsersInput.message);
            System.debug('TracingError-->' + e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
    }

    public virtual class Response {
        @AuraEnabled
        public String message = 'Success';
        @AuraEnabled
        public String responseCode = 'Ok';



    }

    public class ManageChannelUsersInOutput extends Response {
        @AuraEnabled
        public List<User> records = new List<User> ();
        @AuraEnabled
        public List<diaco__diacoSlackChat__c> channels = new List<diaco__diacoSlackChat__c>();
        @AuraEnabled
        public User user = new User();
        @AuraEnabled
        public User userToSave = new User();
    }
}