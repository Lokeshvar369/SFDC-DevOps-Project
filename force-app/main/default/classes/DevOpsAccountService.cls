public with sharing class DevOpsAccountService {

    public static List<Account> getAccounts(String accountName) {

        List<Account> accounts = [
            SELECT Id, Name
            FROM Account
            WHERE Name LIKE :('%' + accountName + '%')
            LIMIT 10
        ];

        return accounts;
    }
}
