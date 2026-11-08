public with sharing class OrgChangeService {
    public static Account createOrUpdateAccount(String accountName, String billingCity, String phone) {
        if (String.isBlank(accountName)) {
            throw new IllegalArgumentException('Account name is required.');
        }

        List<Account> accounts = [
            SELECT Id, Name, BillingCity, Phone
            FROM Account
            WHERE Name = :accountName
            LIMIT 1
        ];

        Account target = accounts.isEmpty() ? new Account(Name = accountName) : accounts[0];

        if (!String.isBlank(billingCity)) {
            target.BillingCity = billingCity;
        }

        if (!String.isBlank(phone)) {
            target.Phone = phone;
        }

        upsert target;
        return target;
    }
}
