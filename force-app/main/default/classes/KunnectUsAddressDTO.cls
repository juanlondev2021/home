/**
 * Diaco
 * @author             Jull Quintero Daza
 * Project:            kunnect Integrations
 * Description:        DTO Request
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version    1.0    30/03/2021         Jull Quintero D         Initial implementation of the class.
 **/

public class KunnectUsAddressDTO {

    public list<User_Address__c> userAddress {get;set;} 
    public set<Integer> confNumbers {get;set;}
    public string endPoint {get;set;}
    public string tableName {get;set;}

        /**
    * @author Jull Quintero | 9/04/2021 
    * @description: parse Json to KunnectUsAddressDTO object
    * @param json(String) 
    **/
    public static KunnectUsAddressDTO parse(String json) { 
        return (KunnectUsAddressDTO)System.JSON.deserialize(json, KunnectUsAddressDTO.class);
    }

    /**
    * @author Jull Quintero | 9/04/2021 
    * @description: parse Json to KunnectUsAddressDTO object
    * @param obj(KunnectUsAddressDTO) 
    **/
    public static String createJson(KunnectUsAddressDTO obj) {            
        return (String) System.JSON.serialize(obj);
    } 
    
    
    /**
    * @author Jull Quintero | 21/04/2021 
    * @description: parse Json to set<Integer>
    * @param set<Integer>
    **/
    public static String createJson(set<Integer> confNumbers) {            
        return (String) System.JSON.serialize(confNumbers);
    } 
}