global class DiacoAccountUtilityZipCode {
    @InvocableMethod
    public static void utilityZipCode(List<param> params) {
        List<String> zips = new List<String>();
        List<String> Ids = new List<String>();
        for(param p: params){
			
            zips.add(p.Zip);
        }
        List<ZipCode__c> zs=[select Account__c,Name from ZipCode__c where Name IN :zips];
        List<Account> us=[select Id,Name from Account where Name In ('Unknown Utility','Invalid Zip') Order By Name];
        String Unknown = null;
        String Invalid = null;
        for(Account ac : us){
            if(Unknown==null && ac.Name=='Unknown Utility'){
                Unknown=ac.Id;
            }
            if(Invalid==null && ac.Name=='Invalid Zip'){
                Invalid=ac.Id;
            }
            if(Unknown!=null && Invalid!=null){
                break;
            }
        }
        System.debug('Invalid :'+Invalid);
        System.debug('Unknown: '+Unknown);
        //List<Account> is=[select Id from Account where Name='Invalid Zip'];
        
        List<Account> Af = new List<Account>();
        
        for(param split : params) {
            //string[] split= param.split(',');
            String id=split.Id;
            String zip=String.isEmpty(split.Zip)==false?split.Zip:'';
            if(zip!='' && zip.length()==5){
                ZipCode__c temp = new ZipCode__c();
                temp.Account__c=null;
                Boolean flat=false;
                for(ZipCode__c f:zs){
                    if(f.Name==zip){
                        flat=true;
                        temp=f;
                        break;
                    }
                }
                
                if(flat){
                    Account a=new Account();
                    a.Id=id;
                    System.debug('Temp: '+temp.Account__c);
                    if(temp.Account__c!=null){
                    	a.Utility__c=temp.Account__c;
                    }
                    Af.add(a);
                    //System.debug('Utiliry Id');
                }else{
                    if(Unknown!=null){
                        Account a=new Account();
                        a.Id=id;
                        a.Utility__c=Unknown;
                        Af.add(a);
                    }
                   	//System.debug('Invalid New Utility Id');
                }
            }else{
                if(Invalid!=null){
                    Account a=new Account();
                    a.Id=id;
                    a.Utility__c=Invalid;
                    Af.add(a);
                }
                //System.debug('Invalid Zip');
            }
            
        }
        for(Account a: Af){
            System.debug(a);
        }
        upsert Af;
    }
    
    global class param {
        @InvocableVariable
        global String Id;
        @InvocableVariable
        global String Zip;
    }
}