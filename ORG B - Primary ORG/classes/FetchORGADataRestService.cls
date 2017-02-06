/**
 * Rest Service to get SObject Records from ORG A
 * Re usable to fetch any SObject
 * Accepts query string and sobject record names as parameters
 * Queries sObject and return the matching rows
 * In case of error, error message is returned along with empty sObject List
 * Follows Named Credential authentication. Named credential is passed via a custom label
 */
public class FetchORGADataRestService{

    public static String sObjectRecordsNameString;
    public static String sobjectQueryString;
    
    public static SObjectRecordsRetreiveResponseWrapper fetchSObjectRecordsFromORGA(){
    
        SObjectRecordsRetreiveResponseWrapper wrapper = new SObjectRecordsRetreiveResponseWrapper();
        
        try{
            // End point which contains Named credential authentication
            String endPoint = system.Label.END_POINT_Get_SObject_Records_From_ORG_A;
            // If sObject Record Name String is passed, construct that imto a list, else queries all records in the system
            if(sObjectRecordsNameString != null && sObjectRecordsNameString != ''){
                endPoint+= 'sObjectRecordNameString=' + sObjectRecordsNameString + '&';
            }
            if(sobjectQueryString != null && sobjectQueryString != ''){
                endPoint+= 'queryString=' + sobjectQueryString;
            }
            // Prepare http request
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endPoint);
            req.setMethod('GET');
            Http http = new Http();
            
            // Make a rest call to ORG A
            HTTPResponse res = http.send(req);
            
            // Store the response back into a wrapper class
            wrapper = (SObjectRecordsRetreiveResponseWrapper)JSON.deserialize(res.getBody(),SObjectRecordsRetreiveResponseWrapper.class);
                
        }
        catch(Exception ex){
            // prepare dummy Response with error message and return to the caller
            wrapper.statusMessage = ex.getMessage();
            wrapper.sObjectList = new List<SObject>();
        }

        return wrapper;
    }
    
}