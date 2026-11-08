public with sharing class OrgContactChangeService {
    public static Contact createOrUpdateContact(Id accountId, String firstName, String lastName, String email) {
        if (accountId == null) {
            throw new IllegalArgumentException('Account Id is required.');
        }

        if (String.isBlank(lastName)) {
            throw new IllegalArgumentException('Last name is required.');
        }

        List<Contact> contacts = [
            SELECT Id, FirstName, LastName, Email, AccountId
            FROM Contact
            WHERE AccountId = :accountId AND LastName = :lastName
            LIMIT 1
        ];

        Contact target = contacts.isEmpty()
            ? new Contact(AccountId = accountId, LastName = lastName)
            : contacts[0];

        target.FirstName = firstName;
        target.Email = email;

        upsert target;
        return target;
    }
}
