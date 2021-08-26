/**
 * Diaco
 * @author             Jull Quintero Daza
 * Project:            Kunnect Sync renplace jitterbit
 * TestClass:          OutboundGravelSheduleTest
 * Description:        kunnect Outbound Gravel - Schedule JOB every day 2:40 am 
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version    1.0    04/12/2021         Jull Quintero D         Initial implementation of the class.
 **/

public class OutboundGravelShedule implements Schedulable{
    //System.schedule('OutboundGravelShedule', '0 10 * * * ?', new OutboundGravelShedule());
    //System.schedule('OutboundGravelShedule', '0 40 2 ? * 1,2,3,4,5,6,7', new OutboundGravelShedule());
    public void execute(System.SchedulableContext SC) {
        system.debug('>> Running Schedulable');
        OutboundGravelBatch batchOutboundGravel = new OutboundGravelBatch();
        Id batchId = Database.executeBatch(batchOutboundGravel,60);
    }
}