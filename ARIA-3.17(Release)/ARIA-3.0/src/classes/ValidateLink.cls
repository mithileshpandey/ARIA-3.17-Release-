global class ValidateLink implements IValidateLink{
     global void updateLink(Id linkId, boolean isValidated){
        update new Custom_Navigation_link__c(Id=linkId, IsValidate__c=isValidated);
     }
}