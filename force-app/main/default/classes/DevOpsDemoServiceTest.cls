@IsTest
private class DevOpsDemoServiceTest {

    @IsTest
    static void testGetMessage() {
        Test.startTest();

        String result = DevOpsDemoService.getMessage();

        Test.stopTest();

        System.assertEquals(
            'Hello from Salesforce DevOps',
            result
        );
    }
}
