/**
 * Fetch Accounts from ORG A controller Extension
 * Makes a Call out to ORG A to get all accounts in the system.
 * If there is any error, shows on the screen via addMessage 
 * If there are accounts found, shows the matching accounts in the screen.
 * Standard Set Controller used for pagination with page size of 10
 */
public with sharing class FetchAccountsFromORGAExtension{
    // Getter Setter variables
    public List<Account> accountsList;
    Public Integer noOfRecords{get; set;}
    // Getter Setter for Standard Set Controller
    public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) {
                if(accountsList != null && accountsList.size() > 0){          
                    setCon = new ApexPages.StandardSetController(accountsList);
                }
                else{
                    setCon = new ApexPages.StandardSetController(new List<Account>());
                }
                setCon.setPageSize(10);  
                noOfRecords = setCon.getResultSize();
            }            
            return setCon;
        }
        set;
    }
    // Getter Setter variable for storing matching Accounts List
    public List<Account> getaccountsListToLoop() {
         return (List<Account>)setCon.getRecords();
    }
    // Constructor
    public FetchAccountsFromORGAExtension(ApexPages.StandardController stdController){
        accountsList = new List<Account>();
        fetchAccountsFromORGA(); 
    }
    /**
     * 1 - Make a call out to ORG A and fetch matching accounts if any
     * 2 - Dynamically Sets account query via custom label
     * 3 - If call out fails for any reason, capture the error message on the screen
     */    
    public void fetchAccountsFromORGA(){
        try{
            FetchORGADataRestService.sobjectQueryString = System.Label.Query_Accounts;
            FetchORGADataRestService.sObjectRecordsNameString = '';
                
            SObjectRecordsRetreiveResponseWrapper res = FetchORGADataRestService.fetchSObjectRecordsFromORGA();
            
            accountsList = new List<Account>();
            for(Account a : (List<Account>)res.sObjectList ){
                accountsList.add(a);
            }
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getMEssage()));
        }
    }
}