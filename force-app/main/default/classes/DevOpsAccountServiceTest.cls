@IsTest
private class DevOpsAccountServiceTest {

    @TestSetup
    static void createTestData() {

        Account acc = new Account(
            Name = 'DevOps Test Account'
        );

        insert acc;
    }

    @IsTest
    static void testGetAccounts() {

        Test.startTest();

        List<Account> accounts =
            DevOpsAccountService.getAccounts();

        Test.stopTest();

        System.assert(
            accounts.size() > 0,
            'Expected at least one Account'
        );
    }
}
