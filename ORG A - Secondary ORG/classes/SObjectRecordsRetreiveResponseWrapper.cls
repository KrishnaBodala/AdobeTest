/**
 * Response class to send the results of REST Service Call To ORG A FROM ORG B
 * Used generic sObject to capture the records which makes it reusable for any sobject
 */
global class SObjectRecordsRetreiveResponseWrapper{
    public List<SObject> sObjectList;
    public String statusMessage;
}