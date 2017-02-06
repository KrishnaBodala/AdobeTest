/**
 * Account Trigger
 */
trigger AccountTrigger on Account (after insert) {
    /**
     * As a best practise there must be utility method which can read protected custom setting with disable flag on or not
     * and skips the trigger from running. For the purpose of eliminating complexity, didn't implement that logic
     */
    if(trigger.isInsert && Trigger.isAfter){
        AccountTriggerHandler.onAfterInsert(Trigger.new);
    }
}