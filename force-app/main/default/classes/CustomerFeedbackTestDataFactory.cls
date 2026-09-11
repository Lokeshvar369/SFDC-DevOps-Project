/**
 * Builds Customer Feedback records for unit tests.
 */
@IsTest
public class CustomerFeedbackTestDataFactory {
  /**
   * Builds a Customer Feedback record without inserting it.
   *
   * @return A Customer Feedback record suitable for test setup.
   */
  public static Customer_Feedback__c buildCustomerFeedback() {
    // Add required fields here if validation rules change.
    return new Customer_Feedback__c();
  }
}
