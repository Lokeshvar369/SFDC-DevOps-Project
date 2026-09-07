trigger CustomerFeedbackTrigger on Customer_Feedback__c(after insert) {
  console.log('CustomerFeedbackTrigger fired for records: ' + Trigger.new);
}
