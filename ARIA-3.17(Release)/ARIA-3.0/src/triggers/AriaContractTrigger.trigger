trigger AriaContractTrigger on Contract__c (before delete) {
    AriaTriggerHelper.deleteContractAssociatedRecords(trigger.old);
}