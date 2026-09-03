public with sharing class DevOpsAccountService {

    public static List<Account> getAccounts() {

        List<Account> accounts = [
            SELECT Id, Name
            FROM Account
            LIMIT 10
        ];

        return accounts;
    }
}
