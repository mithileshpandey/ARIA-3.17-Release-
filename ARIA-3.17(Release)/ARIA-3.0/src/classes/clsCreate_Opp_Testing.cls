public class clsCreate_Opp_Testing{
    public clsCreate_Opp_Testing(){
    
    }
    
    public pagereference CreateOppandRedirect(){
        Account act=new Account();
        act.Name=UserInfo.getFirstName()+'-'+DateTime.Now();
        insert act;
        
        //Create Opp
        Opportunity opp=new Opportunity ();
        opp.Name=act.Name;
        opp.Closedate=date.Today().Adddays(30);
        Opp.StageName='Prospecting';
        Opp.AccountId=act.id;
        insert opp;
        
        PageReference pageRef = new PageReference('/'+opp.id);

        return pageRef ;
        
    }
}