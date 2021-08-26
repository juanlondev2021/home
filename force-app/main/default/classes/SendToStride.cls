public class SendToStride {
     @InvocableMethod(label='Send Stride' description='Sends a message to Stride.')
    public static void SendMessage(List<String> param) {
        if (param != null){
            String str = param[0];
            if (str.contains(',')) {
                String[] strSplit = str.split(',');
                SendMessageToStride.StrideMessage(strSplit[0],strSplit[1]);
                return;
            }
        }
        return;
    }

}