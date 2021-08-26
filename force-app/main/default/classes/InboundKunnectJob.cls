/**
 * Diaco
 * @author             Esnayder Morales
 * Project:            kunnect Inbound, syncKunnectToSalesforce
 * TestClass:          InboundKunnectTest
 * Description:        JOB to POST Homse Service Server, Inser User Address Kunnect DB
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version    1.0    08/04/2021         Esnayder Morales         Initial implementation of the class.
 **/
public class InboundKunnectJob implements Schedulable {

    public void execute(System.SchedulableContext SC) {
        //SyncKunnectUsAddressBridge schedule = new SyncKunnectUsAddressBridge(); 
        InboundKunnect.execute();
    }

}