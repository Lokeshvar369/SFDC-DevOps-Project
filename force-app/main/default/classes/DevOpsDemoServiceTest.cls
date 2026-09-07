@IsTest
private class DevOpsDemoServiceTest {
  @IsTest
  static void testGetMessage() {
    Test.startTest();

    String result = DevOpsDemoService.getMessage();

    Test.stopTest();

    System.assertEquals(
      'Hello from Salesforce DevOps',
      result,
      'Verify that getMessage returns the expected Salesforce DevOps message.'
    );
  }
}
