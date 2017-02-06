/**
 * Account Trigger Handler
 */
public with sharing class AccountTriggerHandler{
    /**
     * After Insert handler for Account trigger
     */
    public static void onAfterInsert(List<Account> newAccountsList){
        // Find matching Accounts in ORG A based on Account Name
        findMatchingAccountsInORGA(newAccountsList);
    }
    
    /**
     * 1 - Prepares a set of account names and set of account Ids and calls future method.
     * 2-  Future method makes a call out to ORG A and returns if any matching accounts found
     */
    public static void findMatchingAccountsInORGA(List<Account> newAccountsList){
        String accountNameStrings = '';
        Set<Id> accountIdSet = new Set<Id>();
        for(Account a :newAccountsList){
            accountNameStrings+= a.Name + ';';
            accountIdSet.add(a.Id);
        }
        doCallOutToORGA(accountNameStrings, accountIdSet);
    }
    
    /**
     * 1 - Do a call out to ORG A to find matching accounts
     * 2 - For Matching accounts, update the Account number from ORG A into Matching_ORG_A_Account__c field
     * 3 - If there are errors, call re usable utility method which logs the error in custom object
     * 4 - To eliminate complexity, didn't create custom object / re usable utility method to log errors
     */
    @future(callout=true)
    public static void doCallOutToORGA(String acctNameString, Set<Id> accountIdSet){
        try{
             // Perform a callout to an external service
            acctNameString = acctNameString.replace(' ', '+'); 
            FetchORGADataRestService.sobjectQueryString = System.Label.Query_Accounts;
            FetchORGADataRestService.sObjectRecordsNameString = acctNameString;
                
            SObjectRecordsRetreiveResponseWrapper res = FetchORGADataRestService.fetchSObjectRecordsFromORGA();
            // Loop thru the matching accounts and prepare a map of account name to account record
            Map<String, Account> accountMap = new Map<String, Account>();
            for(Account a :(List<Account>)res.sObjectList){
                accountMap.put(a.Name, a);
            }
            // If there matching account names found, update the corresponding account number into Matching_ORG_A_Account__c field
            if(accountMap.keySet().size() > 0){
                List<Account> accountList = new List<Account>();
                for(Account a : [SELECT Name, Id, Matching_ORG_A_Account__c FROM Account WHERE Id IN :accountIdSet]){
                    if(accountMap.containsKey(a.Name) ){
                        a.Matching_ORG_A_Account__c = accountMap.get(a.Name).AccountNumber;
                        accountList.add(a);
                    }
                }
                // Do DML if there is an account to be updated
                if(accountList.size() > 0){
                    List<Database.SaveResult> result = Database.update(accountList, false);
                    for (Database.SaveResult sr : result) {
                        if(!sr.isSuccess() ){
                            // Prepare a error List to be inserted into custom Error Log Object
                        }
                    }
                }
            }
        }
        catch(Exception ex){
            // Call re usable utility method to log error into a custom object
            // Custom object stores complete error details including full stack trace of error messages
            // Usually there will be work flow email alerts on that custom objects to notify the system admin
        }
    }

}