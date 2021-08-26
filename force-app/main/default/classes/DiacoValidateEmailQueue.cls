public class DiacoValidateEmailQueue implements Queueable { 
    private String PersonEmail;
    private ID accountId;
    private List<Account> accounts;
    //private List<Account> account = new List<Account>();
    public DiacoValidateEmailQueue(List<Account> accounts) {
        this.accounts = accounts;
    }
    /*public DiacoValidateEmailQueue(String email, ID id) {
        this.PersonEmail = email;
        this.accountId = id;
        //this.account = account;
    }*/
    public void execute(QueueableContext context) {
        // awesome code here
        String accounts = JSON.serialize(accounts);
        //Probar en la noche ambiente controlado
        diacoValidateEmail.verificateEmail(accounts);
    }

}