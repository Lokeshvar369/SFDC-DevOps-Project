trigger CustomerFeedbackTrigger on Customer_Feedback__c(after insert) {
  CustomerFeedbackService.processFeedback(Trigger.new);
}
