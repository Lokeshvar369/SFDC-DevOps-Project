/**
 * Provides reusable test data for DevOps tests.
 */
@IsTest
public class DevOpsTestDataFactory {
  /**
   * Creates an Account for testing.
   *
   * @param accountName Name for the Account.
   * @return An unsaved Account record.
   */
  public static Account createAccount(String accountName) {
    return new Account(Name = accountName);
  }

  /**
   * Creates multiple Accounts for testing.
   *
   * @param count Number of Accounts to create.
   * @param namePrefix Prefix used for Account names.
   * @return A list of unsaved Account records.
   */
  public static List<Account> createAccounts(Integer count, String namePrefix) {
    List<Account> accounts = new List<Account>();

    for (Integer i = 1; i <= count; i++) {
      accounts.add(createAccount(namePrefix + ' ' + i));
    }

    return accounts;
  }

  /**
   * Creates a Contact associated with an Account.
   *
   * @param accountId Account Id for the Contact.
   * @return An unsaved Contact record.
   */
  public static Contact createContact(Id accountId) {
    return new Contact(
      FirstName = 'Test',
      LastName = 'Contact',
      AccountId = accountId
    );
  }
}
