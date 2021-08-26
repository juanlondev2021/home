/*
 * Diaco
 * @author             Jull Quintero Daza
 * Project:            Address Trigger
 * TestClass:          AddressTriggerTest
 * Description:        Helper
 *
 * Changes (Version)
 * _________________________________________
 *            No.        Date            Author                    Description
 *            ____    __________        __________________      _____________________________________
 * @version    1.0    12/10/2020         Jull Quintero D         Initial implementation of the class.
 **/

public class AddressTriggerHelper {

    private Set<String> addressUniqueKeys = new Set<String>();
    private Set<String> zipCodes = new Set<String>();

    /*
     * This method is responsible to change Address fields and 
        to Check for the duplicate address
     *
     * This method is run Before Insert and Before Update.
     * 
     * This method is used in:
     * AddressTriggerHandler
     * 
     * @param List newAddress
     * @param List oldAddress
     * @param Boolean IsInsert
     * @param Boolean IsUpdate
     **/
    public void setFieldsAddress(List<Address__c> currentAddress,Map<Id,Address__c> oldAddressMap, Boolean isInsert, Boolean isUpdate) {
        Integer currentAddressLength = currentAddress.size();
        for (Integer i = 0; i < currentAddressLength; i++) {
            Address__c address = currentAddress[i];
            Address__c oldAddress = isUpdate ? oldAddressMap.get(address.Id) : null;
            autoPopulateFields(address,oldAddress,isInsert,isUpdate);
            
        }

        // update the Branch,MSA and Region Code based on the Zip code value
        if( zipCodes.size() > 0 ) {
            updateRelatedBranch(currentAddress,zipCodes);
        }

        // Check for the duplicate address
        if( addressUniqueKeys.size() > 0 ) {
            duplicateAddressValidation(currentAddress,addressUniqueKeys);
        }

    }

    /*
     * This method is responsible to change address.Name, address.Full_Zip_Code__c,
        address.Unique_Key__c
     *
     * This method is run Before Insert and Before Update.
     * 
     * This method is used in:
     * setFieldsAddress - This class
     * 
     * @param Address__c newAddress
     * @param Address__c oldAddress
     * @param Boolean IsInsert
     * @param Boolean IsUpdate
     **/
    private void autoPopulateFields(Address__c address, Address__c oldAddress, Boolean isInsert, Boolean isUpdate) {

        Boolean ischangeName = false;
        Boolean ischangeUniqueKey = false;
        Boolean isChangeFullZipCode = false;
        Boolean isChangeZipCode = false;
        if( isInsert ) {
            ischangeName =  address.State__c != null && address.Street__c != null && address.City__c != null;

            ischangeUniqueKey = address.Street__c != null && address.Zip_Code__c != null;

            isChangeZipCode = address.Zip_Code__c != null;

            isChangeFullZipCode = address.Zip_Plus_Four__c != null && address.Zip_Code__c != null;

        }else if( isUpdate ) {
            ischangeName =  ( address.State__c != null && address.Street__c != null && address.City__c != null && 
                            (oldAddress.State__c != address.State__c || oldAddress.Street__c != address.Street__c || 
                            oldAddress.City__c != address.City__c) );

            ischangeUniqueKey = ( (address.Street__c != null && address.Zip_Code__c != null) && 
                                (oldAddress.Street__c != address.Street__c || 
                                oldAddress.Zip_Code__c != address.Zip_Code__c ) );

            isChangeZipCode = address.Zip_code__c != null && oldAddress.Zip_code__c != address.Zip_code__c;

            isChangeFullZipCode = ( address.Zip_Plus_Four__c != null && address.Zip_Code__c != null && 
                                    (oldAddress.Zip_Plus_Four__c != address.Zip_Plus_Four__c || 
                                    oldAddress.Zip_code__c != address.Zip_code__c) ); 
        }

        // Address name field population which contains combination of street , city & state
        if( ischangeName ) {
            address.Name = address.Street__c + ':' + address.City__c + ':' + address.State__c;
        }

        // Concatenate the values of Street and Zip_Code fields and store it in the
        // Unique_Key__c field upon address insertion.
        if( ischangeUniqueKey ) {
            address.Unique_Key__c = address.Street__c + ':' +address.Zip_Code__c;
            if(!addressUniqueKeys.contains(address.Unique_Key__c)){
                addressUniqueKeys.add(address.Unique_Key__c);
            }
            else{
                address.addError('Same address found in the incoming address records');
            }
        }

        // Concatenate the values of Zip code and Zip_Plus_Four__c fields and store it in the
        // full_zip_code__c field upon address insertion.
        if( isChangeZipCode ) {
            zipCodes.add(address.Zip_Code__c);
        } 
        if( isChangeFullZipCode ) {
            address.Full_Zip_code__c =  address.Zip_Code__c + '-' + address.Zip_Plus_Four__c;
        }
    }

