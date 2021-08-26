public class DiacoPostChatterOnCommission {  
    @InvocableMethod() 
    public static void execute(List<String> params) {
        List<FeedItem> fis = new List<FeedItem>();
        for (String param : params){
            String [] data = param.split(',');
            FeedItem post = new FeedItem();
            post.Body = 'The funding has been paid, and the commission amount should be $'+data[1]+'.';
            post.ParentId = data[0];
            fis.add(post);
        }
        insert fis;
        
        
        /* FeedItem post = new FeedItem();
        post.Body = 'This is a Teeeeeest';
        post.ParentId = 'a0m0r0000003uJoAAI';
        insert post; */
    }
}