public class RefreshedContractsFromAria{
        public Contract__c contract;
        public list<Contract_Plan_Relationship__c> plans;
        public RefreshedContractsFromAria(){
            contract = new Contract__c();
            plans   = new list<Contract_Plan_Relationship__c>();
        }
        public RefreshedContractsFromAria(Contract__c c,list<Contract_Plan_Relationship__c> cpr){
            this.contract = c;
            this.plans  = cpr;
        }
       
 }