    /*
     * This method is responsible to Check for the duplicate address
     * 
     * This method is run Before Insert and Before Update. 
     * 
     * This method is used in:
     * setFieldsAddress - This class
     * 
     * @param List<Address__c> Address
     * @param Set<String> addressUniqueKeys
     **/
    private void duplicateAddressValidation(List<Address__c> currentAddress,Set<String> addressUniqueKeys){
        Set<String> existingAddress = new Set<String>();

        Address__c[] allAddress =  [SELECT Id,Name,Unique_Key__c FROM Address__c WHERE Unique_Key__c IN:addressUniqueKeys];
        Integer allAddressLength = allAddress.size();
        for (Integer i = 0; i < allAddressLength; i++) {
            Address__c addr = allAddress[i];
            existingAddress.add(addr.Unique_Key__c);
        }

        // If duplicate address is found then the error would be thrown
        if(!existingAddress.isEmpty()){
            Integer currentAddressLength = currentAddress.size();
            for (Integer i = 0; i < currentAddressLength; i++) {
                Address__c address = currentAddress[i];

                if(existingAddress.contains(address.Unique_Key__c)){
                    address.addError('Address already exists');
                }
            }
        }
    }

    /*
     * This method If the zip code field has the value then update the related address.Zip_Code__c, 
        address.MSA__c, address.Region_Code__c

     * This method is run Before Insert and Before Update.

     * This method is used in:
     * setFieldsAddress - This class
     * 
     * @param List<Address__c> Address
     * @param Set<String> zipCodes
     **/
    private void updateRelatedBranch(List<Address__c> currentAddress,Set<String> zipCodesIds){
        Map<String,ZipCode__c> zipCodeMap = new Map<String,ZipCode__c>();
        //Get the list of zipcodes and branch names from the Custom object.
        ZipCode__c[] zipCodes = [SELECT Id,Name,Branch__c,MSA__c,Region_Code__c,ZipCode__c FROM ZipCode__c WHERE Name IN : zipCodesIds];
        Integer zipCodesLength = zipCodes.size();
        for (Integer i = 0; i < zipCodesLength; i++) {
            ZipCode__c zipCode = zipCodes[i];
            if(!zipCodeMap.containsKey(zipCode.Name)){
                zipCodeMap.put(zipCode.Name,zipCode);
            }
        } 
        
        Integer currentAddressLength = currentAddress.size();
        for (Integer i = 0; i < currentAddressLength; i++) {
            Address__c address = currentAddress[i];

            //Branch field population
            if(address.Zip_Code__c == null){
                address.Branch__c = null;
                address.MSA__c = '';
                address.Region_Code__c = '';
            }
            //if the address get inserted with zipcode then,
            //we auto populate Branch , MSA & Region Code based on the zipcode from Zipcode__c Custom Obj
            else if(zipCodeMap.containsKey(address.Zip_Code__c)){
                ZipCode__c zip = zipCodeMap.get(address.Zip_Code__c);
                address.Branch__c = zip.branch__c;
                address.MSA__c = zip.MSA__c;
                address.Region_Code__c = zip.Region_Code__c;
            }
            //if the address zipcode not match in the Zipcode__c custom obj then, set to Invalid Zip Code
            else{
                address.Branch__c = UtilClass.getBranchId('Invalid Zip Code');
                address.MSA__c = 'Invalid Zip Code';
                address.Region_Code__c = 'Invalid Zip Code';
            }
            //branch population end
        }
    }

    /*
     * This method is responsible to Update property.Name
     * 
     * This method is run After Update. 
     * 
     * This method is used in:
     * AddressTriggerHandler
     * 
     * @param List<Address__c> Address
     * @param Map<Id,Address__c> oldAddressMap
     **/

    //property name update
    public static void updatePropertyName(List<Address__c> currentAddress, Map<Id,Address__c> oldAddressMap){
        Map<Id,Address__c> addressMap = new Map<Id,Address__c>();
        integer currentAddressLength = currentAddress.size();
        for (Integer i = 0; i < currentAddressLength; i++) {
            Address__c address = currentAddress[i];
            Address__c oldAddress = oldAddressMap.get(address.Id);
            if(oldAddress.Name != address.Name){
                addressMap.put(address.Id,address);
            }
        }
        
        List<Property__c> toUpdateProperties = [SELECT Id,Name,Address__c FROM Property__c WHERE Address__c IN : addressMap.keyset()];
        if(!toUpdateProperties.isEmpty()){
            Integer toUpdatePropertiesLength = toUpdateProperties.size();
            for (Integer i = 0; i < toUpdatePropertiesLength; i++) {
                Property__c property = toUpdateProperties[i];
                if(addressMap.containskey(property.Address__c)) {
                    property.Name = addressMap.get(property.Address__c).Name;
                }
            }
        }    
        try {
            if(!toUpdateProperties.isEmpty()){
                update toUpdateProperties;
            }
        }
        catch(Exception e){
            System.debug('Error occured while updating the property'+e.getMessage());
        }
    }
}