global class DiacoScheduleCommissionOnLineItem {
    
    global DiacoScheduleCommissionOnLineItem() {
        
        system.debug('Inicio Prueba de creación de comisiones mensuales por LineItem');
        actions();  
        deleteJob();
        assignjob();
        system.debug('Fin Prueba de creación de comisiones mensuales por LineItem');
    }
    public static Decimal decimalMod(decimal x, integer y){
        Decimal remainder = 0;
        if(x != 0){
            Decimal firstResult = x / y; 
            Decimal flooredResult = math.floor(firstResult);
            Decimal flooredProduct = flooredResult * y;
            remainder = x - flooredProduct; 
        }
        return remainder;
    }
    
    public static void actions() {
        DateTime myDateTime = system.now();
		//system.debug('Start actions'); 
		List<Line_Item__c> lis = [SELECT Id, Name, Monthly_Investment__c, Home_Service__c, CreatedDate FROM Line_Item__c WHERE Service_Check__c = true and Active__c = true];
        
        List<Line_Item__c> newLis = new List<Line_Item__c>();
        List<String> HSIds = new List<String>();
        
        
        for(Line_Item__c lineItem : lis ){
            //system.debug(myDateTime.getTime()+' - '+lineItem.CreatedDate.getTime());
            // system.debug(myDateTime.getTime() - lineItem.CreatedDate.getTime());
            /*long days = (myDateTime.getTime() - lineItem.CreatedDate.getTime()) / 86400000;
            if(decimaMod(days / 30, 1)){
                // 
            }*/
           //  DateTime aux = DateTime.newInstance(lineItem.Bill_Start_Date__c, Time.newInstance(0,0,0,0));
            decimal days = ((myDateTime.getTime() - lineItem.CreatedDate.getTime()) / 86400000).intValue();
            decimal toTest = (days / 30);
            //system.debug(lineItem.Name + ': ' + minutes +' - '+(toTest));
            
            if(decimalMod(toTest, 1) == 0){
                //createCommission(lineItem);
               // system.debug(lineItem.Name + ' - Nueva comisión.');
               newLis.add(lineItem);
               HSIds.add(lineItem.Home_Service__c);
            }
            system.debug(days);
            
            //system.debug(lineItem.Name + ': ' + days);
            system.debug('---------------------');
        }
        List<Home_Services__c> HSs = [SELECT Id, Sales_Rep_Personnel__c FROM Home_Services__c WHERE id in :HSIds];
        
        List<Commission__c> cms = new List<Commission__c>();
        for(Line_Item__c lineItem : newLis){
             for(Home_Services__c homeService : HSs ){
                 if(lineItem.Home_Service__c == homeService.Id){
                     cms.add(createCommission(lineItem, homeService.Sales_Rep_Personnel__c));
                     break;
                 }
             }
        }
        insert cms;
      
        
        
        //system.debug('End actions'); 
    }
    
    public static Commission__c createCommission(Line_Item__c lineItem, string personnelId) {
        
        Commission__c nc =  new Commission__c();
        nc.Name = lineItem.Name+' - Commision';
        nc.Home_Service__c = lineItem.Home_Service__c;
        // Home_Services__c hs = [SELECT Id, Sales_Rep_Personnel__c FROM Home_Services__c WHERE id=:nc.Home_Service__c ];
        nc.Personnel__c = personnelId;
        // nc.Personnel__c = lineItem.Home_Service__c.
        nc.Commission_Amount__c = lineItem.Monthly_Investment__c * 0.2;
        system.debug(nc.Commission_Amount__c);
       	//insert nc;
       	return nc;
        
        
        /*/**despues de 30 dias, partiendo de la fecha inicial se cambie a cancelado. 
        List<Contract> contracts = new List<Contract>();
        
        Contract[] capitaIntencion = [SELECT Id, StartDate FROM Contract WHERE F1_ModalidadPago__c = 'CARTA DE INTENCIÓN'];
        if(capitaIntencion.size() > 0 ) {
            
            for(Contract c: capitaIntencion) {
                date startDate = (date)c.StartDate;
                if( (startDate + 30) == system.today() ) {
                    
                    c.Status = 'Activated';
                    contracts.add(c);
                }
                
                try{
                    
                    update contracts;
                }catch(Exception e){
                    system.debug('Exception: ' + e.getMessage());                    
                }
            }
        }*/      
    }
    
    public static void assignjob() {
        //system.debug('Start assignJob');
        
        DateTime myDateTime = system.now().addMinutes(24*60);
        // f1_CambioEstadoCartadeIntencion shedule = new f1_CambioEstadoCartadeIntencion();
        DiacoScheduleCommissionOnLineItemCaller shedule = new DiacoScheduleCommissionOnLineItemCaller();
       	String title = 'Create Commission monthly during a year of Line Item';
        String sch = '0 '+myDateTime.minute()+' '+myDateTime.hour()+' '+myDateTime.day()+' '+myDateTime.month()+' ?';
        // system.debug(sch);
        system.schedule(title, sch, shedule);     
        
        //system.debug('End assignJob');
    }
    
    public static void deleteJob() {
        String title = 'Create Commission monthly during a year of Line Item';
        for(CronTrigger con  : [SELECT Id, CronJobDetail.Name, CronJobDetail.Id, State FROM CronTrigger]){
            if(con.CronJobDetail.Name == title){
                System.abortJob(con.Id);
            }
        }
    }
}