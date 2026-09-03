/**
 * Provides read operations for Account records.
 */
public with sharing class DevOpsAccountService {

    /**
     * Finds Accounts whose names contain the supplied text.
     *
     * @param accountName Text to search for within the Account Name.
     * @return Accounts matching the supplied name fragment.
     */
    public static List<Account> getAccounts(String accountName) {

        List<Account> accounts = [
            SELECT Id, Name
            FROM Account
            WHERE Name LIKE :('%' + accountName + '%')
            WITH USER_MODE
            LIMIT 10
        ];

        return accounts;
    }
}