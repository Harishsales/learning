@IsTest
private class OrgContactChangeServiceTest {

    @TestSetup
    static void setupTestData() {
        // Create a parent Account required for testing Contacts
        Account testAccount = new Account(Name = 'Test Parent Account');
        insert testAccount;
    }

    @IsTest
    static void testCreateNewContact() {
        Account testAccount = [SELECT Id FROM Account LIMIT 1];

        Test.startTest();
        Contact result = OrgContactChangeService.createOrUpdateContact(testAccount.Id, 'John', 'Doe', 'john.doe@example.com');
        Test.stopTest();

        System.assertNotEquals(null, result.Id, 'Contact should be created with an Id');
        System.assertEquals(testAccount.Id, result.AccountId, 'Contact should be linked to the correct Account');
        System.assertEquals('John', result.FirstName, 'First name should match');
        System.assertEquals('Doe', result.LastName, 'Last name should match');
        System.assertEquals('john.doe@example.com', result.Email, 'Email should match');
    }

    @IsTest
    static void testUpdateExistingContact() {
        Account testAccount = [SELECT Id FROM Account LIMIT 1];

        // Insert an existing contact
        Contact existing = new Contact(AccountId = testAccount.Id, LastName = 'Smith', FirstName = 'Jane', Email = 'jane.smith@example.com');
        insert existing;

        Test.startTest();
        Contact result = OrgContactChangeService.createOrUpdateContact(testAccount.Id, 'Janet', 'Smith', 'janet.smith@example.com');
        Test.stopTest();

        System.assertEquals(existing.Id, result.Id, 'Should update the existing record');
        System.assertEquals('Janet', result.FirstName, 'First name should be updated');
        System.assertEquals('janet.smith@example.com', result.Email, 'Email should be updated');
    }

    @IsTest
    static void testNullAccountIdThrowsException() {
        Boolean exceptionCaught = false;

        Test.startTest();
        try {
            OrgContactChangeService.createOrUpdateContact(null, 'John', 'Doe', 'john.doe@example.com');
        } catch (IllegalArgumentException e) {
            exceptionCaught = true;
            System.assertEquals('Account Id is required.', e.getMessage());
        }
        Test.stopTest();

        System.assert(exceptionCaught, 'An IllegalArgumentException should be thrown when accountId is null');
    }

    @IsTest
    static void testBlankLastNameThrowsException() {
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        Boolean exceptionCaught = false;

        Test.startTest();
        try {
            OrgContactChangeService.createOrUpdateContact(testAccount.Id, 'John', '', 'john.doe@example.com');
        } catch (IllegalArgumentException e) {
            exceptionCaught = true;
            System.assertEquals('Last name is required.', e.getMessage());
        }
        Test.stopTest();

        System.assert(exceptionCaught, 'An IllegalArgumentException should be thrown when lastName is blank');
    }
}