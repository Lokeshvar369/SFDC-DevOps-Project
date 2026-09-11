/**
 * Provides Account DML operations and bulkified Account/Contact access examples.
 */
public with sharing class DevOpsAccountDmlService {
  /**
   * Thrown when an Account insert fails.
   */
  public class AccountInsertException extends Exception {
  }

  /**
   * Thrown when an Account update fails.
   */
  public class AccountUpdateException extends Exception {
  }

  /**
   * Thrown when an Account deletion fails.
   */
  public class AccountDeleteException extends Exception {
  }

  /**
   * Thrown when an Account upsert fails.
   */
  public class AccountUpsertException extends Exception {
  }

  /**
   * Thrown when a bulk Account insert fails.
   */
  public class AccountBulkInsertException extends Exception {
  }

  /**
   * Creates an Account with the supplied name.
   *
   * @param accountName Name of the Account to create.
   * @return The newly created Account.
   * @throws AccountInsertException If the Account insert fails.
   */
  public static Account createAccount(String accountName) {
    Account acc = new Account(Name = accountName);

    try {
      Database.insert(acc, AccessLevel.USER_MODE);
    } catch (DmlException e) {
      throw new AccountInsertException(
        'Unable to create Account: ' + e.getMessage()
      );
    }

    return acc;
  }

  /**
   * Updates the name of an existing Account.
   *
   * @param accountId Id of the Account to update.
   * @param newName New Account name.
   * @return The updated Account.
   * @throws AccountUpdateException If the Account update fails.
   */
  public static Account updateAccount(Id accountId, String newName) {
    Account acc = [
      SELECT Id, Name
      FROM Account
      WHERE Id = :accountId
      WITH USER_MODE
      LIMIT 1
    ];

    acc.Name = newName;

    try {
      Database.update(acc, AccessLevel.USER_MODE);
    } catch (DmlException e) {
      throw new AccountUpdateException(
        'Unable to update Account ' + accountId + ': ' + e.getMessage()
      );
    }

    return acc;
  }

  /**
   * Deletes an Account by Id.
   *
   * @param accountId Id of the Account to delete.
   * @throws AccountDeleteException If the Account deletion fails.
   */
  public static void deleteAccount(Id accountId) {
    Account acc = [
      SELECT Id
      FROM Account
      WHERE Id = :accountId
      WITH USER_MODE
      LIMIT 1
    ];

    try {
      Database.delete(acc, AccessLevel.USER_MODE);
    } catch (DmlException e) {
      throw new AccountDeleteException(
        'Unable to delete Account ' + accountId + ': ' + e.getMessage()
      );
    }
  }

  /**
   * Inserts or updates an Account based on its Id.
   *
   * @param accountRecord Account record to insert or update.
   * @return The inserted or updated Account.
   * @throws AccountUpsertException If the Account upsert fails.
   */
  public static Account upsertAccount(Account accountRecord) {
    try {
      Database.upsert(accountRecord, AccessLevel.USER_MODE);
    } catch (DmlException e) {
      throw new AccountUpsertException(
        'Unable to upsert Account: ' + e.getMessage()
      );
    }

    return accountRecord;
  }

  /**
   * Creates multiple Accounts with a single bulk DML operation.
   *
   * @param accountNames Names for the Accounts to create.
   * @return The newly created Accounts.
   * @throws AccountBulkInsertException If the bulk Account insert fails.
   */
  public static List<Account> createAccounts(List<String> accountNames) {
    List<Account> accounts = new List<Account>();

    for (String accountName : accountNames) {
      Account acc = new Account(Name = accountName);
      accounts.add(acc);
    }

    try {
      Database.insert(accounts, AccessLevel.USER_MODE);
    } catch (DmlException e) {
      throw new AccountBulkInsertException(
        'Unable to create Accounts: ' + e.getMessage()
      );
    }

    return accounts;
  }

  /**
   * Retrieves Contacts for multiple Accounts with a single SOQL query.
   *
   * @param accountIds Ids of the Accounts whose Contacts should be returned.
   * @return Contacts related to the supplied Accounts.
   */
  public static List<Contact> getContactsForAccounts(Set<Id> accountIds) {
    return [
      SELECT Id, Name, AccountId
      FROM Contact
      WHERE AccountId IN :accountIds
      WITH USER_MODE
    ];
  }

  /**
   * Creates a Map of Account Ids to Account records.
   *
   * @param accounts Accounts to convert into a Map keyed by Id.
   * @return Map containing the supplied Accounts keyed by their Id.
   */
  public static Map<Id, Account> getAccountMap(List<Account> accounts) {
    Map<Id, Account> accountMap = new Map<Id, Account>();

    for (Account acc : accounts) {
      accountMap.put(acc.Id, acc);
    }

    return accountMap;
  }
}
