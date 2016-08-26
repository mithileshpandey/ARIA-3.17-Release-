public with sharing class mandatoryLinkController {

    public PageReference saveLink() {
        string linkId = apexPages.currentPage().getParameters().get('recId');
        if(string.isNotBlank(linkId)){
            ValidateLink link = new ValidateLink();
            link.updateLink(linkId, true);
        }
        return null;
    }

}