public class nuHome_Verbal_Consent_AC {
    /*
     *Created By: MST
     *Description : Verbal Consent Call, Verbal Consent Email and Verbal Consent Text values based on Respond date value and verbal consent.
     * */
    //This method is to update the 3 picklist(call, email, text) values.
    public static void chooseVerbalConsent(List<Account> acntList){
        //Recursive check.
        if(nuHome_Verbal_Recursive_AC.isExecute){
            nuHome_Verbal_Recursive_AC.isExecute = False;
            //Flag to know whether the updation should happen or not.
            Boolean processFlag = False;
            List<Account> accVerbList = new List<Account>();
            for(Account currAcnt:acntList){
                system.debug('currAcnt Record Details'+currAcnt.id);
                Account accVer = new Account();
                accVer.id = currAcnt.id;
                //checking respond date value.
                if(currAcnt.Respond_Date__c != null ){
                    
                    if(currAcnt.Respond_Date__c!=null){
                        processFlag = True;
                        accVer.Call__c = 'Level 1';
                        accVer.Email__c = 'Level 1';
                        accVer.Text__c = 'Level 1';
                    }
                    //Checking verbal consent value is Yes
                    if(currAcnt.Verbal_Consent__c == 'Yes'){
                        processFlag = True;
                        accVer.Call__c = 'Level 2';
                        accVer.Email__c = 'Level 2';
                        accVer.Text__c = 'Level 2';      
                    }else if(currAcnt.Verbal_Consent__c == 'No'){
                        //Checking verbal consent value is No
                        processFlag = True;
                        accVer.Call__c = 'Level 1';
                        accVer.Email__c = 'Level 1';
                        accVer.Text__c = 'Level 1';       
                    }else if(currAcnt.Verbal_Consent__c == 'Email Only'){
                        //Checking verbal consent value is Email Only
                        processFlag = True;
                        accVer.Call__c = 'Level 1';
                        accVer.Email__c = 'Level 2';
                        accVer.Text__c = 'Level 1';
                    }else if(currAcnt.Verbal_Consent__c == 'Phone Only'){
                        processFlag = True;
                        accVer.Call__c = 'Level 2';
                        accVer.Email__c = 'Level 1';
                        accVer.Text__c = 'Level 2';
                    }
                    if(currAcnt.PersonHasOptedOutOfEmail == True ){
                        processFlag = True;
                        accVer.id = currAcnt.id;
                        accVer.Email__c = 'None';              
                    }
                    if(currAcnt.PersonDoNotCall == True){
                        processFlag = True;
                        accVer.Call__c = 'None';
                        accVer.Text__c = 'None'; 
                    }
                }
                else{
                    processFlag = True;
                    accVer.Call__c = null;
                    accVer.Email__c = null;
                    accVer.Text__c = null;                    
                }
                accVerbList.add(accVer);
                //Update the account with the picklist values.
                system.debug('Verbal Consent List'+accVerbList);

            }
            if(accVerbList.size() > 0 && processFlag == True){}
            update accVerbList;
        }
    }
}