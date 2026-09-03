/**
 * Provides Account DML operations and bulkified Account/Contact access examples.
 */
public with sharing class DevOpsAccountDmlService {

    /**
     * Creates an Account with the supplied name.
     *
     * @param accountName Name of the Account to create.
     * @return The newly created Account.
     */
    public static Account createAccount(String accountName) {

        Account acc = new Account(
            Name = accountName
        );

        Database.insert(acc, AccessLevel.USER_MODE);

        return acc;
    }

    /**
     * Updates the name of an existing Account.
     *
     * @param accountId Id of the Account to update.
     * @param newName New Account name.
     * @return The updated Account.
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

        Database.update(acc, AccessLevel.USER_MODE);

        return acc;
    }

    /**
     * Deletes an Account by Id.
     *
     * @param accountId Id of the Account to delete.
     */
    public static void deleteAccount(Id accountId) {

        Account acc = [
            SELECT Id
            FROM Account
            WHERE Id = :accountId
            WITH USER_MODE
            LIMIT 1
        ];

        Database.delete(acc, AccessLevel.USER_MODE);
    }

    /**
     * Inserts or updates an Account based on its Id.
     *
     * @param accountRecord Account record to insert or update.
     * @return The inserted or updated Account.
     */
    public static Account upsertAccount(Account accountRecord) {

        Database.upsert(accountRecord, AccessLevel.USER_MODE);

        return accountRecord;
    }

    /**
     * Creates multiple Accounts with a single bulk DML operation.
     *
     * @param accountNames Names for the Accounts to create.
     * @return The newly created Accounts.
     */
    public static List<Account> createAccounts(List<String> accountNames) {

        List<Account> accounts = new List<Account>();

        for (String accountName : accountNames) {

            Account acc = new Account(
                Name = accountName
            );

            accounts.add(acc);
        }

        Database.insert(accounts, AccessLevel.USER_MODE);

        return accounts;
    }

    /**
     * Retrieves Contacts for multiple Accounts with a single SOQL query.
     *
     * @param accountIds Ids of the Accounts whose Contacts should be returned.
     * @return Contacts related to the supplied Accounts.
     */
    public static List<Contact> getContactsForAccounts(List<Id> accountIds) {

        List<Contact> contacts = [
            SELECT Id, Name, AccountId
            FROM Contact
            WHERE AccountId IN :accountIds
            WITH USER_MODE
        ];

        return contacts;
    }
}
