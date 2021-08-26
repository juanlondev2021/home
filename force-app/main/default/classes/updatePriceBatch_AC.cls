global class updatePriceBatch_AC implements Schedulable{
    
    global void execute(SchedulableContext SC){
    
           Database.executeBatch(new BatchUpdatingPriceonInv_AC(),25);
       
    }
}