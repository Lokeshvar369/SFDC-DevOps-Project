@IsTest
private class DevOpsAccountDmlServiceTest {

    @IsTest
    static void testCreateAccount() {

        Test.startTest();

        Account acc =
            DevOpsAccountDmlService.createAccount(
                'Gearset Demo Account'
            );

        Test.stopTest();

        System.assertNotEquals(
            null,
            acc.Id
        );

        System.assertEquals(
            'Gearset Demo Account',
            acc.Name
        );
    }

    @IsTest
    static void testUpdateAccount() {

        Account acc = new Account(
            Name = 'Original Account Name'
        );

        insert acc;

        Test.startTest();

        Account updatedAccount =
            DevOpsAccountDmlService.updateAccount(
                acc.Id,
                'Updated Account Name'
            );

        Test.stopTest();

        System.assertEquals(
            'Updated Account Name',
            updatedAccount.Name
        );
    }

    @IsTest
    static void testDeleteAccount() {

        Account acc = new Account(
            Name = 'Account To Delete'
        );

        insert acc;

        Test.startTest();

        DevOpsAccountDmlService.deleteAccount(acc.Id);

        Test.stopTest();

        List<Account> accounts = [
            SELECT Id
            FROM Account
            WHERE Id = :acc.Id
        ];

        System.assertEquals(
            0,
            accounts.size()
        );
    }

    @IsTest
    static void testUpsertNewAccount() {

        Account acc = new Account(
            Name = 'Upsert New Account'
        );

        Test.startTest();

        Account result =
            DevOpsAccountDmlService.upsertAccount(acc);

        Test.stopTest();

        System.assertNotEquals(
            null,
            result.Id
        );

        System.assertEquals(
            'Upsert New Account',
            result.Name
        );
    }

    @IsTest
    static void testUpsertExistingAccount() {

        Account acc = new Account(
            Name = 'Original Upsert Account'
        );

        insert acc;

        acc.Name = 'Updated Upsert Account';

        Test.startTest();

        Account result =
            DevOpsAccountDmlService.upsertAccount(acc);

        Test.stopTest();

        System.assertEquals(
            acc.Id,
            result.Id
        );

        System.assertEquals(
            'Updated Upsert Account',
            result.Name
        );
    }

    @IsTest
    static void testCreateAccountsBulk() {

        List<String> accountNames = new List<String>();

        for (Integer i = 1; i <= 200; i++) {
            accountNames.add('Bulk Test Account ' + i);
        }

        Test.startTest();

        System.debug(
            'DML statements before: ' +
            Limits.getDmlStatements()
        );

        System.debug(
            'SOQL queries before: ' +
            Limits.getQueries()
        );

        List<Account> accounts =
            DevOpsAccountDmlService.createAccounts(accountNames);

        System.debug(
            'DML statements after: ' +
            Limits.getDmlStatements()
        );

        System.debug(
            'SOQL queries after: ' +
            Limits.getQueries()
        );

        System.assertEquals(
            1,
            Limits.getDmlStatements(),
            'Bulk creation should use one DML statement'
        );

        System.assertEquals(
            0,
            Limits.getQueries(),
            'Bulk creation should not use SOQL'
        );

        Test.stopTest();

        System.assertEquals(
            200,
            accounts.size()
        );

        System.assertNotEquals(
            null,
            accounts[0].Id
        );
    }

    @IsTest
    static void testGetContactsForAccounts() {

        List<Account> accounts = new List<Account>();

        for (Integer i = 1; i <= 3; i++) {
            accounts.add(
                new Account(
                    Name = 'Contact Test Account ' + i
                )
            );
        }

        insert accounts;

        List<Contact> contactsToCreate = new List<Contact>();

        for (Account acc : accounts) {
            contactsToCreate.add(
                new Contact(
                    FirstName = 'Test',
                    LastName = 'Contact',
                    AccountId = acc.Id
                )
            );
        }

        insert contactsToCreate;

        List<Id> accountIds = new List<Id>();

        for (Account acc : accounts) {
            accountIds.add(acc.Id);
        }

        Test.startTest();

        List<Contact> contacts =
            DevOpsAccountDmlService.getContactsForAccounts(accountIds);

        Test.stopTest();

        System.assertEquals(
            3,
            contacts.size()
        );

        for (Contact contact : contacts) {
            System.assert(
                accountIds.contains(contact.AccountId),
                'Returned Contact belongs to an unexpected Account'
            );
        }
    }
}
