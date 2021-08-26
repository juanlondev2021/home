public class DiacoMyHomeServicesManageController {
    public static Map<String, List<String>> industries{get; set;}
    /*
    0{'label': 'Aqua Bright Water', 'value': 'Aqua Bright Water'},
    1{'label': 'Protection Source', 'value': 'Protection Source'},
    2{'label': 'Latch', 'value': 'Latch'},
    3{'label': 'Jax Pest Control', 'value': 'Jax Pest Control'},
    4{'label': 'N-Ergy', 'value': 'N-Ergy'},
    5{'label': 'Rescue On Air', 'value': 'Rescue On Air'},*/
    public static void generateIndustries() {
        industries = new Map<String, List<String>>();
        List<String> aux;
        aux = new List<String>{'\'Pool Maintenance\'', '\'Water Treatment\''};
        industries.put('Aqua Bright Water', aux);
        aux = new List<String>{'\'Home Automation\''};
        industries.put('Protection Source', aux);
        aux = new List<String>{'\'Garage Doors\'', '\'Internet-Cable-Satelite\'', '\'Lock Smith\'', '\'Maid Service\'', '\'Remodel\'', '\'Carpet & Tile Cleaning\'', '\'Garage Floor Coating\''};
        industries.put('Latch', aux);
        aux = new List<String>{'\'Pest Control\''};
        industries.put('Jax Pest Control', aux);
        aux = new List<String>{'\'Solar\''};
        industries.put('N-Ergy', aux);
        aux = new List<String>{'\'HVAC\''};
        industries.put('Rescue On Air', aux);
        
        
        List<String> all = new List<String>{'\'Pool Maintenance\'', '\'Water Treatment\'', '\'Home Automation\'','\'Garage Doors\'', '\'Internet-Cable-Satelite\'',
                                            '\'Lock Smith\'', '\'Maid Service\'', '\'Remodel\'', '\'Carpet & Tile Cleaning\'', '\'Garage Floor Coating\'', '\'Pest Control\'', '\'Solar\'',
                                            '\'HVAC\''};
        industries.put('all', all);
            
     }
    
    @AuraEnabled
    public static List<Home_Services__c> getHomeServices(){
        generateIndustries();    
        String aux = '(' + String.join( industries.get('all'), ',' ) + ')';
        String query = 'select Id, Name, Home_Services_Status__c, Marketing__c, Data__c, Appointment__c, Hot_Lead__c, Revenue_Note__c, CreatedDate, Industry_Formula__c'
            + ' from Home_Services__c'
            + ' where Industry_Formula__c in ' + aux
            + ' order by CreatedDate desc';
        
        system.debug(aux);
        system.debug(query);
        List<Home_Services__c> HSList = Database.query(query);
        
        return HSList;
    }
    
    @AuraEnabled
    public static List<Home_Services__c> getFilterHomeServices(List<String> data, Date dateFrom, Date dateTo){
        generateIndustries();        
        /*system.debug(data[4]);
        system.debug(industries);
        system.debug(industries.get(data[4]));*/
        String query;
        DateTime dateTimeFrom;
        DateTime dateTimeTo;
        if(dateFrom == null){
            query = 'select Id, CreatedDate'
                + ' from Home_Services__c'
                + ' order by CreatedDate asc limit 1';
            
            system.debug(query);
            List<Home_Services__c> HS = Database.query(query);
            dateTimeFrom = HS[0].CreatedDate;
        }else{
            dateTimeFrom = DateTime.newInstance(dateFrom, Time.newInstance(00, 00, 00, 0000));
        }
        
        if(dateTo == null){
            dateTimeTo = DateTime.now().AddDays(1);
        }else{
            dateTimeTo = DateTime.newInstance(dateTo.addDays(1), Time.newInstance(00, 00, 00, 0000));
        }
        
        
        //data[5] = dateTimeFrom.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        //data[6] = dateTimeTo.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        
        String aux = '(' + String.join( (data[4] != '' ? industries.get(data[4]) : industries.get('all')), ',' ) + ')';
        query = 'select Id, Name, Home_Services_Status__c, Marketing__c, Data__c, Appointment__c, Hot_Lead__c, Revenue_Note__c, CreatedDate, Industry_Formula__c'
            + ' from Home_Services__c'
            + ' where Marketing__c in ' + data[0].split(',')
            + ' and Data__c in ' + data[1].split(',')
            + ' and Appointment__c in ' + data[2].split(',')
            + ' and Hot_Lead__c in ' + data[3].split(',')
            + ' and Industry_Formula__c in ' + aux
            + ' and CreatedDate >= ' + dateTimeFrom.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'', 'GTM') 
            + ' and CreatedDate < ' + dateTimeTo.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'','GTM')
            + ' order by CreatedDate desc';
        
        system.debug(query);
        List<Home_Services__c> HSList = Database.query(query);
        return HSList;
    }
    
    @AuraEnabled
    public static void updateHomeServices(List<Home_Services__c> HS) {
        update HS;
    }
}