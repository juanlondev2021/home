@isTest
global class DiacoSendEmailReviewHttpCallOutMock implements HttpCalloutMock{
	global HTTPResponse respond(HTTPRequest req) {
        HttpResponse response = new HttpResponse();
        String body = '';
        if(req.getEndpoint() == 'https://slack.com/api/conversations.list?types=private_channel,public_channel&pretty=1'){
            body = '{'+
                '"ok": true,'+
                '"channels": ['+
                '{'+
                '"id": "CBZMYR96E",'+
                '"name": "general",'+
                '"is_channel": true,'+
                '"is_group": false,'+
                '"is_im": false,'+
                '"created": 1532997168,'+
                '"is_archived": false,'+
                '"is_general": true,'+
                '"unlinked": 0,'+
                '"name_normalized": "general",'+
                '"is_shared": false,'+
                '"parent_conversation": null,'+
                '"creator": "UBZMYR69G",'+
                '"is_ext_shared": false,'+
                '"is_org_shared": false,'+
                '"shared_team_ids": ['+
                '"TC0P0A50X"'+
                '],'+
                '"pending_shared": [],'+
                '"is_pending_ext_shared": false,'+
                '"is_member": true,'+
                '"is_private": false,'+
                '"is_mpim": false,'+
                '"topic": {'+
                '"value": "Company-wide announcements and work-based matters",'+
                '"creator": "UBZMYR69G",'+
                '"last_set": 1532997168'+
                '},'+
                '"purpose": {'+
                '"value": "This channel is for workspace-wide communication and announcements. All members are in this channel.",'+
                '"creator": "UBZMYR69G",'+
                '"last_set": 1532997168'+
                '},'+
                '"previous_names": [],'+
                '"num_members": 11'+
                '},'+
                '{'+
                '"id": "GJF3A0JTG",'+
                '"name": "test-close",'+
                '"is_channel": false,'+
                '"is_group": true,'+
                '"is_im": false,'+
                '"created": 1556825748,'+
                '"is_archived": false,'+
                '"is_general": false,'+
                '"unlinked": 0,'+
                '"name_normalized": "test-close",'+
                '"is_shared": false,'+
                '"parent_conversation": null,'+
                '"creator": "UCCMSGJLF",'+
                '"is_ext_shared": false,'+
                '"is_org_shared": false,'+
                '"shared_team_ids": ['+
                '"TC0P0A50X"'+
                '],'+
                '"pending_shared": [],'+
                '"is_pending_ext_shared": false,'+
                '"is_member": true,'+
                '"is_private": true,'+
                '"is_mpim": false,'+
                '"last_read": "1557191746.000100",'+
                '"is_open": true,'+
                '"topic": {'+
                '"value": "",'+
                '"creator": "",'+
                '"last_set": 0'+
                '},'+
                '"purpose": {'+
                '"value": "",'+
                '"creator": "",'+
                '"last_set": 0'+
                '},'+
                '"priority": 0'+
                '}'+
                '],'+
                '"response_metadata": {'+
                '"next_cursor": ""'+
                '}'+
                '}';
            
        }
        else if(req.getEndpoint() == 'https://slack.com/api/channels.info?channel=CBZMYR96E'){
            body = '{'+
                '"ok": true,'+
                '"channel": {'+
                '"id": "CBZMYR96E",'+
                '"name": "general",'+
                '"is_channel": true,'+
                '"created": 1532997168,'+
                '"is_archived": false,'+
                '"is_general": true,'+
                '"unlinked": 0,'+
                '"creator": "UBZMYR69G",'+
                '"name_normalized": "general",'+
                '"is_read_only": false,'+
                '"is_shared": false,'+
                '"is_org_shared": false,'+
                '"is_member": true,'+
                '"is_private": false,'+
                '"is_mpim": false,'+
                '"last_read": "1557452291.000100",'+
                '"latest": {'+
                '"type": "message",'+
                '"subtype": "bot_message",'+
                '"text": "<@UBZMYR69G> saludos",'+
                '"ts": "1557452291.000100",'+
                '"username": "Diaco",'+
                '"bot_id": "BHZASH0UU"'+
                '},'+
                '"unread_count": 0,'+
                '"unread_count_display": 0,'+
                '"members": ['+
                '"UBZMYR69G",'+
                '"UBZN1GYPL"'+
                '],'+
                '"topic": {'+
                '"value": "Company-wide announcements and work-based matters",'+
                '"creator": "UBZMYR69G",'+
                '"last_set": 1532997168'+
                '},'+
                '"purpose": {'+
                '"value": "This channel is for workspace-wide communication and announcements. All members are in this channel.",'+
                '"creator": "UBZMYR69G",'+
                '"last_set": 1532997168'+
                '},'+
                '"previous_names": []'+
                '}'+
                '}';
        }
        else if(req.getEndpoint() == 'https://slack.com/api/groups.info?channel=GJF3A0JTG'){
            body = '{'+
                '"ok": true,'+
                '"group": {'+
                '"id": "GJF3A0JTG",'+
                '"name": "test-close",'+
                '"is_group": true,'+
                '"created": 1556825748,'+
                '"creator": "UCCMSGJLF",'+
                '"is_archived": false,'+
                '"name_normalized": "test-close",'+
                '"is_mpim": false,'+
                '"is_open": true,'+
                '"last_read": "1557191746.000100",'+
                '"latest": {'+
                '"type": "message",'+
                '"subtype": "bot_message",'+
                '"text": "<!channel>  ready",'+
                '"ts": "1557191746.000100",'+
                '"username": "Diaco",'+
                '"bot_id": "BHZASH0UU"'+
                '},'+
                '"unread_count": 0,'+
                '"unread_count_display": 0,'+
                '"members": ['+
                '"UBZMYR69G",'+
                '"UBZN1GYPL"'+
                '],'+
                '"topic": {'+
                '"value": "",'+
                '"creator": "",'+
                '"last_set": 0'+
                '},'+
                '"purpose": {'+
                '"value": "",'+
                '"creator": "",'+
                '"last_set": 0'+
                '}'+
                '}'+
                '}';
        }
        else if(req.getEndpoint() == 'https://slack.com/api/users.info?token=xoxa-408782345031-419122738544-419859988770-6b6f61c477d9067446e812035c7d14ac&user=UCCMSGJLF&pretty=1'){
            body = '{'+
                '"ok": true,'+
                '"user": {'+
                '"id": "UCCMSGJLF",'+
                '"team_id": "TC0P0A50X",'+
                '"name": "jorgeality94",'+
                '"deleted": false,'+
                '"color": "e7392d",'+
                '"real_name": "Jorge Martinez",'+
                '"tz": "America/Bogota",'+
                '"tz_label": "South America Pacific Standard Time",'+
                '"tz_offset": -18000,'+
                '"profile": {'+
                '"title": "",'+
                '"phone": "",'+
                '"skype": "",'+
                '"real_name": "Jorge Martinez",'+
                '"real_name_normalized": "Jorge Martinez",'+
                '"display_name": "Jorgeality",'+
                '"display_name_normalized": "Jorgeality",'+
                '"status_text": "",'+
                '"status_emoji": "",'+
                '"status_expiration": 0,'+
                '"avatar_hash": "023031d4e95c",'+
                '"image_original": "https://avatars.slack-edge.com/2018-08-21/419728875648_023031d4e95c720212f9_original.jpg",'+
                '"first_name": "Jorge",'+
                '"last_name": "Martinez",'+
                '"image_24": "https://avatars.slack-edge.com/2018-08-21/419728875648_023031d4e95c720212f9_24.jpg",'+
                '"image_32": "https://avatars.slack-edge.com/2018-08-21/419728875648_023031d4e95c720212f9_32.jpg",'+
                '"image_48": "https://avatars.slack-edge.com/2018-08-21/419728875648_023031d4e95c720212f9_48.jpg",'+
                '"image_72": "https://avatars.slack-edge.com/2018-08-21/419728875648_023031d4e95c720212f9_72.jpg",'+
                '"image_192": "https://avatars.slack-edge.com/2018-08-21/419728875648_023031d4e95c720212f9_192.jpg",'+
                '"image_512": "https://avatars.slack-edge.com/2018-08-21/419728875648_023031d4e95c720212f9_512.jpg",'+
                '"image_1024": "https://avatars.slack-edge.com/2018-08-21/419728875648_023031d4e95c720212f9_1024.jpg",'+
                '"status_text_canonical": "",'+
                '"team": "TC0P0A50X",'+
                '"is_custom_image": true'+
                '},'+
                '"is_admin": true,'+
                '"is_owner": false,'+
                '"is_primary_owner": false,'+
                '"is_restricted": false,'+
                '"is_ultra_restricted": false,'+
                '"is_bot": false,'+
                '"is_app_user": false,'+
                '"updated": 1555800482,'+
                '"has_2fa": false'+
                '}'+
                '}';
        }
        else if(req.getEndpoint() == 'https://slack.com/api/users.list'){
            body = '{'+
                '"ok": true,'+
                '"members": ['+
                '{'+
                '"id": "USLACKBOT",'+
                '"team_id": "TC0P0A50X",'+
                '"name": "slackbot",'+
                '"deleted": false,'+
                '"color": "757575",'+
                '"real_name": "Slackbot",'+
                '"tz": null,'+
                '"tz_label": "Pacific Daylight Time",'+
                '"tz_offset": -25200,'+
                '"profile": {'+
                '"title": "",'+
                '"phone": "",'+
                '"skype": "",'+
                '"real_name": "Slackbot",'+
                '"real_name_normalized": "Slackbot",'+
                '"display_name": "Slackbot",'+
                '"display_name_normalized": "Slackbot",'+
                '"fields": null,'+
                '"status_text": "",'+
                '"status_emoji": "",'+
                '"status_expiration": 0,'+
                '"avatar_hash": "sv41d8cd98f0",'+
                '"always_active": true,'+
                '"first_name": "slackbot",'+
                '"last_name": "",'+
                '"image_24": "https://a.slack-edge.com/16510/img/slackbot_24.png",'+
                '"image_32": "https://a.slack-edge.com/16510/img/slackbot_32.png",'+
                '"image_48": "https://a.slack-edge.com/16510/img/slackbot_48.png",'+
                '"image_72": "https://a.slack-edge.com/16510/img/slackbot_72.png",'+
                '"image_192": "https://a.slack-edge.com/16510/img/slackbot_192.png",'+
                '"image_512": "https://a.slack-edge.com/16510/img/slackbot_512.png",'+
                '"status_text_canonical": "",'+
                '"team": "TC0P0A50X"'+
                '},'+
                '"is_admin": false,'+
                '"is_owner": false,'+
                '"is_primary_owner": false,'+
                '"is_restricted": false,'+
                '"is_ultra_restricted": false,'+
                '"is_bot": false,'+
                '"is_app_user": false,'+
                '"updated": 0'+
                '},'+
                '{'+
                '"id": "UJ9LM9MKR",'+
                '"team_id": "TC0P0A50X",'+
                '"name": "testforce",'+
                '"deleted": false,'+
                '"color": "5a4592",'+
                '"real_name": "test.",'+
                '"tz": "America/Bogota",'+
                '"tz_label": "South America Pacific Standard Time",'+
                '"tz_offset": -18000,'+
                '"profile": {'+
                '"title": "test",'+
                '"phone": "573014263525",'+
                '"skype": "",'+
                '"real_name": "test test test.",'+
                '"real_name_normalized": "test test test.",'+
                '"display_name": "test",'+
                '"display_name_normalized": "test",'+
                '"status_text": "",'+
                '"status_emoji": "",'+
                '"status_expiration": 0,'+
                '"avatar_hash": "g6c284996c3c",'+
                '"first_name": "test",'+
                '"last_name": "test test.",'+
                '"image_24": "https://secure.gravatar.com/avatar/6c284996c3c1651381bd8e8f841c89ea.jpg?s=24&d=https%3A%2F%2Fa.slack-edge.com%2F00b63%2Fimg%2Favatars%2Fava_0026-24.png",'+
                '"image_32": "https://secure.gravatar.com/avatar/6c284996c3c1651381bd8e8f841c89ea.jpg?s=32&d=https%3A%2F%2Fa.slack-edge.com%2F00b63%2Fimg%2Favatars%2Fava_0026-32.png",'+
                '"image_48": "https://secure.gravatar.com/avatar/6c284996c3c1651381bd8e8f841c89ea.jpg?s=48&d=https%3A%2F%2Fa.slack-edge.com%2F00b63%2Fimg%2Favatars%2Fava_0026-48.png",'+
                '"image_72": "https://secure.gravatar.com/avatar/6c284996c3c1651381bd8e8f841c89ea.jpg?s=72&d=https%3A%2F%2Fa.slack-edge.com%2F00b63%2Fimg%2Favatars%2Fava_0026-72.png",'+
                '"image_192": "https://secure.gravatar.com/avatar/6c284996c3c1651381bd8e8f841c89ea.jpg?s=192&d=https%3A%2F%2Fa.slack-edge.com%2F00b63%2Fimg%2Favatars%2Fava_0026-192.png",'+
                '"image_512": "https://secure.gravatar.com/avatar/6c284996c3c1651381bd8e8f841c89ea.jpg?s=512&d=https%3A%2F%2Fa.slack-edge.com%2F00b63%2Fimg%2Favatars%2Fava_0026-512.png",'+
                '"status_text_canonical": "",'+
                '"team": "TC0P0A50X"'+
                '},'+
                '"is_admin": false,'+
                '"is_owner": false,'+
                '"is_primary_owner": false,'+
                '"is_restricted": false,'+
                '"is_ultra_restricted": false,'+
                '"is_bot": false,'+
                '"is_app_user": false,'+
                '"updated": 1556657528,'+
                '"has_2fa": false'+
                '}'+
                '],'+
                '"cache_ts": 1557742762,'+
                '"response_metadata": {'+
                '"next_cursor": ""'+
                '}'+
                '}';
        }
        else if(req.getEndpoint() == 'https://slack.com/api/chat.postMessage'){
            body = '{'+
                '"ok": true,'+
                '"channel": "CBZMYR96E",'+
                '"ts": "1557743328.000100",'+
                '"message": {'+
                '    "type": "message",'+
                '    "subtype": "bot_message",'+
                '    "text": "test",'+
                '    "ts": "1557743328.000100",'+
                '    "username": "Diaco",'+
                '    "bot_id": "BHZASH0UU"'+
                '}'+
                '}';
        }else{
            body = '{ HTTP/1.1 202}';
        }
        System.debug('endpoint : '+req.getEndpoint());
        response.setHeader('Content-Type', 'text/plain');
        response.setBody(body);
        response.setStatusCode(200);
        return response;
    }
}