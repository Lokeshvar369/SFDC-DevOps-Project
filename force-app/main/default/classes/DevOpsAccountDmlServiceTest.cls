@IsTest
private class DevOpsAccountDmlServiceTest {
  @IsTest
  static void testCreateAccount() {
    Test.startTest();

    Account acc = DevOpsAccountDmlService.createAccount('Gearset Demo Account');

    Test.stopTest();

    // Verify the service successfully inserted the Account and Salesforce assigned an Id.
    System.assertNotEquals(null, acc.Id);

    // Verify the service preserved the Account name supplied by the caller.
    System.assertEquals('Gearset Demo Account', acc.Name);
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

    // Verify the update operation changed the Account to the requested name.
    System.assertEquals('Updated Account Name', updatedAccount.Name);
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

    // Verify the delete operation removed the Account from the database.
    System.assertEquals(0, accounts.size());
  }

  @IsTest
  static void testUpsertNewAccount() {
    Account acc = DevOpsTestDataFactory.createAccount('Upsert New Account');

    Test.startTest();

    Account result = DevOpsAccountDmlService.upsertAccount(acc);

    Test.stopTest();

    // Verify the upsert created a new Account and Salesforce assigned an Id.
    System.assertNotEquals(null, result.Id);

    // Verify the newly created Account retained the supplied name.
    System.assertEquals('Upsert New Account', result.Name);
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

    // Verify the upsert updated the existing record rather than creating a new record.
    System.assertEquals(acc.Id, result.Id);

    // Verify the existing Account received the updated name.
    System.assertEquals('Updated Upsert Account', result.Name);
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

    // Verify bulk creation uses a single DML statement to remain governor-limit efficient.
    System.assertEquals(
      1,
      Limits.getDmlStatements(),
      'Bulk creation should use one DML statement'
    );

    // Verify bulk creation does not execute unnecessary SOQL queries.
    System.assertEquals(
      0,
      Limits.getQueries(),
      'Bulk creation should not use SOQL'
    );

    Test.stopTest();

    // Verify every requested Account was created.
    System.assertEquals(200, accounts.size());

    // Verify Salesforce assigned an Id to the created Accounts.
    System.assertNotEquals(null, accounts[0].Id);
  }

  @IsTest
  static void testGetContactsForAccounts() {
    List<Account> accounts = DevOpsTestDataFactory.createAccounts(
      3,
      'Contact Test Account'
    );

    insert accounts;

    List<Contact> contactsToCreate = new List<Contact>();

    for (Account acc : accounts) {
      contactsToCreate.add(DevOpsTestDataFactory.createContact(acc.Id));
    }

    insert contactsToCreate;

    Set<Id> accountIds = new Set<Id>();

    for (Account acc : accounts) {
      accountIds.add(acc.Id);
    }

    Test.startTest();

    List<Contact> contacts = DevOpsAccountDmlService.getContactsForAccounts(
      accountIds
    );

    Test.stopTest();

    // Verify the service returns all Contacts associated with the supplied Accounts.
    System.assertEquals(3, contacts.size());

    for (Contact contact : contacts) {
      // Verify every returned Contact belongs to one of the requested Accounts.
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

    // Verify the Map contains one entry for every supplied Account.
    System.assertEquals(3, accountMap.size());

    for (Account acc : accounts) {
      // Verify each Account Id was correctly used as a Map key.
      System.assert(
        accountMap.containsKey(acc.Id),
        'Account Id should exist in the Map'
      );

      // Verify the Map returns the correct Account for each Id.
      System.assertEquals(acc.Name, accountMap.get(acc.Id).Name);
    }
  }
}
