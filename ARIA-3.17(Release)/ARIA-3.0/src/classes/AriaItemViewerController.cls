public with sharing class AriaItemViewerController {
    
    private list<Aria_Items__c> items { get; private set; }
    private list<Aria_Items__c> itemsToDisplay;
    public integer totalRecords{get;set;}
    public Integer start{get;set;}
    public Integer ends{get;set;}
    private Integer pageNumber;
    private Integer newPageIndex;
    private Integer pageSize;
    private Integer totalPageNumber;
    public AriaItemViewerController(){
        pageNumber = 0;
        totalPageNumber = 0;
        pageSize = 10;// default page size
        totalRecords= 0;
        newPageIndex = 1;
        items = [SELECT Id,Name,Aria_Id__c,Item_Type__c,Client_SKU__c,Status__c,Stock_Level__c
            FROM Aria_Items__c where Status__c='Active'
            ];
        Paginator();
    }
    
    private void Paginator(){//Integer newPageIndex){
            itemsToDisplay = new list<Aria_Items__c>();
            totalRecords = items.size();
            Transient Integer counter = 0;
            Transient Integer min = 0;
            Transient Integer max = 0;
            max = newPageIndex * pageSize;
            min = max - pageSize; 
            for(Aria_Items__c t : items){
                counter++;
                if (counter > min && counter <= max){
                    itemsToDisplay.add(t);
                }
                if(counter > max){
                    break;
                }
            }
            start = min +1;
            ends = counter > max ? max : counter;
            pageNumber = newPageIndex;
            if (itemsToDisplay.size() <= 0){
                start = 0;
                ends = 0;
                pageNumber = 0;
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'NO Item Records Found..'));
            }
            
        }
        
        public Integer getPageNumber(){
            return pageNumber;
        }
        public Integer getPageSize(){
            return pageSize;
        }
        public void setPageSize(Integer pSize){
                decimal totpg = 0;
                totalRecords = items.size();
                if(totalRecords != 0){
                    totpg = totalRecords / pSize;
                    integer j = 0;
                    if(totpg == 0){
                        newPageIndex = 1;
                    }
                    for(integer i = 1; i <= totpg; i++){
                        j = 0;
                        j = (pSize * i)/start;
                        if(j >= 1){
                            newPageIndex = i;
                            break;
                        }else{
                            newPageIndex = 1;
                        }
                    }
                }
            this.pageSize = pSize;
            Paginator();
        }
        public List<Aria_Items__c> getcurItems(){
            //Paginator();
            return itemsToDisplay;
        }
        public Boolean getPreviousButtonDisabled(){ 
            return !(pageNumber > 1);
        }
        public Boolean getNextButtonDisabled(){
            if (totalRecords== 0){
                return true;
            }
            else{
                return ((pageNumber * pageSize) >= totalRecords);
            }
        }
        public Integer getTotalPageNumber(){
            //if (totalPageNumber == 0 && totalRecords>0){
                totalPageNumber = totalRecords / pageSize;
                Integer mod = totalRecords - (totalPageNumber * pageSize);
                if (mod > 0)
                totalPageNumber++;
            //}
            return totalPageNumber;
        }
        
        public PageReference nextBtnClick() {
            newPageIndex = pageNumber + 1;
            Paginator();
            return null;
        }
        public PageReference previousBtnClick() {
            newPageIndex = pageNumber - 1;
            Paginator();
            return null;
        }
        public PageReference firstBtnClick() {
            newPageIndex = 1;
            Paginator();
            return null;
        }
        public PageReference lastBtnClick() {
            newPageIndex = totalPageNumber;
            Paginator();
            return null;
        }
        /* Methods End*/ 
    
}