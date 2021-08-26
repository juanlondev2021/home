/**
 * Diaco LLC
 * @author 			Giovanni Ulloque Olivares href = <Gulloque@diaco.us>
 * Project:			Update Order Schedule Job.
 * Test:            DiacoUpdateOrderTest
 * Description:		Schedule Job to update records with the Update Order parameters..
 *
 * Changes (Version)
 * ______________________________________________________________________________________________
 *			No.		Date			Author					Description
 *			____	__________		__________________  	_____________________________________
 * @version	1.0		30/07/2020		Giovanni Ulloque (GU)	Initial implementation of the class.
 **/
global class DiacoUpdateOrderScheduleJob implements Schedulable{
    global DiacoUpdateOrderScheduleJob() {

    }
    global void execute(System.SchedulableContext SC){
        DiacoUpdateOrderSchedule schedule = new DiacoUpdateOrderSchedule(); 
    }
}