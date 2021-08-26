/**
 * Diaco
 * @author             Jull Quintero Daza
 * Project:            kunnect Inbound
 * TestClass:          SyncKunnectUsAddressTest
 * Description:        Schedule to POST Homse Service Server, Inser User Address Kunnect DB
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version    1.0    03/30/2021         Jull Quintero D         Initial implementation of the class.
 **/

public class SyncKunnectUsAddressShedule implements Schedulable {
    //System.schedule('SyncKunnectUsAddressShedule', '0 10 * * * ?', new SyncKunnectUsAddressShedule());
    public void execute(System.SchedulableContext SC) {
        system.debug('>> Running Schedulable');
        SyncKunnectUsAddressBatch batchInbound = new SyncKunnectUsAddressBatch();
        Id batchId = Database.executeBatch(batchInbound,100);
    }
}