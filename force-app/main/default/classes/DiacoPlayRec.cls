public class DiacoPlayRec {

    @AuraEnabled
    public static List<Call_Record__c> getCallByUA(String userAddress){
        return [select Id, Name, Rec_Date__c, Rec_WAV__c
               from Call_Record__c where User_Address__c =: userAddress];
    }
}