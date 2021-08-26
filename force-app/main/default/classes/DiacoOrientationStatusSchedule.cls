global class DiacoOrientationStatusSchedule implements Schedulable {
    global void execute(SchedulableContext sc) {
         DiacoOrientationStatusBatch myBatchObject = new DiacoOrientationStatusBatch(); 
         Database.executeBatch(myBatchObject);
        
       // DiacoOrientationStatusSchedule m = new DiacoOrientationStatusSchedule();
        //String sch = '0 57 5-22 ? * MON-FRI';
        //String jobID = system.schedule('Orientation Status Job', sch, m);
    }
    
}