/**************************************************************************************************************
Description : Wrapper class to deserialize the case comment records from webservice api response .
***************************************************************************************************************/
public class parseCasecomment{
    public Integer totalSize;   //4
    public boolean done;
    public cls_records[] records;
    
    public class cls_records {
        public cls_attributes attributes;
        public String id{get;set;} //testtest
        public String CommentBody{get;set;}  //testtest

    }
    Public class cls_attributes {
        public String type; //CaseComment
        public String url;  ///services/data/v20.0/sobjects/CaseComment/00a7A000000LcOvQAK
    }
    public static parseCasecomment parse(String json){
        return (parseCasecomment) System.JSON.deserialize(json, parseCasecomment.class);
    }
}