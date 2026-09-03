public with sharing class DevOpsAccountDmlService {

    public static Account createAccount(String accountName) {

        Account acc = new Account(
            Name = accountName
        );

        insert acc;

        return acc;
    }

    public static Account updateAccount(Id accountId, String newName) {

        Account acc = [
            SELECT Id, Name
            FROM Account
            WHERE Id = :accountId
            LIMIT 1
        ];

        acc.Name = newName;

        update acc;

        return acc;
    }

    public static void deleteAccount(Id accountId) {

        Account acc = [
            SELECT Id
            FROM Account
            WHERE Id = :accountId
            LIMIT 1
        ];

        delete acc;
    }

    public static Account upsertAccount(Account accountRecord) {

        upsert accountRecord;

        return accountRecord;
    }

    public static List<Account> createAccounts(List<String> accountNames) {

        List<Account> accounts = new List<Account>();

        for (String accountName : accountNames) {

            Account acc = new Account(
                Name = accountName
            );

            accounts.add(acc);
        }

        insert accounts;

        return accounts;
    }

    public static List<Contact> getContactsForAccounts(List<Id> accountIds) {

         List<Contact> contacts = [
            SELECT Id, Name, AccountId
            FROM Contact
            WHERE AccountId IN :accountIds
        ];

        return contacts;
    }
}
