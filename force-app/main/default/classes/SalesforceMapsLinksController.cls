/**
 * Diaco
 * @author             Fabian Pineda href=<fpineda@diaco.us>
 * Project:            Salesforce Maps Links
 * Description:        Generates map links for different map apps. Used by SalesforceMapsLinks.vfp.
 * Tests:			   SalesforceMapsLinksControllerTest
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version    1.0    11/11/2020        Fabian Pineda (FP)      Initial version.
 **/
public class SalesforceMapsLinksController {
    public Id accountId {get; private set;}
    public String accountName {get; private set;}

    public String wazeLatLngLink {get; private set;}
    public String wazeAddressLink {get; private set;}
    public String googleMapsLatLngLink {get; private set;}
    public String googleMapsAddressLink {get; private set;}
    public String appleMapsLatLngLink {get; private set;}
    public String appleMapsAddressLink {get; private set;}

    public String errorMessage {get; private set;}
    public String latLngErrorMessage {get; private set;}
    public String addressErrorMessage {get; private set;}
        
    public SalesforceMapsLinksController() {
        this.accountId = null;
        this.accountName = null;

        this.wazeLatLngLink = null;
        this.wazeAddressLink = null;
        this.googleMapsLatLngLink = null;
        this.googleMapsAddressLink = null;
        this.appleMapsLatLngLink = null;
        this.appleMapsAddressLink = null;

        this.errorMessage = null;
        this.latLngErrorMessage = null;
        this.addressErrorMessage = null;
        
        Map<String, String> params = ApexPages.currentPage().getParameters();
        String recordIdAsString;
        Id recordId = null;
        List<Account> accountResult;
        String addressString;
        String temp;
        
        if (params != null && params.containsKey('RecordId')) {
            recordIdAsString = params.get('RecordId');
            
            if (recordIdAsString != null && recordIdAsString.trim().length() > 0) {
                try {
                    recordId = Id.valueOf(recordIdAsString);
                } catch(System.StringException e) {
                    //System.debug('Invalid ID: ' + recordIdAsString);
                }
                
                if (recordId != null) {
                    accountResult = [SELECT Name, BillingLatitude, BillingLongitude, BillingStreet, BillingCity, BillingState, BillingPostalCode FROM Account WHERE Id = :recordId LIMIT 1];
                    
                    if (accountResult != null && accountResult.size() > 0) {
                        this.accountId = accountResult[0].Id;
                        this.accountName = accountResult[0].Name;

                        if (accountResult[0].BillingLatitude != null && accountResult[0].BillingLongitude != null) {
                            this.wazeLatLngLink = 'https://waze.com/ul?z=10&navigate=yes&ll=' + accountResult[0].BillingLatitude + ',' + accountResult[0].BillingLongitude;
                            this.googleMapsLatLngLink = 'https://www.google.com/maps/dir/?api=1&travelmode=driving&destination=' + accountResult[0].BillingLatitude + ',' + accountResult[0].BillingLongitude;
                            this.appleMapsLatLngLink = 'http://maps.apple.com/?t=m&dirflg=d&q=Billing+Location&z=10&ll=' + accountResult[0].BillingLatitude + ',' + accountResult[0].BillingLongitude;
                        } else {
                            this.latLngErrorMessage = 'Latitude and Longitude not available for this Account.';
                        }

                        if (accountResult[0].BillingStreet != null && accountResult[0].BillingCity != null && accountResult[0].BillingState != null && accountResult[0].BillingPostalCode != null) {
                            addressString = '';
                            
                            for (String v: new List<String>{accountResult[0].BillingStreet, accountResult[0].BillingCity, accountResult[0].BillingState, accountResult[0].BillingPostalCode}) {
                                if (addressString.length() > 0) {
                                    temp = v.trim();
                                    
                                    if (temp.length() > 0) {
                                        addressString += ' ' + temp;
                                    }
                                } else {
                                    addressString = v.trim();
                                }
                            }
                            
                            if (addressString.length() > 0) {
                                addressString = EncodingUtil.urlEncode(addressString,'UTF-8');
                                    
                                this.wazeAddressLink = 'https://waze.com/ul?z=10&navigate=yes&q=' + addressString;
                                this.googleMapsAddressLink = 'https://www.google.com/maps/dir/?api=1&travelmode=driving&destination=' + addressString;
                                this.appleMapsAddressLink = 'http://maps.apple.com/?t=m&z=10&dirflg=d&daddr=' + addressString;
                            }
                        } else {
                            this.addressErrorMessage = 'Street, City, State or Postal Code not available for this Account.';
                        }
                    } else {
                        this.errorMessage = 'Record not found.';
                    }
                } else {
                    this.errorMessage = 'Invalid record ID.';
                }
            } else {
                this.errorMessage = 'Empty record ID.';
            }
        } else {
            this.errorMessage = 'Missing record ID.';
        }
    }
}