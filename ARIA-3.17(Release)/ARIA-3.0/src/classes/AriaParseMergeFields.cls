public with sharing class AriaParseMergeFields {
    
    public static string getRedirectURL(String oppID, String acctID){
        String redirectURL = null;
        try{
        	String urlWithMergFields =AriaUtilEOM.getRedirectURL();//get it from Util Method
	        //urlWithMergFields = '/apex/DummyPageForAdmin?acctID={!Account.Id}&invalidField={!Account.myfield__c}&acctName={!Account.Name}&ID={!Opportunity.ID}&OppName={!Opportunity.Name}&anotherInvalidField={!Opportunity.field1}';
	        String testStrToMatch = urlWithMergFields;
	        urlWithMergFields= urlWithMergFields;
	        if(urlWithMergFields!=null && urlWithMergFields!=''){
	            //oppID = '0061a00000G1VFWAA3';
	            //acctID='0011a00000VxB1e';
	            String regex = '(\\{![a-zA-Z0-9_.]*\\.[a-zA-Z0-9_]*})';
	            // First, instantiate a new Pattern object "MyPattern"
	            Pattern MyPattern = Pattern.compile(regex);
	            
	            // Then instantiate a new Matcher object "MyMatcher"
	            
	            Matcher m = MyPattern.matcher(urlWithMergFields);
	            //Map to store fieldNames objectwise.
	            Map<String,Set<String>> objFieldMap = new Map<String,Set<String>>();
	            
	            Map<String,String> oldValvsNewVal = new Map<String,String>();
	            
	            while(m.find()){
	                String mergeField = m.group();
	                oldValvsNewVal.put(mergeField,''); // override value after fetching val from DB
	                
	                String str = mergeField.subString(2, mergeField.indexOf('}'));
	                //system.debug(loggingLevel.INFO, '====='+str);
	                String [] arr = str.split('\\.');
	                //system.debug(loggingLevel.INFO, '====='+arr);
	                String objName = arr[0];
	                String fieldName = arr[1];
	                try{
	                	// below line should not be under loop - create field map only with account association
	                    Map <String, Schema.SObjectField> objFieldsMap = AriaMetadataServices.getFieldsmap(new List<String>{objName});
	                    if(AriaMetadataServices.fieldExists(objFieldsMap,fieldName)){
	                        if(objFieldMap.containsKey(objName)){
	                            objFieldMap.get(objName).add(fieldName);
	                        }else{
	                            objFieldMap.put(objName, new Set<String>{fieldName});
	                        }
	                    }
	                    
	                }catch(Exception e){
	                    System.debug(LoggingLevel.ERROR,'Exception Occurred while parsing one of the merge field from redirectURL:\n'+e);
	                }
	            }
	            for(String obj : objFieldMap.keySet()){
	                Set<String> fieldsToQuery = objFieldMap.get(obj);
	                String queryString='select ';
	                for(String fld : fieldsToQuery){
	                    queryString+=fld+',';
	                }
	                queryString = queryString.subString(0,queryString.lastIndexOf(',')); //to remove an extra , added in last
	                
	                queryString+=' from '+obj;
	                if(obj.equalsIgnoreCase('Opportunity')){
	                    queryString+=' where id=:oppID';
	                }else if(obj.equalsIgnoreCase('Account')){
	                    queryString+=' where id=:acctID';
	                }
	                System.debug(LoggingLevel.Info,'********queryString='+queryString); 
	                if(obj.equalsIgnoreCase('Opportunity')){
	                    List<Opportunity> oppList = Database.query(queryString);
	                    for(String fld : fieldsToQuery){
	                        String fldVal  = String.ValueOf(oppList[0].get(fld));
	                        System.debug(LoggingLevel.Info,'********fld = fldVal='+fld+'='+fldVal);
	                        if(string.isNotBlank(fldVal)){
	                        	oldValvsNewVal.put('{!'+obj+'.'+fld+'}',fldVal);  
	                        }  
	                    }
	                }else if(obj.equalsIgnoreCase('Account')){
	                    List<Account> acctList = Database.query(queryString);
	                    for(String fld : fieldsToQuery){
	                        String fldVal  = String.ValueOf(acctList[0].get(fld));
	                        System.debug(LoggingLevel.Info,'********fld = fldVal='+fld+'='+fldVal);
	                        if(string.isNotBlank(fldVal)){
	                        	oldValvsNewVal.put('{!'+obj+'.'+fld+'}',fldVal);    
	                        }
	                    }
	                }
	                    
	            }
	            System.debug(LoggingLevel.Info,'********objFieldMap='+objFieldMap); 
	            System.debug(LoggingLevel.Info,'********oldValvsNewVal='+oldValvsNewVal);   
	            string tempStr;
	            for(String key : oldValvsNewVal.keySet()){
	                String newVal = oldValvsNewVal.get(key);
	                key = '\\'+key;
	                tempStr = urlWithMergFields.replaceAll(key,newVal);
	                urlWithMergFields = tempStr;
	                //System.debug(LoggingLevel.Info,'********tempStr='+tempStr);
	                //System.debug(LoggingLevel.Info,'******Key='+key);
	                //System.debug(LoggingLevel.Info,'******newVal='+newVal);
	            }
	            //System.debug(LoggingLevel.Info,'********tempStr='+tempStr); 
	            //System.debug(LoggingLevel.Info,'********testStrToMatch='+testStrToMatch);   
	            //System.debug(LoggingLevel.Info,'********urlWithMergFields='+urlWithMergFields); 
	            //urlWithMergFields = tempStr;
	            
	        }
        	redirectURL = urlWithMergFields;
        }catch(Exception ex){
        	System.debug(LoggingLevel.ERROR,'Exception Occurred while parsing merge fields from redirectURL:\n'+ex.getStackTraceString());
        	redirectURL=null;
        }
        
        return redirectURL;
    }

}