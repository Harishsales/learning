@IsTest
private class OrgChangeServiceTest {

    @IsTest
    static void testCreateNewAccount() {
        Test.startTest();
        Account result = OrgChangeService.createOrUpdateAccount('Test Acme Corp', 'San Francisco', '555-0199');
        Test.stopTest();

        System.assertNotEquals(null, result.Id, 'Account should be created with an Id');
        System.assertEquals('Test Acme Corp', result.Name, 'Account name should match');
        System.assertEquals('San Francisco', result.BillingCity, 'Billing city should match');
        System.assertEquals('555-0199', result.Phone, 'Phone should match');
    }

    @IsTest
    static void testUpdateExistingAccount() {
        // Insert an existing account
        Account existing = new Account(Name = 'Existing Corp', BillingCity = 'New York', Phone = '555-0000');
        insert existing;

        Test.startTest();
        Account result = OrgChangeService.createOrUpdateAccount('Existing Corp', 'Chicago', '555-9999');
        Test.stopTest();

        System.assertEquals(existing.Id, result.Id, 'Should update the same record');
        System.assertEquals('Chicago', result.BillingCity, 'Billing city should be updated');
        System.assertEquals('555-9999', result.Phone, 'Phone should be updated');
    }

    @IsTest
    static void testBlankAccountNameThrowsException() {
        Boolean exceptionCaught = false;

        Test.startTest();
        try {
            OrgChangeService.createOrUpdateAccount('', 'Boston', '555-1234');
        } catch (IllegalArgumentException e) {
            exceptionCaught = true;
            System.assertEquals('Account name is required.', e.getMessage());
        }
        Test.stopTest();

        System.assert(exceptionCaught, 'An IllegalArgumentException should be thrown when accountName is blank');
    }
}