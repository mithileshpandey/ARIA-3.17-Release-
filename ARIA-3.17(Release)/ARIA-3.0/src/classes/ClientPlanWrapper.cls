public class ClientPlanWrapper implements Comparable{
        
        public ClientPlanWrapper parent {get;set;}
        public string leftName { get; set; }
        public string selectedBillingInterval { get; set; }
        public string groupNo { get; set; }
        public boolean isGroupSelected { get; set; }
        //public string selectedPlan { get; set; }
        public map<string,string> optionLabel { get; set; }
        public List<ClientPlanWrapper> planInstances   { get; set; }
        public boolean isInstance {get;set;}
        public AriaClientPlanNode node { get; set; }
        public List<ClientPlanWrapper> children {get; set;}
        public integer maxCnt {get;set;} // for instance numbering .. earlier maxInstanceCount
        public integer idx {get;set;} //to keep track of index while adding and removing instances on UI
        //Created this variable to avoid the deployment 
        public string defSel { get; set; }
        public integer billingIntCnt {get;set;}
        public ClientPlanWrapper(){
                defSel ='0';
                billingIntCnt=0;
                node = new AriaClientPlanNode();
                children = new List<ClientPlanWrapper>();
                optionLabel = new map<string,string>();
                planInstances = new List<ClientPlanWrapper>();
                maxCnt=0;
                idx=0;
                isInstance = false;
                isGroupSelected = false;
                selectedBillingInterval ='1';
        }
        public ClientPlanWrapper(AriaClientPlanNode node){
            this();
            this.node = node;
            this.leftName = node.planName;
        }
        public ClientPlanWrapper(ClientPlanWrapper cpw){
             this();
             List<ClientPlanWrapper> tempList =new List<ClientPlanWrapper>();
             this.leftName = cpw.leftName;
             this.groupNo =  cpw.groupNo;
             this.isGroupSelected = cpw.isGroupSelected;
             //this.selectedPlan = cpw.selectedPlan;
             this.isInstance = cpw.isInstance;
             this.selectedBillingInterval = cpw.selectedBillingInterval;
             //this.node = cpw.node.clone();
             this.node = cloneNode(cpw.node); 
             //this.node = new AriaClientPlanNode(cpw.node); 
             for(ClientPlanWrapper child:cpw.children){
                ClientPlanWrapper tempWrapper = new ClientPlanWrapper();
                tempWrapper = new ClientPlanWrapper(child);
                tempWrapper.isGroupSelected = false;
                tempWrapper.planInstances = new List<ClientPlanWrapper>();
                tempList.add(tempWrapper);
             }
             this.children = tempList;
             this.optionLabel = cpw.optionLabel.clone();
             this.billingIntCnt = cpw.billingIntCnt;
        }
        /* Deprecated as now using Copy Constructor or AriaClientPlanNode(AriaClientPlanNode node) */
        public AriaClientPlanNode cloneNode(AriaClientPlanNode node){
            AriaClientPlanNode returnNode = node.clone();
            returnNode.services = returnNode.cloneService();
            return returnNode;
        }
        public Integer compareTo(Object compareTo) {
                
                ClientPlanWrapper compareToOppy = (ClientPlanWrapper)compareTo;
                        
                Integer returnValue = 0;
                if (leftName > compareToOppy.leftName) {
                    // Set return value to a positive value.
                    returnValue = 1;
                } else if (leftName < compareToOppy.leftName) {
                    // Set return value to a negative value.
                    returnValue = -1;
                }
        
                return returnValue;       
        }
        
        public List<ClientPlanWrapper> addChildPlan(ClientPlanWrapper plan, String groupNo) {
            plan.groupNo = groupNo;
            children.add(plan);
            return children;  
        }
         
    }