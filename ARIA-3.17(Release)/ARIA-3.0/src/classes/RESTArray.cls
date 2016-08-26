public with sharing class RESTArray {
    private List<String> strList { get; set; }
    
    public String restArrayString { get; private set; }
    
    public RESTArray(List<String> strList) {
        this.strList = strList;
        buildList();
    }
    
    
    private void buildList() {
        restArrayString = '';
        
        if(strList.size() > 0) {
            restArrayString = strList[0];
            
            for(Integer i = 1; i < strList.size(); i++) {
                restArrayString += '|' + strList[i];
            }
        }
    }
    
   
}