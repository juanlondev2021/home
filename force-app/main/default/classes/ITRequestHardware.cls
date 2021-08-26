public class ITRequestHardware {
    public static void test() {
        
    }
    /*
    String HardwareStatusText;
    List<IT_Hardware_Request__c> HardwareGridData;
    Boolean HardwareInsertFlag;
    Integer HardwareInsertCount;
    IT_Request__c IT_Request;
    String requestId;

    // Constuctor for extending the standard controller
    public ITRequestHardware () {
        //system.debug('!!!Controller Start!!!');
        this.IT_Request = [select id, name from IT_Request__c where Id = :ApexPages.currentPage().getParameters().get('id')];
        requestId = IT_Request.id;
        HardwareStatusText = '';
        HardwareGridData = HardwareGridDataList();
        HardwareInsertFlag = false;
        HardwareInsertCount = 0;
        //system.debug('!!!Controller End!!!');
    }

    // Fill Hardware list with data
    public List<IT_Hardware_Request__c> HardwareGridDataList(){
        //system.debug('!!!GridData List Start!!!');
        List<IT_Hardware_Request__c> gl = new List<IT_Hardware_Request__c>{};
        try {
            gl = [Select i.SystemModstamp, i.Requested_Number__c, i.Price__c, i.Name, i.LastModifiedDate, i.LastModifiedById, i.IsDeleted, i.Id, i.IT_Request__c, i.IT_Hardware__c, i.CreatedDate, i.CreatedById, i.IT_Hardware__r.IT_Asset_Group__c From IT_Hardware_Request__c i where i.IT_Request__c = :IT_Request.id];
        } catch (QueryException e){
            system.debug(e.getMessage());
            HardwareStatusText = e.getMessage();
        }
        //system.debug('!!!GridData List Stop!!!');
        return gl;
    }

    // Called from Grid to get List of Hardware requests
    public List<IT_Hardware_Request__c> getHardwareGridData () {
        if (HardwareInsertFlag){
           HardwareGridData.add(new IT_Hardware_Request__c(IT_Request__c = IT_Request.id, Requested_Number__c = 1));
           HardwareInsertFlag = false;
        }
        return HardwareGridData;
    }

    // Called from Page to pass values from Hardware grid to controller
    public void setHardwareGridData(List<IT_Hardware_Request__c> gd) {
        HardwareGridData = gd;
    }

    // Called from Page to get Hardware StatusText
    public String getHardwareStatusText() {
        return HardwareStatusText;
    }

    // Called from Page to get IT Request id
    public String getRequestId() {
        return requestId;
    }

    public String getHardwareInsertFlag() {
        if(HardwareInsertCount > 0){
            return 'true';
        }
        else {
            return 'false';
        }
    }

    
    // Called from Hardware Grid "Save" Button
    public PageReference saveHardwareRequest () {
        try {
            upsert HardwareGridData;
        } catch (DMLException e) {
            system.debug(e.getMessage());
            HardwareStatusText = e.getMessage();
        }   
        HardwareGridData = HardwareGridDataList();
        HardwareInsertCount = 0;
        return null;
    }

    // Called from Hardware Grid "Add" Button
    public PageReference addHardwareRequest () {
        HardwareInsertCount++;
        HardwareInsertFlag = true;
        return null;
    }

    // Called from Hardware Grid "Cancel" Button
    public PageReference CancelHardwareRequest () {
        HardwareGridData = HardwareGridDataList();
        HardwareInsertFlag = false;
        HardwareInsertCount = 0;
        return null;
    }  */  
}