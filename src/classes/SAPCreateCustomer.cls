global without sharing class SAPCreateCustomer {

    public Boolean isSuccess;
    public String sapCustomerId;
    public Id accountId;
    public String message;
    public Account act;
    public List<Sales_Area_Data__c> sadList;
    public SAPCustomer sapCustomerData;
    public Map<String,Sales_Area__c> saMap;
    public Map<String,Sales_Area_data__c> sadMap;
    public Map<String,Ship_To_Data__c> stMap;

    public class SAPChar {
        public String ATNAM;
        public String ATWRT;
        public SAPChar( String n, String v ) {
            ATNAM = n;
            ATWRT = v;
        }        
    }
    
    public class SAPClassification {
        public String CLASST_T_T;
        public String KLART;
		public List<SAPChar> CHARACTERISTICS;
        public SAPClassification( String c ) {
            CLASST_T_T = c;
            KLART = '011';
            CHARACTERISTICS = new List<SAPChar>();
        }
    }
    
    public class SAPSalesArea {
        public String VKORG;
        public String KTOKD;
        public String VTWEG;
        public String SPART;
        public String BZIRK;
        public String VKBUR;
        public String KDGRP;
        public String KONDA;
        public String EIKTO;
        public String WAERS;
        public String INCO1;
        public String ZTERM;
        public String LPRIO;
        public String VSBED;
        public List<String> SHIP_TO_PARTIES;        
    }
    
    private String JSONString() {
        String s = JSON.serializePretty( sapCustomerData, true );
        return EncodingUtil.urlEncode(s.replaceAll('CLASST_T_T','CLASS'),'UTF-8');
    }

    private void updateAccount() {
        if ( String.isBlank(sapCustomerId) ) return;
        if ( act == null || String.isNotBlank(act.SAP_Customer_Id__c) ) return;
        try {
            // This is added to check if the Sap Custom Id is already on salesforce, reset to make room if exist.
            // It is only needed for QA test because the data and SAP may be out of sync
            for ( Account a : [select Id, SAP_Customer_Id__c from Account where SAP_Customer_Id__c = :sapCustomerId] ) {
                AccountUtil.EmeaUpdateExtId( a.Id, 'invalid_'+sapCustomerId );
            }
            // Now update prospect with SAP Customer Id
            AccountUtil.EmeaUpdateExtId( act.Id, sapCustomerId );
            System.debug( 'Account '+act.Id+' ('+act.Name+') updated with SAP Customer Id '+sapCustomerId );
        }
        catch (Exception e) {
            System.debug( 'Account '+act.Id+' ('+act.Name+') failed to update with SAP Customer Id '+sapCustomerId );
            message += '\nAccount '+act.Id+' ('+act.Name+') failed to update with SAP Customer Id '+sapCustomerId
                +'\n'+e.getMessage();
        }
    }
    
    
    
    public class SAPCustomer {
        public String KUNNR;
        public String KTOKD;
        public String NAME1;
        public String NAME2;
        public String NAME3;
        public String NAME4;
        public String STREET;
        public String HOUSE_NUM1;
        public String STR_SUPPL1;
        public String STR_SUPPL2;
        public String STR_SUPPL3;
        public String CITY1;
        public String POST_CODE1;
        public String COUNTRY;
        public String REGION;
        public String TRANSPZONE;
        public String LANGU;
        public List<SAPSalesArea> SALES_AREA;
        public List<SAPClassification> CLASSIFICATION;
        
        private String NoCountryCode( String c ) {
            if ( String.isBlank(c) || c.indexOf('-') < 0 ) return c;
            return c.substring(c.indexOf('-')+1);
    	}
    

        SAPCustomer( Account a, Sales_Area_Data__c[] sList ) {
            KUNNR = a.SAP_Customer_Id__c;
        	KTOKD = a.SAP_Ship_To__c;
            NAME1 = a.Name;
        	NAME2 = a.Name2__c;
        	NAME3 = a.Name3__c;
        	NAME4 = a.Name4__c;
            STREET = a.BillingStreet;
            HOUSE_NUM1 = null;
            STR_SUPPL1 = a.STR_SUPPL1__c;
            STR_SUPPL2 = a.STR_SUPPL2__c;
            STR_SUPPL3 = a.STR_SUPPL3__c;
            CITY1 = a.BillingCity;
            POST_CODE1 = a.BillingPostalCode;
            COUNTRY = a.BillingCountryCode;
            REGION = NoCountryCode(a.Region_Code__r.Code__c);
            TRANSPZONE = NoCountryCode(a.Transportation_Zone__r.Code__c);
            LANGU = a.Customer_Language__r.Code__c;
        	CLASSIFICATION = new List<SAPClassification>();
            if ( String.isNotBlank(a.AD_Business_Area__c)||String.isNotBlank(a.AD_Distribution_Channel__c)||String.isNotBlank(a.AD_Industry__c) ) {
                SAPClassification c = new SAPClassification( 'CUSTOMERS_AD' );
                CLASSIFICATION.add( c );
                if ( String.isNotBlank(a.AD_Business_Area__c) ) {
                    c.CHARACTERISTICS.add( new SAPChar( 'Business area', a.AD_Business_Area__c ) );
                }
                if ( String.isNotBlank(a.AD_Distribution_Channel__c) ) {
                    c.CHARACTERISTICS.add( new SAPChar( 'Distribution channel', a.AD_Distribution_Channel__c ) );
                }
                if ( String.isNotBlank(a.AD_Industry__c) ) {
                    c.CHARACTERISTICS.add( new SAPChar( 'Industry', a.AD_Industry__c ) );
                }
            }
            if ( String.isNotBlank(a.MP_Business_Area__c)||String.isNotBlank(a.MP_Distribution_Channel__c)||String.isNotBlank(a.MP_Industry__c) ) {
                SAPClassification c = new SAPClassification( 'CUSTOMERS_MP' );
                CLASSIFICATION.add( c );
                if ( String.isNotBlank(a.MP_Business_Area__c) ) {
                    c.CHARACTERISTICS.add( new SAPChar( 'Business area', a.MP_Business_Area__c ) );
                }
                if ( String.isNotBlank(a.MP_Distribution_Channel__c) ) {
                    c.CHARACTERISTICS.add( new SAPChar( 'Distribution channel', a.MP_Distribution_Channel__c ) );
                }
                if ( String.isNotBlank(a.MP_Industry__c) ) {
                    c.CHARACTERISTICS.add( new SAPChar( 'Industry', a.MP_Industry__c ) );
                }
            }
            if ( String.isNotBlank(a.RP_Distribution_Channel__c)||String.isNotBlank(a.RP_Industry__c) ) {
                SAPClassification c = new SAPClassification( 'CUSTOMERS_RP' );
                CLASSIFICATION.add( c );
                if ( String.isNotBlank(a.RP_Distribution_Channel__c) ) {
                    c.CHARACTERISTICS.add( new SAPChar( 'Distribution channel', a.RP_Distribution_Channel__c ) );
                }
                if ( String.isNotBlank(a.RP_Industry__c) ) {
                    c.CHARACTERISTICS.add( new SAPChar( 'Industry', a.RP_Industry__c ) );
                }
            }
            SALES_AREA = new List<SAPSalesArea>();
            if ( sList != null ) {
                for ( Sales_Area_Data__c s : sList ) {
					SAPSalesArea sad = new SAPSalesArea();
                    SALES_AREA.add( sad );
                    sad.VKORG = s.Sales_Area_Sales_Organisation_Code__r.Sales_Organization__c; 			// 'Sales Organization code',
                    //sad.KTOKD = null; //> 'SoldTo or ShipTo', 										// 0001 FOR sold to, 0002 for ship to only
                	sad.VTWEG = s.Sales_Area_Sales_Organisation_Code__r.Distribution_Channel_Code__c; 	// 'Distribution Channel code',
                	sad.SPART = s.Sales_Area_Sales_Organisation_Code__r.Division_Code__c; 				// 'Division code',
                	sad.BZIRK = s.Sales_District__r.Code__c; 											// Sales District Code',
                	sad.VKBUR = s.Sales_Office_lookup__r.Code__c; 										// Sales Office code',
                	sad.KDGRP = s.Customer_Group_lookup__r.Code__c; 									// Customer Group',
                	sad.KONDA = s.Price_Group_lookup__r.Code__c; 										// Price Group',                    
                	sad.EIKTO = s.Account_at_Customer_Code__c; 											// Account at Customer',
                	// sad.WAERS = s.Currency_Code__c; 													// Customer Currency code',
                	sad.WAERS = s.CurrencyIsoCode; 													// Customer Currency code',
                	sad.INCO1 = s.Incoterm_Code_lookup__r.Code__c; 										// Incoterms code',
                	sad.ZTERM = s.Terms_of_Payment_lookup__r.Code__c; 									// Terms of Payment Code',
                	sad.LPRIO = s.Delivery_Priority__r.Code__c; 										// Delivery Priority Code',
                	sad.VSBED = s.Shipping_Conditions__r.Code__c; 										// Shipping Conditions Code'
					sad.SHIP_TO_PARTIES = new List<String>();
                    for ( Ship_To_Data__c std : s.Ship_To_Data__r ) {
                        system.debug( 'ship_to: '+std.Ship_To_Account__r.SAP_Customer_Id__c );
                        if ( String.isNotBlank(std.Ship_To_Account__r.SAP_Customer_Id__c) ) {
                            sad.SHIP_TO_PARTIES.add( std.Ship_To_Account__r.SAP_Customer_Id__c );
                        }
                    }
                }
            }
        }
    }
    
    
    public SAPCreateCustomer( Id aId ) {
        accountId = aId;
        isSuccess = false;
        sapCustomerId = null;
        message = 'Failed to create customer in SAP';	// generic default error message
        LoadData();
    }

    // Main interface to push a customer to SAP
    // Input: Id of the account
    // Output:
     
    public static SAPCreateCustomer CreateCustomer( Id accountId ) {
        system.debug( accountId );
        
        SAPCreateCustomer scc = new SAPCreateCustomer( accountId );
        
        // system.debug(JSON.serializePretty( scc.sapCustomerData, false ));
        
        // update new Account( Id = AccountId, EMEA_CLASS__c = JSON.serializePretty( scc.sapCustomerData, false ) );
        if ( scc.sapCustomerData != null ) {
        	scc.callSAP();
        }
        
        system.debug( scc );
        
        return scc;
    }
    
    public void callSAP() {
        String SETTING_JITTERBIT_USERNAME_TYPE = 'EMEA SAP Create Quote JB Username';
  		String SETTING_JITTERBIT_PASSWORD_TYPE = 'EMEA SAP Create Quote JB Password';
        String SETTING_JITTERBIT_URL = 'EMEA JB Customer Create URL';
        
    	HTTPRequest r = new HTTPRequest();

    	Map<String,Integration_Settings__c> settings = CustomSettingManager.fetchIntegrationEnvironmentSpecificSettingsMapByType();

        try {
            Blob headerValue = Blob.valueOf(settings.get(SETTING_JITTERBIT_USERNAME_TYPE).Text_Value__c +':' +settings.get(SETTING_JITTERBIT_PASSWORD_TYPE).Text_Value__c);
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            r.setHeader('Authorization', authorizationHeader);
        } catch ( Exception e ) {
            System.debug( e.getMessage() );
        }
        
        // r.setEndpoint('https://EnerSysTRIAL189156.jitterbit.net/EnerSysEMEA/v1.3/Customer_Create_Dev');
        System.debug(settings.get(SETTING_JITTERBIT_URL).Text_Value__c);
        r.setEndpoint(settings.get(SETTING_JITTERBIT_URL).Text_Value__c);     
        
    	String contentType = 'application/json; charset=utf-8';
        r.setHeader('Content-Type', contentType);
        
        r.setMethod('POST');
        r.setBody(JSONString());
        System.debug(JSONString());

        HTTP h = new HTTP();
        
        String s;
        
        if ( TEST.isRunningTest() ) {
            s = '{"EV_CUST_NO":"'+act.SAP_Customer_Id__c+'","exceptionMessages":""}';
            act.SAP_Customer_Id__c=null;
        }
        else {
            HTTPResponse hresp = h.send(r);
            
            system.debug( hresp );
    
            String status = hresp.getStatus();
            
            if ( status != 'OK' ) return;
            
            s = hresp.getBody();
        }
        
        if ( String.isNotBlank(s) && s.substring(0,1)!='<' ) {
        	system.debug( s );
            s = s.left(s.indexOf('}')+1);
            system.debug( s );
            Object o = JSON.deserializeUntyped( s );
            Map<String,Object> rMap = (Map<String,Object>) o;
            System.debug( rMap );
            System.debug( rMap.get('EV_CUST_NO') );
            sapCustomerId = (String) rMap.get('EV_CUST_NO');

            if ( String.isNotBlank(sapCustomerId) ) {
            	isSuccess = true;
                message = 'Customer created in SAP with Customer Number '+sapCustomerId;
                updateAccount();
            }
            else {
                List<Object> em = (List<Object>) rMap.get('exceptionMessages');
                message = 'Failed to create customer in SAP: '+em;
                System.debug( message );                
            }
    	}		
    }    
    
    public Boolean ValidStructure( Sales_Area_Data__c[] sList ) {
        for ( Sales_Area_Data__c s : sList ) {
            for ( Ship_To_Data__c std : s.Ship_To_Data__r ) {
                if (std.Ship_To_Account__c != s.Account__c && String.isBlank(std.Ship_To_Account__r.SAP_Customer_Id__c) ) {
                    message = 'Ship T Account '+std.Ship_To_Account__r.Name+' is not a valid SAP Ship To account';
                    return false;
                }
            }
        }
                
        return true;
    }
    
    public void LoadData() {
        if ( String.isBlank( accountId ) ) {
            message = 'Account Id is not provided';
            return;        
        }
        
        Account[] aList = [   SELECT AD_Business_Area__c
                                   , AD_Distribution_Channel__c
                                   , AD_Industry__c
                                   , BillingCity
                                   , BillingCountryCode
                                   , BillingPostalCode
                                   , BillingStreet
                                   , EMEA_SAP_Ready__c
                                   , EMEA_SAP_Required_Data_Checklist__c
                                   , ExtId__c
                                   , Id
                                   , MP_Business_Area__c
                                   , MP_Distribution_Channel__c
                                   , MP_Industry__c
                                   , Name
                                   , Name2__c
                                   , Name3__c
                                   , Name4__c
                                   , RP_Distribution_Channel__c
                                   , RP_Industry__c
                                   , SAP_Customer_Id__c
                                   , SAP_Ship_To__c
                           		   , STR_SUPPL1__c
                           		   , STR_SUPPL2__c
                           		   , STR_SUPPL3__c
                           		   , Region_Code__r.Code__c
                    			   , Transportation_Zone__r.Code__c
            					   , Customer_Language__r.Code__c
                                FROM Account
                               WHERE Id = :accountId ];

        
        if ( aList.isEmpty() ) {
            message = 'Cannot find account with Account Id '+accountId;
            return;                
        }

        act = aList[0];

        if ( act.EMEA_SAP_Ready__c == false && !TEST.isRunningTest() ) {
            message = 'Account not ready to be sent to SAP: '+act.EMEA_SAP_Required_Data_Checklist__c;
            return;
        }

        sadList = [   Select ExtId__c
                           , Id
                           , Sales_Area_Code_Text__c
                   		   , Account_at_Customer_Code__c
                           , Account__c
                           , CurrencyIsoCode
                           //, Currency_Code__c
                           , Shipcond_Code__c
                           , Customer_Group_lookup__r.Code__c
                           , Delivery_Priority__r.Code__c
                           , Incoterm_Code_lookup__r.Code__c
                           , Price_Group_lookup__r.Code__c
                           , Sales_District__r.Code__c
                           , Sales_Office_lookup__r.Code__c
                           , Shipping_Conditions__r.Code__c
                           , Terms_of_Payment_lookup__r.Code__c
                           , Sales_Area_Sales_Organisation_Code__r.Distribution_Channel_Code__c
                           , Sales_Area_Sales_Organisation_Code__r.Division_Code__c
                           , Sales_Area_Sales_Organisation_Code__r.Sales_Organization__c
                           , Customer_Group_lookup__c
                           , Delivery_Priority__c
                           , Incoterm_Code_lookup__c
                           , Price_Group_lookup__c
                           , Sales_District__c
                           , Sales_Office_lookup__c
                           , Shipping_Conditions__c
                           , Terms_of_Payment_lookup__c
                           , Sales_Area_Sales_Organisation_Code__c
                           , (select Ship_To_Account__c
                                   , Ship_To_Account__r.SAP_Customer_Id__c
                                from Ship_To_Data__r )
                        from Sales_Area_Data__c
                       WHERE Account__c = :accountId ];
        
        if ( ValidStructure( sadList ) ) {
        	sapCustomerData = new SAPCustomer( act, sadList );
        }
        return;
    }
    




}