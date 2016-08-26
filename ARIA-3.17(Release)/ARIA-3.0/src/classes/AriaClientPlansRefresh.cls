public with sharing class AriaClientPlansRefresh {
        public AriaClientPlansRefresh(){}

        public void refreshClientPlans() {
               
                List<AsyncApexJob> jobs= new List<AsyncApexJob>([Select a.Status, a.MethodName, a.JobType, a.ExtendedStatus, a.ApexClass.Name, a.ApexClassId From AsyncApexJob a where a.ApexClass.Name='AriaBatchProductFieldSync' and status IN ('Processing', 'Queued', 'Preparing') ]);//SK2012-8-15 updated code when above code errored in managed package v1.0
                if(jobs.size() > 0){
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Warning,'Client plans are currently being refreshed. Please wait for the existing job to complete.');
                        ApexPages.addMessage(msg);
                } else {
                        AriaBatchProductFieldSync sync = new AriaBatchProductFieldSync(false);
                        Integer batchSize = AriaCustomSettingUtil.getSyncProductFieldBatchSize();
                        database.executebatch(sync,batchSize);
                }
        }
        
        public void refreshSuppFields() {
               
                List<AsyncApexJob> jobs= new List<AsyncApexJob>([Select a.Status, a.MethodName, a.JobType, a.ExtendedStatus, a.ApexClass.Name, a.ApexClassId From AsyncApexJob a where a.ApexClass.Name='AriaBatchProductFieldSync' and status IN ('Processing', 'Queued', 'Preparing') ]);//SK2012-8-15 updated code when above code errored in managed package v1.0
                if(jobs.size() > 0){
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Warning,'Client plans are currently being refreshed. Please wait for the existing job to complete.');
                        ApexPages.addMessage(msg);
                } else {
                        AriaBatchProductFieldSync sync = new AriaBatchProductFieldSync(true);
                        Integer batchSize = AriaCustomSettingUtil.getSyncProductFieldBatchSize();
                        database.executebatch(sync,batchSize);
                }
        }
}