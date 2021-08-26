/**
 * Diaco
 * @author             Jull Quintero Daza
 * Project:            Kunnect Sync renplace jitterbit
 * TestClass:          OutboundProSourSheduleTest
 * Description:        kunnect Outbound Source - Schedule JOB every day 2:20 am 
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version    1.0    04/09/2021         Jull Quintero D         Initial implementation of the class.
 **/

public class OutboundProSourShedule implements Schedulable {
    //System.schedule('OutboundProSourShedule', '0 10 * * * ?', new OutboundProSourShedule());
    //System.schedule('OutboundProSourShedule', '0 20 2 ? * 1,2,3,4,5,6,7', new OutboundProSourShedule());
    public void execute(System.SchedulableContext SC) {
        system.debug('>> Running Schedulable');
        OutboundProSourBatch batchOutboundSource = new OutboundProSourBatch();
        Id batchId = Database.executeBatch(batchOutboundSource,60);
    }
}