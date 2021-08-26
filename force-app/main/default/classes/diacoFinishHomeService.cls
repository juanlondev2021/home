public class diacoFinishHomeService {
    
    @InvocableMethod(label='Send To Sendgrid' description='Sends home services´s email to sendgrid to create campaing.')
    public static void SaveContactSendgrid(List<String> param) {
        if (param[0] != null){
            String str = param[0];
            if (str.contains(',')) {
                String[] strSplit = str.split(',');
                System.debug(str);
                System.debug(strSplit);
                finishHomeServices.saveContactSendgrid(strSplit[0],strSplit[1],strSplit[2],strSplit[3],strSplit[4]);
                finishHomeServices.sendEmail(strSplit[4]);
                //return;
            }
        }
        return;
    }

}