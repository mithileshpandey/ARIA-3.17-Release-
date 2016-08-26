public with sharing class AriaAdminToolController {
    public string adminURL { get; private set; }
    public AriaAdminToolController (){
        AriaConfiguration configWithMapping  = AriaUtil.getLatestConfigWithMappings();
        if(configWithMapping == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'No Aria API configuration found.'));
            return;
        }
        Aria_API_Configuration__c config = configWithMapping.config;
        adminURL = config.Aria_Admin_Tool_URL__c;
    }
    /*
    public pagereference redirect(){
        PageReference pg = new PageReference(adminURL);
        pg.setRedirect(true);
        return pg;
    }*/
}