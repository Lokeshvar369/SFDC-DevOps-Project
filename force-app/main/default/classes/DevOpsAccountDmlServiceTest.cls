@IsTest
private class DevOpsAccountDmlServiceTest {
  @IsTest
  static void testCreateAccount() {
    Test.startTest();

    Account acc = DevOpsAccountDmlService.createAccount('Gearset Demo Account');

    Test.stopTest();

    System.assertNotEquals(
      null,
      acc.Id,
      'Created Account should have a Salesforce Id'
    );

    System.assertEquals(
      'Gearset Demo Account',
      acc.Name,
      'Created Account should retain the name supplied to the service'
    );
  }

  @IsTest
  static void testUpdateAccount() {
    Account acc = DevOpsTestDataFactory.createAccount('Original Account Name');

    insert acc;

    Test.startTest();

    Account updatedAccount = DevOpsAccountDmlService.updateAccount(
      acc.Id,
      'Updated Account Name'
    );

    Test.stopTest();

    System.assertEquals(
      'Updated Account Name',
      updatedAccount.Name,
      'Updated Account should contain the new name supplied to the update service'
    );
  }

  @IsTest
  static void testDeleteAccount() {
    Account acc = DevOpsTestDataFactory.createAccount('Account To Delete');

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
      accounts.size(),
      'Deleted Account should no longer be returned by the query'
    );
  }

  @IsTest
  static void testUpsertNewAccount() {
    Account acc = DevOpsTestDataFactory.createAccount('Upsert New Account');

    Test.startTest();

    Account result = DevOpsAccountDmlService.upsertAccount(acc);

    Test.stopTest();

    System.assertNotEquals(
      null,
      result.Id,
      'Upserted new Account should have a Salesforce Id'
    );

    System.assertEquals(
      'Upsert New Account',
      result.Name,
      'Newly upserted Account should retain the supplied name'
    );
  }

  @IsTest
  static void testUpsertExistingAccount() {
    Account acc = DevOpsTestDataFactory.createAccount(
      'Original Upsert Account'
    );

    insert acc;

    acc.Name = 'Updated Upsert Account';

    Test.startTest();

    Account result = DevOpsAccountDmlService.upsertAccount(acc);

    Test.stopTest();

    System.assertEquals(
      acc.Id,
      result.Id,
      'Upsert should update the existing Account instead of creating a new record'
    );

    System.assertEquals(
      'Updated Upsert Account',
      result.Name,
      'Existing Account should contain the updated name after upsert'
    );
  }

  @IsTest
  static void testCreateAccountsBulk() {
    List<String> accountNames = new List<String>();

    for (Integer i = 1; i <= 200; i++) {
      accountNames.add('Bulk Test Account ' + i);
    }

    Test.startTest();

    System.debug('DML statements before: ' + Limits.getDmlStatements());

    System.debug('SOQL queries before: ' + Limits.getQueries());

    List<Account> accounts = DevOpsAccountDmlService.createAccounts(
      accountNames
    );

    System.debug('DML statements after: ' + Limits.getDmlStatements());

    System.debug('SOQL queries after: ' + Limits.getQueries());

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
      accounts.size(),
      'Bulk creation should return all 200 requested Accounts'
    );

    System.assertNotEquals(
      null,
      accounts[0].Id,
      'Bulk-created Accounts should receive Salesforce record Ids'
    );
  }

  @IsTest
  static void testGetContactsForAccounts() {
    List<Account> accounts = DevOpsTestDataFactory.createAccounts(
      3,
      'Contact Test Account'
    );

    insert accounts;

    List<Contact> contacts = DevOpsTestDataFactory.createContacts(accounts);

    insert contacts;

    Set<Id> accountIds = new Set<Id>();

    for (Account acc : accounts) {
      accountIds.add(acc.Id);
    }

    Test.startTest();

    List<Contact> contacts = DevOpsAccountDmlService.getContactsForAccounts(
      accountIds
    );

    Test.stopTest();

    System.assertEquals(
      3,
      contacts.size(),
      'Service should return all three Contacts associated with the test Accounts'
    );

    for (Contact contact : contacts) {
      System.assert(
        accountIds.contains(contact.AccountId),
        'Returned Contact belongs to an unexpected Account'
      );
    }
  }

  @IsTest
  static void testGetAccountMap() {
    List<Account> accounts = DevOpsTestDataFactory.createAccounts(
      3,
      'Map Test Account'
    );

    insert accounts;

    Test.startTest();

    Map<Id, Account> accountMap = DevOpsAccountDmlService.getAccountMap(
      accounts
    );

    Test.stopTest();

    System.assertEquals(
      3,
      accountMap.size(),
      'Account Map should contain one entry for each supplied Account'
    );

    for (Account acc : accounts) {
      System.assert(
        accountMap.containsKey(acc.Id),
        'Account Id should exist in the Map'
      );

      System.assertEquals(
        acc.Name,
        accountMap.get(acc.Id).Name,
        'Account Map should return the correct Account for each Id'
      );
    }
  }
}
