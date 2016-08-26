/**********************************************************************
Name:  AriaAPIUtill
Copyright  2014  Aria
============================================================================================================
Purpose:                                                           
-------  
This is basically keep all common methods which is coming in use at the time when any api call getting prepared.                                    
============================================================================================================
History                                                           
-------                                                           
 AUTHOR                     DATE              DEVELOPER NAME                       
 - Simplion Technologies    03/06/2014        Dileep Singhal        
 
***********************************************************************/

public with sharing class AriaAPIUtill {
    
    public static String ARIA_NULL_VALUE = '~';
    // to check here if parameter have null value then supress it to in api.
    public static Map<String, String> isNullBlankCheck(String input_var, string input_val, Map<String, String> prms){
        if(input_val != null && input_val != ''){
            prms.put(input_var, input_val);
        }
        return prms;
    }
    
    public static integer error_cd ;
    public static string error_msg = ''; 
    public static void validateResponse(WDDXData data){
        error_cd = 0;
        error_msg = 'OK'; 
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        error_cd = getIntVal(mainStruct.get('error_code'));
        error_msg = getStrVal(mainStruct.get('error_msg'));
        if(error_msg == null){
            error_msg = 'Aria did not return an error message';
        }
    }
    public static string getAriaCompatibleValue(string paramToConvert, string paramType){
        if(paramToConvert == null){
              return ARIA_NULL_VALUE;// return '~'
        }
        if(paramType != null && paramType.equalsIgnoreCase('Phone')){
            return AriaUtilEOM.getPhoneNumber(paramToConvert);
        }
        return paramToConvert;
    }
    // New Method introduce to reduce the characters or size of apex class
    // Checks for WDDXArray Elements
    public static boolean hasRecords(WDDXVariable var){
        boolean val = false;
        if(var!= null && var.item != WDDXNull.NIL){
                val = true;
        }
        return val; 
    }
    public static WDDXArray getArray(WDDXVariable var){
        if(var!= null && var.item != WDDXNull.NIL){
                return (WDDXArray)var.item;
        }
        return null; 
    }  
    public static Integer getIntVal(WDDXVariable var){
        Integer val = null;
        if(var!= null && var.item != WDDXNull.NIL){
                val = ((WDDXNumber)var.item).numValue.intValue();
        }
        return val;
    }
    public static Double getDoubVal(WDDXVariable var){
        Double val = null;
        if(var!= null && var.item != WDDXNull.NIL){
                val = ((WDDXNumber)var.item).numValue;
        }
        return val;
    }
    public static decimal getDeciVal(WDDXVariable var){
        decimal val = null;
        if(var!= null && var.item != WDDXNull.NIL){
                val = decimal.valueOf(((WDDXNumber)var.item).numValue);
        }
        return val;
    }
    public static long getLongVal(WDDXVariable var){
        long val = null;
        if(var!= null && var.item != WDDXNull.NIL){
                val = ((WDDXNumber)var.item).numValue.longValue();
        }
        return val;
    }
    public static String getStrVal(WDDXVariable var){
        String val = null;
        if(var!= null && (var.item != WDDXNull.NIL)){
                //system.debug(LoggingLevel.INFO, '----Mithilesh-var.item-----'+var.item );
                val = ((WDDXString)var.item).strValue;
        }
        if(val!=null){
            val.trim();
        }
        return val;
    }
    
    public static String getBoolVal(WDDXVariable var){
        String val = null;
        if(var!= null && var.item != WDDXNull.NIL){
                val = ((WDDXBoolean)var.item).boolValue;
        }
        if(val!=null){
            val.trim();
        }
        return val;
    }
    public static long convertStringToLong(WDDXVariable var){
        long valToReturn;
        try{
             valToReturn = getLongVal(var);
        }catch(Exception e){
            String fieldValStr = getStrVal(var);
            if(String.isNotBlank(fieldValStr)){
                try{
                    valToReturn = long.ValueOf(fieldValStr);
                }catch(Exception ex){
                    AriaUtil.logAriaError(ex.getMessage()+'\n'+ex.getStackTraceString(), 'Error');
                }
            }
        }
        return valToReturn;
    }
    
    public static Double convertStringToDouble(WDDXVariable var){
        double valToReturn;
        try{
             valToReturn = getDoubVal(var);
        }catch(Exception e){
            String fieldValStr = getStrVal(var);
            if(String.isNotBlank(fieldValStr)){
                try{
                    valToReturn = Double.ValueOf(fieldValStr);
                }catch(Exception ex){
                    AriaUtil.logAriaError(ex.getMessage()+'\n'+ex.getStackTraceString(), 'Error');
                }
            }
        }
        return valToReturn;
    }
    
    //SFDC - 137
    public static boolean isPicklistEnabledOrg(){
        Map<String, Schema.SObjectField> M = Schema.SObjectType.Contact.fields.getMap();
        if(M.containsKey('MailingCountryCode')){
            return true;
        }else{
            return false;
        }   
      }
      
      
      //SFDC - 137
      public static String getContactInformation(boolean picklistEnabled){
        String query = 'Select id,FirstName,LastName,AccountId,Salutation,Aria_Work_Phone_Extension__c,Aria_Company_Name__c,Aria_International_Phone__c,Phone,MobilePhone,MailingCountry,MailingState,Email,MailingCity,HomePhone,MailingStreet,MailingPostalCode';
        if(picklistEnabled){
            query += ',MailingCountryCode,MailingStateCode';
        }
        query += ' From Contact';
        return query;
      }
      
      
      public static CountryStateName getCountryStateNames(boolean picklistEnabled){
            CountryStateName csobj = new CountryStateName(picklistEnabled);
            return csobj;
            
      }
      
      public class CountryStateName{
            public string CountryAPIName {get;set;}
            public string StateAPIName {get;set;}
            
            public CountryStateName(boolean picklistEnabled){
                if(picklistEnabled){
                    this.CountryAPIName = 'MailingCountryCode';
                    this.StateAPIName = 'MailingStateCode';
                }else{
                    this.CountryAPIName = 'MailingCountry';
                    this.StateAPIName = 'MailingState';
                }
            }
      }
    
    public static long getRecordLimit(){
       return AriaCustomSettingUtil.getAriaRecordLimit();
   }
    
   public static String getAriaCompatibleDate(Date inputDate){
        if(inputDate == null){
            return ''; 
        }
        Datetime dt = inputDate;
        return dt.format('yyyy-MM-dd');
    } 
}