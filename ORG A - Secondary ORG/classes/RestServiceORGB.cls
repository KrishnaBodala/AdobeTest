/**
 * 1 - Rest WebService in ORG A which reads any sObject Records
 * 2 - Accepts the sObject Query String, SObject Name Filters
 * 3 - If Name filter is not applied, return all the records for the sObject.
 * 4 - If there is any error, return empty sObject List along with error Message
 * 5 - Uses HTTP Get method
 */
@RestResource(urlMapping='/FetchSObjectRecordsFromORGA')
global class RestServiceORGB {

    @HttpGet
    global static SObjectRecordsRetreiveResponseWrapper getSObjectRecords() {
    
        List<SObject> toBeReturnedSObjectRecordsList = new List<SObject>();
        SObjectRecordsRetreiveResponseWrapper wrapper = new SObjectRecordsRetreiveResponseWrapper();
        
        try{
            List<String> recordNameList = new List<String>();
            String query;
            
            RestRequest req = RestContext.request;
            if(req.params != null && req.params.keySet().size() > 0){
                String recordNameString = req.params.get('sObjectRecordNameString');
                if(recordNameString != null && recordNameString != ''){
                    recordNameList = recordNameString.split(';');
                }
                query = req.params.get('queryString');
            }
            query = (query != null && recordNameList.size() > 0) ? query + ' WHERE NAME IN :recordNameList' : query;
            query+= ' LIMIT 50000';
            
            toBeReturnedSObjectRecordsList = Database.query(query);
            wrapper.statusMessage = 'Success';
        }
        catch(exception ex){
            wrapper.statusMessage = ex.GetMessage();
        }
        wrapper.sObjectList = toBeReturnedSObjectRecordsList;

        return wrapper;
    }
}