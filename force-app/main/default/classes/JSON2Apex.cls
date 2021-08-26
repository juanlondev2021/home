/**************************************************************************************************************
                    Created By: MST
                    Description : Wrapper class to deserialize the http response
***************************************************************************************************************/
public class JSON2Apex {

    public String envelopeId;
    public String uri;
    public String statusDateTime;
    public String status;

    
    public static JSON2Apex parse(String json) {
        return (JSON2Apex) System.JSON.deserialize(json, JSON2Apex.class);
    }
}