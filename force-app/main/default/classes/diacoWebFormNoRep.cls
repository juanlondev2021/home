public class diacoWebFormNoRep {
    @InvocableMethod
    public static void noRep(List<String> params) {
        for(String param : params) {
            string[] split= param.split(',');
            String id=split[0];
            List<Personnel__c> p=[select id from Personnel__c where Name='Web NoRep' limit 1];
            if(p.size()>0){
                webForm__c w = new webForm__c();
                w.Id=id;
                w.ApptSetter__c=p[0].Id;
                upsert w;
            }
        }
    }
}