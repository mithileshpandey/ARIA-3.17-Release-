global class AriaBatchSyncEmailTemplateScheduler implements Schedulable {

    global void execute(SchedulableContext sc){
        Database.executeBatch(new AriaBatchSyncEmailTemplate()); 
    }
    
}