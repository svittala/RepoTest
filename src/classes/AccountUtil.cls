global without sharing class AccountUtil {
	static Map<String,User> userMap;
	static Map<String,SAP_Reference__c> refMap;
    static Map<String,String> saFieldMap;
    
    static {
        saFieldMap = new Map<String,String>{
                'VKORG' => 'Sales Organization code',
                'KTOKD' => 'SoldTo or ShipTo', 				// 0001 FOR sold to, 0002 for ship to only
                'VTWEG' => 'Distribution Channel code',
                'SPART' => 'Division code',
                'BZIRK' => 'Sales District Code',
                'VKBUR' => 'Sales Office code',
                'KDGRP' => 'Customer Group',
                'KONDA' => 'Price Group',                    
                'EIKTO' => 'Account at Customer',
                'WAERS' => 'Customer Currency code',
                'INCO1' => 'Incoterms code',
                'ZTERM' => 'Terms of Payment Code',
                'LPRIO' => 'Delivery Priority Code',
                'VSBED' => 'Shipping Conditions Code'
            };

        userMap = new Map<String,User>();
        for ( User u : [ SELECT Id
                        	  , Email
                        	  , IsActive
                           FROM User
                          where IsActive=true
                          order by LastModifiedDate ] )
        {
            userMap.put( u.Email.toLowerCase(), u );
        }
        
        refMap = new Map<String,SAP_Reference__c>();
        for ( SAP_Reference__c r :  [  SELECT Id
                                            , Code__c
                                            , Code_Type__c
                                            , Key__c
                                         FROM SAP_Reference__c
                                        //WHERE Key__c like 'BDT-%'
                                        //   OR Key__c like 'BPT-%'
                                    ] )
        {
            refMap.put( r.Key__c, r );
        }
    }

    public static void fixAccount( List<Account> aList ) {
        List<SAP_Reference__c> newRefList = new List<SAP_Reference__c>();
        for ( Account a : aList ) {
            if ( String.isNotBlank(a.Terms_of_Delivery_Code__c) ) {
                String k = 'BDT-'+a.Terms_of_Delivery_Code__c;
                SAP_Reference__c r = refMap.get( k );
                if ( r == null ) {
                    r = new SAP_Reference__c( Code__c = a.Terms_of_Delivery_Code__c
                                            , Name = a.Terms_of_Delivery_Desc__c
                                            , Code_Type__c = 'Delivery Terms - DT'
                                            , Company__c = a.Company_Number_Pick__c
                                            , Key__c = k
                                            , Missing_Value__c = true
                                            , System__c = 'Baan' );
                    newRefList.add( r );
                    refMap.put( k, r );
                }
            }
            if ( String.isNotBlank(a.Terms_of_Payment_Code__c ) ) {
                String k = 'BPT-'+a.Terms_of_Payment_Code__c;
                SAP_Reference__c r = refMap.get( k );
                if ( r == null ) {
                    r = new SAP_Reference__c( Code__c = a.Terms_of_Payment_Code__c
                                            , Name = a.Terms_of_Payment_Desc__c
                                            , Code_Type__c = 'Payment Terms - PT'
                                            , Company__c = a.Company_Number_Pick__c
                                            , Key__c = k
                                            , Missing_Value__c = true
                                            , System__c = 'Baan' );
                    newRefList.add( r );
                    refMap.put( k, r );
                }
            }
        }
        if ( ! newRefList.isEmpty() ) {
            Database.upsert(newRefList, SAP_Reference__c.Fields.Key__c, false);
        }
        for ( Account a : aList ) {
            if ( String.isNotBlank(a.Terms_of_Delivery_Code__c) ) {
                String k = 'BDT-'+a.Terms_of_Delivery_Code__c;
                SAP_Reference__c r = refMap.get( k );
                if ( r != null ) {
                    a.Delivery_Terms__c = r.Id;
                }
            }
            if ( String.isNotBlank(a.Terms_of_Payment_Code__c ) ) {
                String k = 'BPT-'+a.Terms_of_Payment_Code__c;
                SAP_Reference__c r = refMap.get( k );
                if ( r != null ) {
                    a.Payment_Terms__c = r.Id;
                }
            }
            if ( String.isNotBlank(a.Sales_Agent_Email__c ) ) {
                User u = userMap.get( a.Sales_Agent_Email__c.toLowerCase() );
                if ( u != null ) {
                    a.OwnerId = u.Id;
                }
            }
        }
    }

    
    public static Object FindValue( Object obj, String key ) {
        if ( obj == null ) return null;
        if ( obj instanceof Map<string, Object> ) {
            Map<string, Object> m = (Map<string, Object>) obj;
            if ( m.containsKey(key) )
                return m.get( key );
            for ( String nkey : m.keySet() ) {
                Object nv = FindValue( m.get( nkey), key );
                if ( nv != null ) return nv;
            }
            return null;
        }
        if ( obj instanceof List<Object> ) {
            for ( Object nobj : (List<Object>)obj ) {
                Object nv = FindValue( nobj, key );
                if ( nv != null ) return nv;
            }
            return null;
        }
        return null;
    }

    public static Map<String,Object> passXml( String s ) {
        System.debug(s);
        XmlStreamReader reader = new XmlStreamReader(s);
        if ( ! reader.hasNext() )
            return null;
        reader.next();
        Map<String,Object> obj = new Map<String,Object>();
        String n = reader.getLocalName();
        System.debug(n);
        if ( reader.getAttributeValue(null, 'object') == 'true' ) {
            obj.put(n,passXMLObj(reader));
        }
        else if ( reader.getAttributeValue(null, 'array') == 'true' ) {
            obj.put(n,passXMLArray(reader));
        }
        else {
            reader.next();
            String v = '';
            while ( reader.isCharacters() ) {
                System.debug(reader.getText());
                v += reader.getText();
                reader.next();
            }
            obj.put( n, v );
            reader.next();
        }
        return obj;
    }
    
    
    public static Map<String,Object> passXMLObj( XmlStreamReader reader ) {
        Map<String,Object> obj = new Map<String,Object>();
        if ( reader.hasNext() )
        	reader.next();        
        while ( reader.isStartElement() ) {
            String n = reader.getLocalName();
            //System.debug(n);
            if ( reader.getAttributeValue(null, 'object') == 'true' ) {
                obj.put( n, passXMLObj(reader) );
            }
            else if ( reader.getAttributeValue(null, 'array') == 'true' ) {
                obj.put( n, passXMLArray(reader) );
            }
            else {
                reader.next();
                String v = '';
                while ( reader.isCharacters() ) {
                    //System.debug(reader.getText());
                    v += reader.getText();
                	reader.next();
                }
                obj.put( n, v );
                reader.next();
            }
        }
        if ( reader.hasNext() )
        	reader.next();
        return obj;
    }
    
    public static List<Object> passXMLArray( XmlStreamReader reader ) {
        List<Object> obj = new List<Object>();
        if ( reader.hasNext() )
        	reader.next();
        while ( reader.isStartElement() ) {
            String n = reader.getLocalName();
            //System.debug(n);
            if ( reader.getAttributeValue(null, 'object') == 'true' ) {
                obj.add( passXMLObj(reader) );
            }
            else if ( reader.getAttributeValue(null, 'array') == 'true' ) {
                obj.add( passXMLArray(reader) );
            }
            else {
                reader.next();
                String v = '';
                while ( reader.isCharacters() ) {
                    //System.debug(reader.getText());
                    v += reader.getText();
                	reader.next();
                }
                obj.add( v );
                reader.next();
            }        	
        }
        if ( reader.hasNext() )
        	reader.next();
        return obj;
    }
    
    public static void testtest(String sapid) {
        Account a = [select EMEA_CLASS__c,EMEA_JSON__c, EMEA_JSON_Date_Time__c from Account where SAP_Customer_Id__c=:sapid];
        System.debug(a.EMEA_JSON_Date_Time__c);
        System.debug(a.EMEA_JSON__c);
        System.debug(a.EMEA_CLASS__c);
        Object o = passXml( a.EMEA_JSON__c );
        /*
        Object oc = passXml( a.EMEA_CLASS__c);
        System.debug(o);
        Object oSA = FindValue( o, 'SALES_AREA' );
        System.debug(oSA);
        Object oCL = FindValue( o, 'CLASSIFICATION' );
        System.debug(oCL);
        System.debug(oc );
		*/
        System.debug('******');
        update a;
        System.debug('******');
        System.debug('******');
        System.debug('******');
        
    }
    

    
    public static void EmeaBefore( List<Account> aList ) {
        Map<String,SAP_Reference__c> srMap = new Map<String,SAP_Reference__c>();
        Map<String,Id> srIdMap = new Map<String,Id>();
        Map<String,String> regionMap = new Map<String,String>();
        Map<String,String> transpzoneMap = new Map<String,String>();
        Map<String,String> languMap = new Map<String,String>();
        for ( Account a : aList ) {
            if ( String.isBlank(a.EMEA_JSON__c) || String.isBlank(a.SAP_Customer_Id__c) ) continue;
            try {
                Object obj= passXml( a.EMEA_JSON__c );
                EmeaClassification( a, FindValue( obj, 'CLASSIFICATION' ) );
                
                a.Type = EmeaAccountType(a);

                String country = (String) FindValue( obj, 'COUNTRY' );
                String region = (String) FindValue( obj, 'REGION' );
                String transpzone = (String) FindValue( obj, 'TRANSPZONE' );
                String langu = (String) FindValue( obj, 'LANGU' );
                
                System.debug( 'COUNTRY: '+country );
                System.debug( 'REGION: '+region );
                System.debug( 'TRANSPZONE: '+transpzone );
                System.debug( 'LANGU: '+langu );
                
                String k;
                
                if ( String.isNotBlank(region) ) {    
                    k = 'SRC-'+country+'-'+region;
                    regionMap.put( a.SAP_Customer_Id__c, k );
                    if ( ! refMap.containsKey(k) && ! srMap.containsKey(k) ) {
                    	srMap.put( k, new SAP_Reference__c( Key__c = k, Code_Type__c = 'Region Code - RC', Code__c = country+'-'+region, Country_Code__c = country, Name = k, System__c = 'SAP', Missing_Value__c = true) );
                    }
                }
                
                if ( String.isNotBlank(langu) ) {
                    k = 'SCL-'+langu;
                	System.debug(k);
                    languMap.put( a.SAP_Customer_Id__c, k );
                    if ( ! refMap.containsKey(k) && ! srMap.containsKey(k) ) {
                    	srMap.put( k, new SAP_Reference__c( Key__c = k, Code_Type__c = 'Customer Language - CL', Code__c = langu, Name = k, System__c = 'SAP', Missing_Value__c = true) );
                    }
                }

                if ( String.isNotBlank(transpzone) && String.isNotBlank(country) ) {
                    k = 'STZ-'+country+'-'+transpzone;
                    transpzoneMap.put( a.SAP_Customer_Id__c, k );
                    if ( ! refMap.containsKey(k) && ! srMap.containsKey(k) ) {
                    	srMap.put( k, new SAP_Reference__c( Key__c = k, Code_Type__c = 'Transportation Zone - TZ', Code__c = country+'-'+transpzone, Country_Code__c = country, Name = k, System__c = 'SAP', Missing_Value__c = true) );
                    }
                }
       
            } catch (Exception e){ 
                a.addError(e.getLineNumber()+': '+e.getMessage()+'\n'+e.getStackTraceString());
                System.debug(a.SAP_Customer_Id__c+': '+e.getMessage());
            }
        }            
        if ( ! srMap.isEmpty() ) {
            Schema.SObjectField f = SAP_Reference__c.Fields.Key__c;
            List<SAP_Reference__c> srList = srMap.values();
            Database.UpsertResult [] cr = Database.upsert(srList, f, false);
            for ( Integer i = 0; i < srList.size(); i++ ) {
                Database.UpsertResult ur = cr[i];
                SAP_Reference__c sr = srList[i];
                if ( ur.isSuccess() ) {
                    refMap.put( sr.Key__c, sr );
                }
                else {
                    System.debug( 'Sap Reference Error: ' );
                    System.debug( ur.getErrors() );
                    System.debug( sr );
                }
            }
        }
        for ( Account a : aList ) {
            if ( String.isBlank(a.EMEA_JSON__c) || String.isBlank(a.SAP_Customer_Id__c) ) continue;
            String k;
            k = regionMap.get( a.SAP_Customer_Id__c );
            if ( k != null && refMap.containsKey(k) ) {
                a.Region_Code__c = refMap.get(k).Id;
            }
            k = transpzoneMap.get( a.SAP_Customer_Id__c );
            if ( k != null && refMap.containsKey(k) ) {
                a.Transportation_Zone__c = refMap.get(k).Id;
            }
            k = languMap.get( a.SAP_Customer_Id__c );
            if ( k != null && refMap.containsKey(k) ) {
                a.Customer_Language__c = refMap.get(k).Id;
            }
        }
    }


    public static String EmeaAccountType( Account a ) {
        return (String.isBlank(a.SAP_Ship_To__c) || a.SAP_Ship_To__c=='0001') ? 'Customer' : 'Ship To';
    }
    
    
    public static void EmeaUpdateExtId( Id accountId, String SAP_Id ) {
        
        String CustomerRecordTypeId = [select Id from RecordType where Name='Customer' and SObjectType='Account'].Id;
        Account a = [select SAP_Ship_To__c from Account where Id = :accountId];        
        String t = EmeaAccountType(a);
        
        update new Account( Id = accountId, SAP_Customer_Id__c = SAP_Id, RecordTypeId = CustomerRecordTypeId, Type = t );
        
        List<Sales_Area_Data__c> sadList = new List<Sales_Area_Data__c>();
        Map<Id,Sales_Area__c> saMap = new Map<Id,Sales_Area__c>();
        Map<String,Ship_To_Data__c> stdMap = new Map<String,Ship_To_Data__c>();
        
        for ( Sales_Area_Data__c sad : [   Select ExtId__c
                                                , Id
                                                , Sales_Area_Sales_Organisation_Code__c
                                                , Sales_Area_Sales_Organisation_Code__r.Name
                                                , Sales_Area_Sales_Organisation_Code__r.ExtId__c
                                                , (select Id
                                                        , Ship_To_Account__c
                                                        , Ship_To_Account__r.SAP_Customer_Id__c
                                                     from Ship_To_Data__r)
                                 			 from Sales_Area_Data__c
                                            WHERE Account__c = :accountId ] )
        {
            String sadKey = SAP_Id+':'+sad.Sales_Area_Sales_Organisation_Code__r.Name;
            sadList.add( new Sales_Area_Data__c( Id = sad.Id, ExtId__c = sadKey ) );
            if ( String.isBlank(sad.Sales_Area_Sales_Organisation_Code__r.ExtId__c) ) {
                saMap.put( sad.Sales_Area_Sales_Organisation_Code__c, new Sales_Area__c( Id = sad.Sales_Area_Sales_Organisation_Code__c, ExtId__c = sad.Sales_Area_Sales_Organisation_Code__r.Name) );
            }
            for ( Ship_To_Data__c std : sad.Ship_To_Data__r ) {
                if ( String.isNotBlank(std.Ship_To_Account__r.SAP_Customer_Id__c) ) {
                    String stdKey = sadKey+':'+std.Ship_To_Account__r.SAP_Customer_Id__c;
                    stdMap.put( stdKey, new Ship_To_Data__c( Id = std.Id, ExtId__c = stdKey ) );
                }
            }
        }
        if ( ! sadList.isEmpty() ) update sadList;
        if ( ! saMap.isEmpty() )   update saMap.values();
        if ( ! stdMap.isEmpty() )  update stdMap.values();
   }
    
    
    
    public static void EmeaAfter( List<Account> aList ) {
        Map<String,Account> aMap = new Map<String,Account>();
        Map<String,Sales_Area__c> saMap = new Map<String,Sales_Area__c>();
        Map<String,Sales_Area_data__c> sadMap = new Map<String,Sales_Area_data__c>();
        Map<String,SAP_Reference__c> srMap = new Map<String,SAP_Reference__c>();
        Map<String,Ship_To_Data__c> stMap = new Map<String,Ship_To_Data__c>();
        for ( Account a : aList ) {
            try {
                if ( a.SAP_Customer_Id__c == null ) continue;
                if ( String.isBlank(a.EMEA_JSON__c) ) continue;
                Object obj = passXml( a.EMEA_JSON__c );
                Object saObj = FindValue( obj, 'SALES_AREA' );
                if ( saObj == null ) continue;
                List<Object> saList = (List<Object>) saObj;
                if ( saList.isEmpty() ) continue;
                aMap.put( a.SAP_Customer_Id__c, a );
                for ( Object sa : saList ) {
                    Map<String,Object> saSapMap = (Map<String,Object>) sa;
                    Map<String,String> saNameMap = new Map<String,String>();                
                    for ( String sapKey : saFieldMap.keySet() ) {
                        String nameKey = saFieldMap.get(sapKey);
                        saNameMap.put( nameKey, (String) saSapMap.get(sapKey) );
                    }
                    String name = saNameMap.get('Sales Organization code')+
                              '/'+saNameMap.get('Distribution Channel code')+
                              '/'+saNameMap.get('Division code');
                    Sales_Area__c nsa =new Sales_Area__c( Name = name
                                                        , Description__c = 'Desc of '+name
                                                        , Distribution_Channel_Code__c = saNameMap.get('Distribution Channel code')
                                                        , Division_Code__c = saNameMap.get('Division code')
                                                        , Sales_Organization__c = saNameMap.get('Sales Organization code')
                                                        , ExtId__c = name
                                                        );
                    saMap.put( name, nsa );
                    Sales_Area_data__c sad = new Sales_Area_data__c( Account__c = a.Id
                                                                   , Sales_Area_Sales_Organisation_Code__r = new Sales_Area__c( ExtId__c = name )
                                                                   , Account_at_Customer_Code__c = saNameMap.get('Account at Customer')
                                                                   , CurrencyIsoCode = saNameMap.get('Customer Currency code')
                                                                   // , Currency_Code__c = saNameMap.get('Customer Currency code')
                                                                   , Shipcond_Code__c = saNameMap.get('Shipping Conditions Code')
                                                                   , ExtId__c = a.SAP_Customer_Id__c +':'+name
                                                                   );

                    String v;
                    String k;
                    v = saNameMap.get('Customer Group');
                    if ( String.isNotBlank(v) ) {
                        k = 'SCG-'+v;
                        sad.Customer_Group_lookup__r = new SAP_Reference__c( Key__c = k);
                        if ( ! refMap.containsKey(k) && ! srMap.containsKey(k) ) {
                            srMap.put( k, new SAP_Reference__c( Key__c = k, Code_Type__c = 'Customer Group - CG', Code__c = v, Name = k, System__c = 'SAP', Missing_Value__c = true) );
                        }
                    }
                    v = saNameMap.get('Incoterms code');
                    if ( String.isNotBlank(v) ) {
                        k = 'SIC-'+v;
                        sad.Incoterm_Code_lookup__r = new SAP_Reference__c( Key__c = k);
                        if ( ! refMap.containsKey(k) && ! srMap.containsKey(k) ) {
                            srMap.put( k, new SAP_Reference__c( Key__c = k, Code_Type__c = 'Incoterm - IC', Code__c = v, Name = k, System__c = 'SAP', Missing_Value__c = true) );
                        }
                    }
                    v = saNameMap.get('Sales Office code');
                    if ( String.isNotBlank(v) ) {
                        k = 'SSO-'+v;
                        sad.Sales_Office_lookup__r = new SAP_Reference__c( Key__c = k);
                        if ( ! refMap.containsKey(k) && ! srMap.containsKey(k) ) {
                            srMap.put( k, new SAP_Reference__c( Key__c = k, Code_Type__c = 'Sales Office - SO', Code__c = v, Name = k, System__c = 'SAP', Missing_Value__c = true) );
                        }
                    }
                    v = saNameMap.get('Terms of Payment Code');
                    if ( String.isNotBlank(v) ) {
                        k = 'STP-'+v;
                        sad.Terms_of_Payment_lookup__r = new SAP_Reference__c( Key__c = k);
                        if ( ! refMap.containsKey(k) && ! srMap.containsKey(k) ) {
                            srMap.put( k, new SAP_Reference__c( Key__c = k, Code_Type__c = 'Terms of Payment - TP', Code__c = v, Name = k, System__c = 'SAP', Missing_Value__c = true) );
                        }
                    }
                    v = saNameMap.get('Shipping Conditions Code');
                    if ( String.isNotBlank(v) ) {
                        k = 'SSC-'+v;
                        sad.Shipping_Conditions__r = new SAP_Reference__c( Key__c = k);
                        if ( ! refMap.containsKey(k) && ! srMap.containsKey(k) ) {
                            srMap.put( k, new SAP_Reference__c( Key__c = k, Code_Type__c = 'Shipping Condition - SC', Code__c = v, Name = k, System__c = 'SAP', Missing_Value__c = true) );
                        }
                    }
                    v = saNameMap.get('Delivery Priority Code');
                    if ( String.isNotBlank(v) ) {
                        k = 'SDP-'+v;
                        sad.Delivery_Priority__r = new SAP_Reference__c( Key__c = k);
                        if ( ! refMap.containsKey(k) && ! srMap.containsKey(k) ) {
                            srMap.put( k, new SAP_Reference__c( Key__c = k, Code_Type__c = 'Delivery Priority - DP', Code__c = v, Name = k, System__c = 'SAP', Missing_Value__c = true) );
                        }
                    }
                    v = saNameMap.get('Price Group');
                    if ( String.isNotBlank(v) ) {
                        k = 'SPG-'+v;
                        sad.Price_Group_lookup__r = new SAP_Reference__c( Key__c = k);
                        if ( ! refMap.containsKey(k) && ! srMap.containsKey(k) ) {
                            srMap.put( k, new SAP_Reference__c( Key__c = k, Code_Type__c = 'Price Group - PG', Code__c = v, Name = k, System__c = 'SAP', Missing_Value__c = true) );
                        }
                    }
                    v = saNameMap.get('Sales District Code');
                    if ( String.isNotBlank(v) ) {
                        k = 'SSD-'+v;
                        sad.Sales_District__r = new SAP_Reference__c( Key__c = k);
                        if ( ! refMap.containsKey(k) && ! srMap.containsKey(k) ) {
                            srMap.put( k, new SAP_Reference__c( Key__c = k, Code_Type__c = 'Sales District - SD', Code__c = v, Name = k, System__c = 'SAP', Missing_Value__c = true) );
                        }
                    }
                            
                    sadMap.put( sad.ExtId__c, sad );

                    Object t = saSapMap.get('SHIP_TO_PARTIES');
                    if ( t != null ) {
                        List<Object> stList = (List<Object>) t;
                        System.debug( stList );
                        for ( Object st : stList ) {
                            String stId = (String) st;
                            String stExtId = sad.ExtId__c+':'+stId;
                            Ship_To_Data__c std = new Ship_To_Data__c( ExtId__c = stExtId
                                                                     , Customer__c = a.Id );
                            std.Ship_To_Account__r = new Account( SAP_Customer_Id__c = stId );
                            std.Sales_Area_Data__r = new Sales_Area_data__c( ExtId__c = sad.ExtId__c );
                            stMap.put( stExtId, std );
                        }
                    }
                } 
            } catch (Exception e){
                a.addError(e.getMessage()); 
                System.debug(a.SAP_Customer_Id__c+': '+e.getMessage());
            }
        }
        if ( ! srMap.isEmpty() ) {
            Database.UpsertResult [] cr = Database.upsert(srMap.values(), SAP_Reference__c.Fields.Key__c, false);
            for ( Integer i = 0; i < cr.size(); i++ ) {
                Database.UpsertResult ur = cr[i];
                if ( ! ur.isSuccess() ) {
                    System.debug( 'Sap Reference Error: ' );
                    System.debug( ur.getErrors() );
                }
            }
        }
        if ( ! saMap.isEmpty() ) {
            Database.UpsertResult [] cr = Database.upsert(saMap.values(), Sales_Area__c.Fields.ExtId__c, false);
            for ( Integer i = 0; i < cr.size(); i++ ) {
                Database.UpsertResult ur = cr[i];
                if ( ! ur.isSuccess() ) {
                    System.debug( 'Sales Area Error: ' );
                    System.debug( ur.getErrors() );
                }
            }
        }
        if ( ! sadMap.isEmpty() ) {
            Database.UpsertResult [] cr = Database.upsert(sadMap.values(), Sales_Area_data__c.Fields.ExtId__c, false);
            for ( Integer i = 0; i < cr.size(); i++ ) {
                Database.UpsertResult ur = cr[i];
                if ( ! ur.isSuccess() ) {
                    System.debug( 'Sales Area Data Error: ' );
                    System.debug( ur.getErrors() );
                }
            }
        }
        if ( ! stMap.isEmpty() ) {
            Database.UpsertResult [] cr = Database.upsert(stMap.values(), Ship_To_Data__c.Fields.ExtId__c, false);
            for ( Integer i = 0; i < cr.size(); i++ ) {
                Database.UpsertResult ur = cr[i];
                if ( ! ur.isSuccess() ) {
                    System.debug( 'Ship To Data Error: ' );
                    System.debug( ur.getErrors() );
                }
            }
        }
    }
    
   
    
	private static void EmeaClassification( Account a, Object obj ) {
        System.debug( '===== Classification =====' );
        if ( obj == null || !(obj instanceof List<Object>) ) {
            System.debug( '===== Classification not valid =====' );
            return;
        }
        List<Object> oList = (List<Object>) obj;
        System.debug( '====================' );
        System.debug( oList );
        System.debug( '====================' );
        
        a.AD_Business_Area__c = null;
        a.AD_Industry__c = null;
        a.AD_Distribution_Channel__c = null;
        a.RP_Industry__c = null;
        a.RP_Distribution_Channel__c = null;
        a.MP_Business_Area__c = null;
        a.MP_Industry__c = null;
        a.MP_Distribution_Channel__c = null;

        for ( Object om : oList ) {
            Map<String,Object> m = (Map<String,Object>) om;
            String c = (String) m.get('CLASS');
            List<Object> chList = (List<Object>) m.get('CHARACTERISTICS');
            if ( chList == null ) continue;
            for ( Object ocv : chList ) {
                Map<String,Object> cv = (Map<String,Object>) ocv;
                String k = (String) cv.get('ATNAM');
                String v = (String) cv.get('ATWRT');
                if ( c == 'CUSTOMERS_AD' ) {
                    if ( k == 'Business area' ) {
                        a.AD_Business_Area__c = v;
                    }
                    else if ( k == 'Industry' ) {
                        a.AD_Industry__c = v;
                    }
                    else if ( k == 'Distribution channel' ) {
                        a.AD_Distribution_Channel__c = v;
                    }
                }
                
                if ( c == 'CUSTOMERS_RP') {
                    if ( k == 'Industry' ) {
                        a.RP_Industry__c = v;
                    }
                    else if ( k == 'Distribution channel' ) {
                        a.RP_Distribution_Channel__c = v;
                    }
                }
                
                if ( c == 'CUSTOMERS_MP') {
                    if ( k == 'Business area' ) {
                        a.MP_Business_Area__c = v;
                    }
                    else if ( k == 'Industry' ) {
                        a.MP_Industry__c = v;
                    }
                    else if ( k == 'Distribution channel' ) {
                        a.MP_Distribution_Channel__c = v;
                    }
                }
            }
        }
    }
    
    
    /*
    public static void fixAccountAll() {
        List<Account> aList = [select Id
                              		, Terms_of_Delivery_Code__c
                              		, Terms_of_Delivery_Desc__c
                               		, Delivery_Terms__c
                              		, Terms_of_Payment_Code__c
                              		, Terms_of_Payment_Desc__c
                               		, Payment_Terms__c
                              		, Company_Number_Pick__c
                                    , Sales_Agent_Email__c
                               		, Owner.Email
                                 from Account
                                where Delivery_Terms__c = null
                                  and Payment_Terms__c = null
                                  and ( Terms_of_Delivery_Code__c != null
                                     or Terms_of_Payment_Code__c != null
                                     or Sales_Agent_Email__c != null)
                                limit 2000];
        fixAccount( aList );
        update aList;
    }
	*/
}