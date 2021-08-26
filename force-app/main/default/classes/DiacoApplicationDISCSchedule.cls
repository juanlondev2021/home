global class DiacoApplicationDISCSchedule implements Schedulable  {
    global void execute(SchedulableContext sc) {
        DiacoApplicationDISCBatch myBatchObject = new DiacoApplicationDISCBatch(); 
        Database.executeBatch(myBatchObject,50);        
        // DiacoApplicationDISCSchedule m = new DiacoApplicationDISCSchedule();
        //String sch = '0 0 10 ? * *';
        //String sch = '0 0 15 ? * *';
        //String jobID = system.schedule('DISC Status Job', sch, m);
    }
}