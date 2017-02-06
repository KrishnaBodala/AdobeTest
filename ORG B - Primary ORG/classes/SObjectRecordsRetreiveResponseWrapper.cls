/**
 * Response class to store the results of REST Service Call To ORG A
 * Used generic sObject to capture the records which makes it reusable for any sobject
 */
public class SObjectRecordsRetreiveResponseWrapper{
    public List<SObject> sObjectList{get;set;}
    public String statusMessage{get;set;}
}