public class KunnectResponseDTO {
    public Boolean ok;
    public String tableName;
    public string message;
    public integer affectedRows;
    public integer totalRows;
    /**
    * @author Jull Quintero | 21/04/2021 
    * @description: parse Json to KunnectResponseDTO object
    * @param json(String) 
    **/
    public static KunnectResponseDTO parse(String json) { 
        return (KunnectResponseDTO)System.JSON.deserialize(json, KunnectResponseDTO.class);
    }

    /**
    * @author Jull Quintero | 21/04/2021 
    * @description: parse Json to KunnectScheduleSetting object
    * @param obj(Object) 
    **/
    public static String createJson(Object obj) {            
        return (String) System.JSON.serialize(obj);
    } 
}