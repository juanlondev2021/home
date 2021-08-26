@IsTest
public class TestData {
	/*
	public static void CreateHardwareCatalog() {
		// Create hardware catalog Items
		// 
		// IT_Hardware_Catalog__c[] hc = new IT_Hardware_Catalog__c[]{};
		// for (Integer i=0;i<10;i++){
		// 	Double hp = 34.56*((i*10)/3);
		// 	String hn = 'Test Hardware '+i;
		// 	hc.add(new IT_Hardware_Catalog__c(
		// 	Price__c = hp,
		// 	Name = hn			
		// 	));
		// }
		// try {
        // 	// Insert IT_Hardware_Catalog__c
        // 	//
        // 	Database.SaveResult[] InsertResult = Database.Insert(hc, true);
    	// }
    	// catch (Exception e){
        // 	// Catch exceptions
        // 	//
        // 	System.debug('Test: Error inserting IT_Hardware_Catalog__c\n' +e);
    	// }
	}
	
	public static void CreateServiceCatalog() {
		// Create service catalog items
		//
		IT_Service_Catalog__c[] sc = new IT_Service_Catalog__c[]{};
		for (Integer i=0;i<10;i++){
			Double sr = 34.56*((i*10)/3);
			String sn = 'Test Service '+i;
			sc.add(new IT_Service_Catalog__c(
			Unit__c = 1,
			Rate__c = sr,
			Name = sn			
			));			
		}
		try {
        	// Insert IT_Service_Catalog__c
        	//
        	Database.SaveResult[] InsertResult = Database.Insert(sc, true);
    	}
    	catch (Exception e){
        	// Catch exceptions
        	//
        	System.debug('Test: Error inserting IT_Service_Catalog__c\n' +e);
    	}		
    	
	}
	
	public static void CreateDefaultServices() {
		// Create Default Services
		//
		// In order to ensure we remain within execution limits assign all services to each Hardware Item 
		IT_Standard_Hardware_Services__c[] ss = new IT_Standard_Hardware_Services__c[]{};
		// for ( IT_Hardware_Catalog__c hi : [Select i.Name, i.Id From IT_Hardware_Catalog__c i where Name like 'Test Hardware%']){
		// 	for ( IT_Service_Catalog__c si : [Select i.Name, i.Id From IT_Service_Catalog__c i where Name like 'Test Service%']){
		// 		ss.add(new IT_Standard_Hardware_Services__c(
		// 			IT_Service_Item__c = si.id,
		// 			IT_Hardware_Item__c = hi.id
		// 		));
		// 	}
		// }
		try {
        	// Insert IT_Standard_Hardware_Services__c
        	//
        	Database.SaveResult[] InsertResult = Database.Insert(ss, true);
    	}
    	catch (Exception e){
        	// Catch exceptions
        	//
        	System.debug('Test: Error inserting IT_Standard_Hardware_Services__c\n' +e);
    	}

	}
	
	public static void CreateItRequests() {

		// Create IT Requests
		//
		IT_Request__c [] r = new IT_Request__c []{};
		for (Integer i=0;i<21;i++){
			String rn = 'Test request '+i;
			r.add(new IT_Request__c(
				Name = rn,
				Status__c = 'New'
			));
		}
		try {
        	// Insert IT_Standard_Hardware_Services__c
        	//
        	Database.SaveResult[] InsertResult = Database.Insert(r, true);
    	}
    	catch (Exception e){
        	// Catch exceptions
        	//
        	System.debug('Test: Error inserting IT_Request__c\n' +e);
    	}

	}
	
	public static void AssignHardwareSoftware() {
		// Assign Hardware and Software to IT Requests
		//
		IT_Hardware_Request__c [] hcr = new IT_Hardware_Request__c []{};
		IT_Service_Request__c [] scr = new IT_Service_Request__c []{};
		Integer count = 0;		
		
		for (IT_Request__c itr : [Select i.Status__c, i.Name, i.Id From IT_Request__c i where Name like 'Test request%']){
			String hcName = 'Test Hardware '+ count;
			String scName = 'Test Service '+ count;
			// IT_Hardware_Catalog__c hcId = [Select id from IT_Hardware_Catalog__c where Name = :hcName LIMIT 1];
			IT_Service_Catalog__c scId = [Select id from IT_Service_Catalog__c where Name = :scName LIMIT 1];
			
			// Add Harware items to IT_Hardware_Request__c
			hcr.add( new IT_Hardware_Request__c(
				IT_Request__c = itr.id,
				// IT_Hardware__c = hcId.id,
				Requested_Number__c = count				
			));
			
			// Add Service items to IT_Service_Request__c
			scr.add( new IT_Service_Request__c(
				IT_Request__c = itr.id,
				IT_Service__c = scId.id				
			));
			
			count++;
			if (count > 9) {
				count = 0;
			}
		}
		
		try {
        	// Insert IT_Hardware_Request__c
        	//
        	Database.SaveResult[] InsertResult = Database.Insert(hcr, true);
    	}
    	catch (Exception e){
        	// Catch exceptions
        	//
        	System.debug('Test: Error inserting IT_Hardware_Request__c\n' +e);
    	}

		try {
        	// Insert IT_Service_Request__c
        	//
        	Database.SaveResult[] InsertResult = Database.Insert(scr, true);
    	}
    	catch (Exception e){
        	// Catch exceptions
        	//
        	System.debug('Test: Error inserting IT_Service_Request__c\n' +e);
    	}
		
	}


	public static Coupon__c generateCoupon (boolean create, Id recordTypeId) {
		Coupon__c coupon = new Coupon__c(RecordTypeId = recordTypeId, Seen__c = true,
				Source__c = 'Restaurant.com', Amount__c = 1, Sent_By__c = UserInfo.getUserId(),
				Coupon_Link__c = 'www.link.com', Code__c = '12345');
		if (create) {
			insert coupon;
		}
		return coupon;
	}*/
}