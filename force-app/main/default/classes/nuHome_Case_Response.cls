/**************************************************************************************************************
Created By:MST Solutions.
Description : Wrapper class to deserialize the case comment records from webservice api response .
***************************************************************************************************************/
public class nuHome_Case_Response{
    public String access_token;
    public String instance_url;
    public String id;
    public String token_type;
    public String issued_at;
    public String signature;
    public static nuHome_Case_Response parse(String json){
        return (nuHome_Case_Response) System.JSON.deserialize(json, nuHome_Case_Response.class);
    }

}