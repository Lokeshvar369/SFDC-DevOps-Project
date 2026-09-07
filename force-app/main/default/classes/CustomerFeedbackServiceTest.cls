@IsTest
private class CustomerFeedbackServiceTest {
  @IsTest
  static void testCustomerFeedbackTrigger() {
    Customer_Feedback__c feedback = new Customer_Feedback__c();

    Test.startTest();

    insert feedback;

    Test.stopTest();

    Customer_Feedback__c savedFeedback = [
      SELECT Id, Name
      FROM Customer_Feedback__c
      WHERE Id = :feedback.Id
      LIMIT 1
    ];

    System.assertEquals(
      'DevOps Service',
      savedFeedback.Name,
      'Verify that the Customer Feedback record retains the expected Name after insertion.'
    );
  }
}
