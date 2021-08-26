/**
 * Diaco
 * @author             Jull Quintero Daza
 * Project:            Kunnect Sync renplace jitterbit
 * TestClass:          KunnectSyncTest
 * Description:        This class is responsible for to insert user address in mysql Kunnect BD
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version    1.0    03/30/2021         Jull Quintero D         Initial implementation of the class.
 **/

public class KunnectSync {
    public static final List<String> ZIPCODES = new List<String>{
        '85006','85007','85008','85009','85012','85014','85020','85022','85023','85024','85027','85028','85029','85032','85034','85050','85053','85054','85083','85085','85086','85087','85225','85253','85254','85255','85258','85259','85260','85262','85266','85301','85307','85308','85309','85310','85323','85326','85331','85335','85337','85338','85340','85345','85351','85354','85355','85361','85363','85373','85374','85375','85379','85382','85383','85387','85395','85396'};
    public static final List<String> SOURCETABLES = new List<String>{
        'source_contact_01_security','source_contact_01_water','source_contact_windows_and_blinds','source_contact_pest_control','source_contact_hvac','source_contact_solar','source_contact_srp_solar'};
    public static final List<String> GRAVELTABLES = new List<String>{
        'gravel_contact_security','gravel_contact_water','gravel_contact_remodel','gravel_contact_hvac','gravel_contact_pest_control','gravel_contact_solar'};
    public static Boolean isUpdate = true;
    private Map<String,String> report = new Map<String,String>();
    public string emailReport = 'Not Report';
    
    /**
    * @author Jull Quintero | 04/10/2021 
    * @description: Method responsible for POST HTTP callout
    * @param tableName(string) 
    * @param request(KunnectUsAddressDTO) 
    **/
    public void syncUserAddress(string tableName, KunnectUsAddressDTO requestUserAddress) {
        requestUserAddress.tableName = tableName;
        string request = KunnectUsAddressDTO.createJson(requestUserAddress);
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(requestUserAddress.endPoint);
        req.setMethod('POST');
        req.setHeader( 'origin' , 'https://myhomeservices.com/');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(request);
        try {
            HttpResponse res = http.send(req);
            integer statusCode = res.getStatuscode();
            if( statusCode == 200 ) {
                Object body = (Object)JSON.deserializeUntyped(res.getBody());
                String json = KunnectResponseDTO.createJson(body);
                KunnectResponseDTO response = KunnectResponseDTO.parse(json);

                // Set Email Report
                if( this.report.get('totalRows') == null ) this.report.put('totalRows', '0');
                if( this.report.get('totalInserts') == null ) this.report.put('totalInserts', '0');
                if( this.report.get('SqlMessage') == null ) this.report.put('SqlMessage', 'Success');

                // count rows
                integer totalInserts = Integer.valueOf(this.report.get('totalInserts'))  + response.affectedRows;
                this.report.put('totalInserts', String.valueOf(totalInserts));

                integer totalRows = Integer.valueOf(this.report.get('totalRows')) + response.totalRows;
                this.report.put('totalRows', String.valueOf(totalRows));
                
                if( !response.ok ) this.report.put('SqlMessage', response.message);

                this.emailReport = tableName + ' - ' + totalInserts + '/' + totalRows + 
                ' - SqlMessage: ' + this.report.get('SqlMessage');
            }else {
                this.emailReport = tableName+ ' - ' + 'Not Connect, Status Code '+ statusCode; KunnectSync.isUpdate = false;
            }
        } catch (Exception e) {
            this.emailReport = tableName+ ' - ' + 'Apex Error: line ' + e.getLineNumber() + ' ' + e.getMessage(); KunnectSync.isUpdate = false;
        }
    }
}