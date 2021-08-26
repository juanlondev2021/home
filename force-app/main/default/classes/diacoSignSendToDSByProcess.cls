global without sharing class diacoSignSendToDSByProcess {

    @InvocableMethod(label='send to docusign(package)' description='create an envelope to send to docusign')
    global static void sendToDocusign(List<String> param) {
        if (param != null){
            String str = param[0];
            if (str.contains(',')) {
                String[] strSplit = str.split(',');
                diacoSignSendVFPasDocumentBDS.sendToDocusign(strSplit[0],strSplit[1]);
                return;
            }
        }
        return;
    }
}