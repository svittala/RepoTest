public class SalesQuoteVFController {

    public SalesQuoteVFController(ApexPages.StandardController c) {
    }

    public Flow.Interview.CreateSalesQuotation myFlow { get; set; }
    
    public String getmyID() {
        if (myFlow==null) {
            return '';
    
        } else {
            return (String)myFlow.getVariableValue('QuoteID');
    
        }
    }
    
    public PageReference getFinishLocation(){
        PageReference p = new PageReference('/' + getmyID());
        p.setRedirect(true);
        return p;
    }
}