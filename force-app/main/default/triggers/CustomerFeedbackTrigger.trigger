trigger CustomerFeedbackTrigger on Customer_Feedback__c(after insert) {
  for (Customer_Feedback__c feedback : Trigger.new) {
    System.debug('TRIGGER FIRED: ' + feedback.Id);
  }
}
