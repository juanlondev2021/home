/**************************************************************************************************************
                    Created By: MST
                    Description : This class send docusign envelope to emails
***************************************************************************************************************/
public class AuthCalloutvf{
public Account currAcc;
public List<Accountwrapper> acclist{get;set;}
public List<contact> selectedcontactlist{get;set;}
public String displayError{get;set;}
Public String result;

public AuthCalloutvf(ApexPages.StandardController controller){
    currAcc = (Account)controller.getRecord();
    selectedcontactlist= NEW List<contact>();
      acclist = NEW List<Accountwrapper>();
    FOR(Contact cc: [SELECT ID,EMAIL,name,accountid FROM CONTACT WHERE ACCOUNTID =:currAcc.ID]){
        Accountwrapper acwrap = new Accountwrapper();
        acwrap.selectedAccount = FALSE;
        acwrap.accountins = cc;
        acclist.add(acwrap);
}
}
//Send Payment Info button action
public pagereference senddoc(){
    for(Accountwrapper acWrap:acclist){
    if(acWrap.selectedAccount)
    selectedcontactlist.add(acWrap.accountins);
    }
    if(selectedcontactlist.size()<100){
    AuthCallout pass = new AuthCallout();
    //Passing the list of contacts to docusign class
    String result = pass.basicAuthCallout(selectedcontactlist);
    
    if(result=='sent')
    return new pagereference('/'+currAcc.ID);
    else
        displayError = result;
    }else{
        displayError = 'Please Select Below 100 Contacts.';
    }
    return null;
}
//Wrapper class for the table
public class Accountwrapper{
    public boolean selectedAccount{get;set;}
    public contact accountins{get;set;}
}

}