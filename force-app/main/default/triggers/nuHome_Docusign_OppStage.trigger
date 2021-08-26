/**************************************************************************************************************
Created By:MST Solutions.
Description : This is the Trigger to update the opportunity stage field based on docusign status.
***************************************************************************************************************/
trigger nuHome_Docusign_OppStage on dsfs__DocuSign_Status__c (after insert,after update) {
    //Call the Opportunity class nuHome_Docusign_OppStage_Handler.
    // if(Trigger.isUpdate && Trigger.isAfter){ 
         nuHome_Docusign_OppStage_Handler.changeStage(Trigger.New);
    // }
      
}