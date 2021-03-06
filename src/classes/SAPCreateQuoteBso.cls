global with sharing class SAPCreateQuoteBso {

    public static final String SETTING_JITTERBIT_URL_TYPE = 'EMEA SAP Create Quote JB URL';
    public static final String SETTING_JITTERBIT_USERNAME_TYPE = 'EMEA SAP Create Quote JB Username';
    public static final String SETTING_JITTERBIT_PASSWORD_TYPE = 'EMEA SAP Create Quote JB Password';
    public static final String SETTING_SAVE_RAW_SAP_RESPONSE = 'EMEA Quote Sync Save SAP Response';
    public static final String USER_MESSAGE_PREFIX_HEADER = 'Quote Header Sync to SAP - ';
    public static final String USER_MESSAGE_PREFIX_LINES = 'Quote Lines Sync to SAP - ';    
    public static final String USER_MESSAGE_QUOTE_CREATED = 'SAP Quote created: ';
    public static final String USER_MESSAGE_QUOTE_UPDATED = 'SAP Quote updated: ';
    public static final String USER_MESSAGE_PRECHECK_ERROR_QUOTE_NOT_FOUND = 'Error: Unable to locate Salesforce Quote record';
    public static final String USER_MESSAGE_PRECHECK_ERROR_USER_NOT_FOUND = 'Error: Unable to identify current Salesforce User record';
    public static final String USER_MESSAGE_PRECHECK_ERROR_REQUIRED_FIELDS_NOT_FOUND = 'Error: Unable to locate required fields';
    public static final String USER_MESSAGE_QUOTE_CREATE_FAILED_WITHIN_SAP = 'SAP Quote create failed';
    public static final String USER_MESSAGE_QUOTE_UPDATE_FAILED_WITHIN_SAP = 'SAP Quote update failed';
    public static final String USER_MESSAGE_ERROR_SAP_RESPONSE_NO_RETURN = 'The SAP response did not include a RETURN node--no results available to report';
    public static final String USER_MESSAGE_ERROR_SAP_RESPONSE_NULL = 'SAP returned a null or unparseable response';
    public static final String USER_MESSAGE_ERROR_SAP_RESPONSE_UNEXPECTED = 'No updates performed--SAP returned an unexpected response';
    public static final String USER_MESSAGE_ERROR_SEE_SYS_ADMIN = 'An error occurred while processing the SAP response--please see your system administrator for assistance';
    public static final String SAP_RESULT_SUCCESS = 'Success';
    public static final String SAP_RESULT_UNEXPECTED = 'Unexpected';
    public static final String SAP_RESULT_FAILED = 'Failed';
    public static final String USER_MESSAGE_PRECHECK_ERROR_ACCOUNT_NOT_FOUND = 'Error: Unable to locate Salesforce Account record';
    public static final String USER_MESSAGE_PRECHECK_ERROR_OPPTY_NOT_FOUND = 'Error: Unable to locate Salesforce Opportunity record';
    public static final String USER_MESSAGE_PREFIX_SAP_CUSTOMER_CREATED = 'SAP Customer Number Created: ';
    public static final String USER_MESSAGE_PREFIX_SAP_CUSTOMER_FOUND = 'SAP Customer Number Found: ';
    public static final String USER_MESSAGE_SAP_CUSTOMER_CREATE_FAILED = 'Error: Could not create new SAP Customer';
    public static final String USER_MESSAGE_SF_QUOTE_CREATE_NO_RESULTS = 'Error: Salesforce Quote save returned no results';
    public static final String USER_MESSAGE_SF_QUOTE_CREATE_ID_NOT_FOUND = 'Error: Could not extract new Salesforce Quote Id from the save results';
    public static final String USER_MESSAGE_SF_QUOTE_CREATE_FAILED_NO_SAP_CUSTOMER = 'Error: Could not create Salesforce Quote with no SAP Customer';
    public static final String USER_MESSAGE_SF_QUOTE_CREATED = 'Salesforce Quote created';

    private static Map<String,Integration_Settings__c> envSettings;
    @TestVisible private SBQQ__Quote__c quote;
    public Id newQuoteId;
    @TestVisible private Opportunity oppty;
    @TestVisible private String sapCustomerNumber;

    //@TestVisible private User user;

    private SAPCreateQuoteDao dao;

    public SAPCreateQuoteBso() {
        envSettings = CustomSettingManager.fetchIntegrationEnvironmentSpecificSettingsMapByType();
        checkEnvSettings();
        dao = new SAPCreateQuoteDao();

    }

    private void checkEnvSettings() {
        Boolean settingMissing = false;
        String environmentName = CustomSettingManager.getCurrentEnvironmentName();
        if (!envSettings.containsKey(SETTING_JITTERBIT_URL_TYPE)) {
            throw new CustomSettingManager.CustomSettingException('Custom Setting "Integration Settings" is missing an entry with type = "' + SETTING_JITTERBIT_URL_TYPE + '" and environment = ' + environmentName);
        }
        if (!envSettings.containsKey(SETTING_JITTERBIT_USERNAME_TYPE)) {
            throw new CustomSettingManager.CustomSettingException('Custom Setting "Integration Settings" is missing an entry with type = "' + SETTING_JITTERBIT_USERNAME_TYPE + '" and environment = ' + environmentName);
        }
        if (!envSettings.containsKey(SETTING_JITTERBIT_PASSWORD_TYPE)) {
            throw new CustomSettingManager.CustomSettingException('Custom Setting "Integration Settings" is missing an entry with type = "' + SETTING_JITTERBIT_PASSWORD_TYPE + '" and environment = ' + environmentName);
        }
    }

    public String syncQuoteHeaderToSap(SObject quoteSObj, Boolean async) {
        String userMessage = '';

        if (quoteSObj==null) {
            throw new QuoteSapSyncException(USER_MESSAGE_PREFIX_HEADER + USER_MESSAGE_PRECHECK_ERROR_QUOTE_NOT_FOUND);
        }

        getDataForHeaderCallout(quoteSObj);

        userMessage = headerCalloutPrecheck();

        if (userMessage=='') {
            Boolean isInsert = checkIfHeaderInsert();

            if (async) {
                executeHeaderCalloutAsync(quote.Id, JSON.serialize(quote), isInsert);

            } else {
                userMessage += executeHeaderCallout(quote.Id, JSON.serialize(quote), isInsert) + '; ';

            }

        } else {
            List<SBQQ__Quote__c> sfQuotesToUpsert = new List<SBQQ__Quote__c>{};

            userMessage = USER_MESSAGE_PREFIX_HEADER + userMessage;
            sfQuotesToUpsert.add(createQuoteObjForUpdate(quote.Id, SAP_RESULT_FAILED, userMessage, null, false));

            if (sfQuotesToUpsert.size() > 0) {
                SAPCreateQuoteDao.DaoResults daoQuoteResults = dao.upsertQuotes(sfQuotesToUpsert);

            }

        }

        return userMessage;
    }




    public String findSapCustomerFromOppty(SObject opptySObj) {
        String userMessage = '';
        sapCustomerNumber = '';

        if (opptySObj==null) {
            throw new QuoteSapSyncException(USER_MESSAGE_PREFIX_HEADER + USER_MESSAGE_PRECHECK_ERROR_OPPTY_NOT_FOUND);
        }

        List<SBQQ__Quote__c> sfQuotesToUpsert = new List<SBQQ__Quote__c>{};

        oppty = dao.fetchOpptyData(opptySObj!=null ? opptySObj.Id : null);

        if (oppty.Id==null) {
            throw new QuoteSapSyncException(USER_MESSAGE_PREFIX_HEADER + USER_MESSAGE_PRECHECK_ERROR_OPPTY_NOT_FOUND);
        }

        sapCustomerNumber = oppty.Account.SAP_Customer_Id__c;

        if (String.isBlank(sapCustomerNumber)) {
            Account acct = dao.fetchAccountData(oppty.AccountId);

            if (acct.EMEA_SAP_Quote_Ready__c) {

                SAPCreateCustomer scc = SAPCreateCustomer.CreateCustomer(acct.Id);

                Utils.logContents('scc',String.valueOf(scc));

                if (scc.isSuccess && !String.isBlank(scc.sapCustomerId)) {
                    sapCustomerNumber = scc.sapCustomerId;
                    userMessage += USER_MESSAGE_PREFIX_SAP_CUSTOMER_CREATED + sapCustomerNumber + '; ';

                } else {
                    userMessage += USER_MESSAGE_SAP_CUSTOMER_CREATE_FAILED + '; ' + scc.message;

                }

            } else {
                    userMessage += USER_MESSAGE_SAP_CUSTOMER_CREATE_FAILED + '; ' + acct.EMEA_SAP_Quote_Required_Data_Checklist__c;

            }

        } else {
            userMessage += USER_MESSAGE_PREFIX_SAP_CUSTOMER_FOUND + sapCustomerNumber + '; ';

        }

        return userMessage;
    }

    public String createSfQuoteFromOppty() {
        String userMessage = '';
        
        oppty = dao.fetchOpptyData(oppty.Id);
        
        if(!String.isBlank(sapCustomerNumber)) {
            SAPCreateQuoteDao.DaoResults daoResults = dao.upsertQuotes(createNewSfQuoteFromOppty(oppty));
            newQuoteId = null;

            if (daoResults.dbException!=null && !String.isBlank(daoResults.dbException.getMessage())) {
                userMessage += daoResults.dbException.getMessage();

            }

            if (daoResults.upsertResults!=null) {

                newQuoteId = extractSavedQuoteId(daoResults.upsertResults);

                if (newQuoteId==null) {
                    userMessage += extractSaveErrors(daoResults.upsertResults);

                } else {
                    userMessage += USER_MESSAGE_SF_QUOTE_CREATED + '; ';

                }

            } else {
                userMessage += USER_MESSAGE_SF_QUOTE_CREATE_NO_RESULTS + '; ';

            }

        } else {
            userMessage += USER_MESSAGE_SF_QUOTE_CREATE_FAILED_NO_SAP_CUSTOMER + '; ';

        }

        return userMessage;
    }

    public String syncNewQuoteToSap() {
        String userMessage = '';

        if (newQuoteId!=null) {
            userMessage += syncQuoteHeaderToSap(newQuoteId.getSObjectType().newSObject(newQuoteId), false);
        
        } else {
            userMessage += USER_MESSAGE_SF_QUOTE_CREATE_ID_NOT_FOUND + '; ';

        }

        return userMessage;

    }

    private List<SBQQ__Quote__c> createNewSfQuoteFromOppty(Opportunity oppty) {
        List<SBQQ__Quote__c> newQuotes = new List<SBQQ__Quote__c>{};
        newQuotes.add(new SBQQ__Quote__c(
            CurrencyIsoCode=oppty.CurrencyIsoCode, 
            Customer_Requested_Date__c=Date.today().addDays(30),
            Incoterms__c=oppty.Sales_Area_Data__r.Incoterm_Code_lookup__c,
            Incoterms2_Text__c = oppty.Account.BillingCity,
            Payment_Terms_SAP__c=oppty.Sales_Area_Data__r.Terms_of_Payment_lookup__c,
            SBQQ__Pricebook__c=oppty.Pricebook2Id,
            SBQQ__Account__c=oppty.AccountId,
            SBQQ__Opportunity2__c=oppty.Id,
            SBQQ__LineItemsGrouped__c=true,
            Ship_To_SAP_ID_Text__c=oppty.Select_Ship_To_SAD__r.Account__r.SAP_Customer_Id__c,
            Shipping_Conditions__c=oppty.Sales_Area_Data__r.Shipping_Conditions__c,
            Valid_From__c=Date.today(),
            Sales_Area_Data__c = oppty.Sales_Area_Data__c,
            SBQQ__ExpirationDate__c = Date.today().addDays(30),
            SBU__c = oppty.SBU__c, 
                        
            //Ship_To_Data__c = oppty.Ship_To_Data__c,
            Select_Ship_To_SAD__c = oppty.Select_Ship_To_SAD__c
            
        ));

        Utils.logContents('newQuotes', String.valueOf(newQuotes));

        return newQuotes;

    }

    private Id extractSavedQuoteId(Database.UpsertResult[] upsertResults) {
        Id returnId = null; 

        for (Database.UpsertResult ur : upsertResults)  {
            if (ur.isSuccess()) {
                returnId=ur.getId();

            }
        }

        ConfiguratorWSUtils.logContents('New Quote Id saved', String.valueOf(returnId));
        return returnId;
    }

    private String extractSaveErrors(Database.UpsertResult[] upsertResults) {
        Id returnError = null;  

        for (Database.UpsertResult ur : upsertResults)  {
            if (!ur.isSuccess()) {
                returnError += Utils.combineDataErrorMessages(ur.getErrors());

            }
        }

        ConfiguratorWSUtils.logContents('Quote save errors', String.valueOf(returnError));
        return returnError;
    }





    public void createSapCustomerAndQuoteFromAccount(SObject acctSObj) {
        
        if (acctSObj==null) {
            throw new QuoteSapSyncException(USER_MESSAGE_PREFIX_HEADER + USER_MESSAGE_PRECHECK_ERROR_ACCOUNT_NOT_FOUND);
        }

        List<SBQQ__Quote__c> sfQuotesToUpsert = new List<SBQQ__Quote__c>{};

        getDataForHeaderCalloutFromAccount(acctSObj);
    }

    @TestVisible
    private void getDataForHeaderCalloutFromAccount(SObject acctSObj) {
        Account acct = dao.fetchAccountData(acctSObj!=null ? acctSObj.Id : null);
        //user = dao.fetchUserData(UserInfo.getUserId());
    }




    public static void insertQuoteLinesIntoSap(Map<Id, SBQQ__Quote__c> mapQuotes, List<SBQQ__QuoteLine__c> newQuoteLines) {
        if (newQuoteLines!=null && newQuoteLines.size() > 0) {
            Map<Id, String> mapQuoteIdToSapQuoteNumber = createMapQuoteIdToSapQuoteNumber(mapQuotes);
            if (mapQuoteIdToSapQuoteNumber.size() == 1) {
                Id targetQuoteId=null;
                for (Id qId : mapQuoteIdToSapQuoteNumber.keySet()) {
                    targetQuoteId=qId;
                    SAPCreateQuoteDao dao = new SAPCreateQuoteDao();
                    SAPCreateQuoteDao.DaoResults daoQuoteResults = dao.upsertQuotes(new List<SBQQ__Quote__c>{createQuoteObjForUpdate(targetQuoteId, null, null, null, true)});

                }

                String targetSapQuoteNumber=mapQuoteIdToSapQuoteNumber.get(targetQuoteId);

                if (!String.isBlank(targetQuoteId) && !String.isBlank(targetSapQuoteNumber)) {
                    List<SBQQ__QuoteLine__c> relatedQuoteLines = findRelatedQuoteLines(targetQuoteId, newQuoteLines);

                    if (relatedQuoteLines.size() > 0) {
                        String relatedQuoteLinesJson = JSON.serialize(relatedQuoteLines);
                        executeLinesCalloutAsync(targetQuoteId, targetSapQuoteNumber, relatedQuoteLinesJson);

                    }

                }
            }

        }

    }

    private static Map<Id, String> createMapQuoteIdToSapQuoteNumber(Map<Id, SBQQ__Quote__c> mapQuotes) {
        Map<Id, String> returnMap = new Map<Id, String>{};
        if (mapQuotes!=null) {
            for (SBQQ__Quote__c q : mapQuotes.values()) {
                if (!String.isBlank(q.SAP_Quote_Number__c)) {
                    returnMap.put(q.Id, q.SAP_Quote_Number__c);

                }
            }

        }

        return returnMap;
    }

    private static List<SBQQ__QuoteLine__c> findRelatedQuoteLines(Id quoteId, List<SBQQ__QuoteLine__c> quoteLinesToUpsert) {
        List<SBQQ__QuoteLine__c> returnList = new List<SBQQ__QuoteLine__c>{};

        if (quoteLinesToUpsert!=null && quoteLinesToUpsert.size() > 0) {
            for (SBQQ__QuoteLine__c ql : quoteLinesToUpsert) {
                if (ql.SBQQ__Quote__c==quoteId) {
                    returnList.add(ql);

                }

            }

        }

        return returnList;

    }

    @TestVisible
    @Future(callout=true)
    private static void executeLinesCalloutAsync(Id quoteId, String sapQuoteNumber, String newQuoteLinesJson) {
        List<SBQQ__QuoteLine__c> newQuoteLines = (List<SBQQ__QuoteLine__c>)JSON.deserialize(newQuoteLinesJson, List<SBQQ__QuoteLine__c>.class);

        HttpRequest request = createHttpRequest(createLinesCalloutBodyText(sapQuoteNumber, newQuoteLines));

        HTTP auth = new HTTP();
        HTTPResponse authresp = auth.send(request);

        List<SBQQ__Quote__c> sfQuotesToUpsert = processHttpResponse(quoteId, authresp.getBody(), false, false);

        List<Database.UpsertResult> results = Database.upsert(sfQuotesToUpsert, SBQQ__Quote__c.Id, false);

    }

    @TestVisible
    private void getDataForHeaderCallout(SObject quoteSObj) {
        quote = dao.fetchQuoteData(quoteSObj!=null ? quoteSObj.Id : null);
        //user = dao.fetchUserData(UserInfo.getUserId());
    }

    private String headerCalloutPrecheck() {
        String userMessage = '';

        if (quote==null || quote.Id==null) {
            userMessage += USER_MESSAGE_PRECHECK_ERROR_QUOTE_NOT_FOUND;
        }

        //if (user==null) {
        //  userMessage += USER_MESSAGE_PRECHECK_ERROR_USER_NOT_FOUND;
        //}

        //String fields = '';

        //if (quote.Currency_Code__c == null) { // Formula based on CurrencyIsoCode
        //  fields += 'Currency_Code__c ';
        //}
        //if (quote.Customer_Requested_Date__c == null) {
        //  fields += 'Customer_Requested_Date__c ';
        //}
        //if (quote.Distribution_Channel__c == null) { // Formula based on Sales Area Data
        //  fields += 'Distribution_Channel__c ';
        //}
        //if (quote.Division__c == null) { // Formula based on Sales Area Data
        //  fields += 'Division__c ';
        //}
        //if (quote.Incoterms__r.Code__c == null) {
        //  fields += 'Incoterms__r.Code__c ';
        //}
        //if (quote.Incoterms2_Text__c == null) {
        //  fields += 'Incoterms2_Text__c ';
        //}
        //if (quote.Payment_Terms_SAP__r.Code__c == null) {
        //  fields += 'Payment_Terms_SAP__r.Code__c ';
        //}
        //if (quote.Sales_Area_data__c == null) { // Lookup
        //  fields += 'Sales_Area_data__c ';
        //}
        //if (quote.Sales_Office__c == null) { // Formula based on Sales Area Data
        //  fields += 'Sales_Office__c ';
        //}
        //if (quote.Sales_Organization__c == null) { // Formula based on Sales Area Data
        //  fields += 'Sales_Organization__c ';
        //}
        //if (quote.SBQQ__ExpirationDate__c == null) {
        //  fields += 'SBQQ__ExpirationDate__c ';
        //}
        //if (quote.Ship_To_Data__c == null) { // Lookup
        //  fields += 'Ship_To_Data__c ';
        //}
        //if (quote.Shipping_Conditions__r.Code__c == null) {
        //  fields += 'Shipping_Conditions__r.Code__c ';
        //}
        //if (quote.Valid_From__c == null) {
        //  fields += 'Valid_From__c ';
        //}

        //if (String.isNotEmpty(fields)) {
        //  userMessage += USER_MESSAGE_PRECHECK_ERROR_REQUIRED_FIELDS_NOT_FOUND;
        //  userMessage += ' ' + fields;
        //}

        if (!quote.EMEA_SAP_Ready__c) {
            userMessage += USER_MESSAGE_PRECHECK_ERROR_REQUIRED_FIELDS_NOT_FOUND + ' - ' + quote.EMEA_SAP_Required_Data_Checklist__c;
        }

        if (Test.isRunningTest()) {
            userMessage='';
        }

        return userMessage;
    }

    private Boolean checkIfHeaderInsert() {
        return String.isBlank(quote.SAP_Quote_Number__c);

    }

    @Future(callout=true)
    private static void executeHeaderCalloutAsync(Id quoteId, String quoteJson, Boolean isInsert) {
        executeHeaderCallout(quoteId, quoteJson, isInsert);

    }

    private static String executeHeaderCallout(Id quoteId, String quoteJson, Boolean isInsert) {
        String userMessage = '';

        SBQQ__Quote__c quote = (SBQQ__Quote__c)JSON.deserialize(quoteJson, SBQQ__Quote__c.class);

        HttpRequest request = createHttpRequest(createHeaderCalloutBodyText(quote, isInsert));

        HTTP auth = new HTTP();
        HTTPResponse authresp = auth.send(request);

        List<SBQQ__Quote__c> sfQuotesToUpsert = processHttpResponse(quoteId, authresp.getBody(), isInsert, true);

        List<Database.UpsertResult> results = Database.upsert(sfQuotesToUpsert, SBQQ__Quote__c.Id, false);

        for (SBQQ__Quote__c q : sfQuotesToUpsert) {
            userMessage += q.SAP_Sync_Last_Message__c + '; ';
        }

        return userMessage;
    }

    private static String createHeaderCalloutBodyText(SBQQ__Quote__c quote, Boolean isInsert) {

        String returnString = JSON.serialize(createSAPCreateQuotePayload(quote, isInsert), true);

        Utils.logContents('Request body sent to SAP', returnString);

        return returnString;
    }

    private static String createLinesCalloutBodyText(String sapQuoteNumber, List<SBQQ__QuoteLine__c> newQuoteLines) {

        String returnString = JSON.serialize(createSapCreateQuoteLinesPayload(sapQuoteNumber, newQuoteLines));

        Utils.logContents('Request body sent to SAP', returnString);

        return returnString;
    }

    @TestVisible
    private static SAPCreateQuotePayload createSapCreateQuoteLinesPayload(String sapQuoteNumber, List<SBQQ__QuoteLine__c> newQuoteLines) {

        Utils.logContents('newQuoteLines', String.valueOf(newQuoteLines));

        SAPCreateQuotePayload cqp = new SAPCreateQuotePayload();

        SAPQuoteRequest qr = new SAPQuoteRequest();

        qr.SALESDOCUMENTIN = sapQuoteNumber.leftPad(10,'0');

        SAPQuotationHeaderInx qhinx = new SAPQuotationHeaderInx();
        qhinx.UPDATEFLAG = 'U';
        qhinx.DOC_TYPE = 'X';

        SAPQuotationHeaderIn qhin = new SAPQuotationHeaderIn();
        qhin.DOC_TYPE = 'AG';

        List<SAPQuotationItemInx> itemsInx = new List<SAPQuotationItemInx>{};
        List<SAPQuotationItemIn> itemsIn = new List<SAPQuotationItemIn>{};
        List<SAPQuotationScheduleInx> schedInx = new List<SAPQuotationScheduleInx>{};
        List<SAPQuotationScheduleIn> schedIn = new List<SAPQuotationScheduleIn>{};
        List<SAPQuotationConditionInx> condInx = new List<SAPQuotationConditionInx>{};
        List<SAPQuotationConditionIn> condIn = new List<SAPQuotationConditionIn>{};

        for (SBQQ__QuoteLine__c ql : newQuoteLines) {

            String itemNumber = String.valueOf(Integer.valueOf(ql.SAP_Line_Number__c)).leftPad(6, '0');
            String materialNumber = formatMaterialNumber(ql.SAP_Material_Number__c);
            Decimal quantity = ql.SBQQ__Quantity__c;

            if (!String.isBlank(itemNumber) && !String.isBlank(materialNumber) && quantity <> 0.0) {
                SAPQuotationItemInx qiinx = new SAPQuotationItemInx();
                qiinx.ITM_NUMBER = itemNumber;
                qiinx.UPDATEFLAG = 'I';
                qiinx.MATERIAL = 'X';

                itemsInx.add(qiinx);

                SAPQuotationItemIn qiin = new SAPQuotationItemIn();
                qiin.ITM_NUMBER = itemNumber;
                qiin.MATERIAL = materialNumber;

                itemsIn.add(qiin);

                SAPQuotationScheduleInx qsinx = new SAPQuotationScheduleInx();
                qsinx.ITM_NUMBER = itemNumber;
                qsinx.UPDATEFLAG = 'I';
                qsinx.REQ_QTY = 'X';

                schedInx.add(qsinx);

                SAPQuotationScheduleIn qsin = new SAPQuotationScheduleIn();
                qsin.ITM_NUMBER = itemNumber;
                qsin.REQ_QTY = quantity;

                schedIn.add(qsin);

                SAPQuotationConditionInx qcinx = new SAPQuotationConditionInx();
                SAPQuotationConditionIn qcin = new SAPQuotationConditionIn();

            }

        }

        qr.QUOTATION_HEADER_INX = qhinx;
        qr.QUOTATION_HEADER_IN = qhin;
        qr.QUOTATION_ITEMS_INX = itemsInx;
        qr.QUOTATION_ITEMS_IN = itemsIn;
        qr.QUOTATION_SCHEDULES_INX = schedInx;
        qr.QUOTATION_SCHEDULES_IN = schedIn;
        qr.QUOTATION_CONDITIONS_INX = condInx;
        qr.QUOTATION_CONDITIONS_IN = condIn;

        cqp.quoteRequests = new List<SAPQuoteRequest>{qr};

        Utils.logContents('Quote Lines Payload', String.valueOf(cqp));

        return cqp;
    }

    private static String formatMaterialNumber(String rawMaterialNumber) {
        String returnNumber = null;
        if (rawMaterialNumber!=null) {
            if (rawMaterialNumber.isNumeric()) {
                returnNumber = rawMaterialNumber.leftPad(18, '0');

            } else {
                returnNumber = rawMaterialNumber;

            }

        }

        return returnNumber;
    }


    private static HTTPRequest createHttpRequest(String bodyText) {
        HTTPRequest r = new HTTPRequest();

        Map<String,Integration_Settings__c> settings = CustomSettingManager.fetchIntegrationEnvironmentSpecificSettingsMapByType();

        String contentType = 'application/json';

        Blob headerValue = Blob.valueOf(settings.get(SETTING_JITTERBIT_USERNAME_TYPE).Text_Value__c +':' +settings.get(SETTING_JITTERBIT_PASSWORD_TYPE).Text_Value__c);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);

        r.setEndpoint(settings.get(SETTING_JITTERBIT_URL_TYPE).Text_Value__c);
        r.setHeader('Authorization', authorizationHeader);
        r.setHeader('Content-Type', contentType);
        r.setMethod('POST');
        r.setBody(bodyText);

        return r;
    }

    private static SAPCreateQuotePayload createSAPCreateQuotePayload(SBQQ__Quote__c quote, Boolean isInsert) {
        SAPCreateQuotePayload cqp = new SAPCreateQuotePayload();

        SAPQuoteRequest qr = new SAPQuoteRequest();

        if (!isInsert && quote.SAP_Quote_Number__c!=null) {
            qr.SALESDOCUMENTIN = quote.SAP_Quote_Number__c.leftPad(10, '0');

        }

        qr.QUOTATION_PARTNERS = createQuotePartners(quote, isInsert);

        qr.QUOTATION_HEADER_INX = createQuotationHeaderInx(quote, isInsert);
        qr.QUOTATION_HEADER_IN = createQuotationHeaderIn(quote, isInsert);

        cqp.quoteRequests = new List<SAPQuoteRequest>{qr};

        Utils.logContents('Quote Header Payload', String.valueOf(cqp));

        return cqp;
    }

    private static List<SAPQuotationPartner> createQuotePartners(SBQQ__Quote__c quote, Boolean isInsert) {

        List<SAPQuotationPartner> returnList = new List<SAPQuotationPartner>{};

        if (isInsert) {
            SAPQuotationPartner qp1 = new SAPQuotationPartner();
            qp1.PARTN_ROLE = 'AG';
            qp1.PARTN_NUMB = quote.SBQQ__Account__r.SAP_Customer_Id__c;
            returnList.add(qp1);
        }

        SAPQuotationPartner qp2 = new SAPQuotationPartner();
        qp2.PARTN_ROLE = 'WE';
        
        //qp2.PARTN_NUMB = quote.Select_Ship_To_SAD__r.Account__r.SAP_Customer_Id__c;
        qp2.PARTN_NUMB = quote.Ship_To_SAP_ID_Text__c;
        
        returnList.add(qp2);

        if (quote.Your_Contact_in_the_Office__c!=null && !String.isBlank(quote.Your_Contact_in_the_Office__r.SAP_Personnel_ID__c)) {
            SAPQuotationPartner qp3 = new SAPQuotationPartner();
            qp3.PARTN_ROLE = 'ID';
            //qp3.PARTN_NUMB = '00101287';
            qp3.PARTN_NUMB = quote.Your_Contact_in_the_Office__r.SAP_Personnel_ID__c;
            returnList.add(qp3);

        }

        if (quote.Your_Sales_Contact__c!=null && !String.isBlank(quote.Your_Sales_Contact__r.SAP_Personnel_ID__c)) {
            SAPQuotationPartner qp4 = new SAPQuotationPartner();
            qp4.PARTN_ROLE = 'VE';
            //qp4.PARTN_NUMB = '00990071';
            qp4.PARTN_NUMB = quote.Your_Sales_Contact__r.SAP_Personnel_ID__c;
            returnList.add(qp4);

        }


        return returnList;

    }

    private static SAPQuotationHeaderInx createQuotationHeaderInx(SBQQ__Quote__c quote, Boolean isInsert) {
        SAPQuotationHeaderInx q = new SAPQuotationHeaderInx();

        q.DOC_TYPE = 'X';
        q.VERSION = 'X';

        if (isInsert) {
            q.COMPL_DLV = 'X';
            q.DISTR_CHAN = 'X';
            q.DIVISION = 'X';
            q.INCOTERMS1 = 'X';
            q.INCOTERMS2 = 'X';
            q.PMNTTRMS = 'X';
            q.QT_VALID_F = 'X';
            q.QT_VALID_T = 'X';
            q.REQ_DATE_H = 'X';
            q.SALES_OFF = 'X';
            q.SALES_ORG = 'X';
            q.SAP_CURRENCY = 'X';
            q.SHIP_COND = 'X';
            q.UPDATEFLAG = 'I';
            q.PURCH_NO_C = 'X';

        } else {
            q.INCOTERMS1 = 'X';
            q.INCOTERMS2 = 'X';
            q.QT_VALID_F = 'X';
            q.QT_VALID_T = 'X';
            q.REQ_DATE_H = 'X';
            q.UPDATEFLAG = 'U';
            q.PURCH_NO_C = 'X';

        }

        return q;
    }

    private static SAPQuotationHeaderIn createQuotationHeaderIn(SBQQ__Quote__c quote, Boolean isInsert) {
        SAPQuotationHeaderIn q = new SAPQuotationHeaderIn();

        q.DOC_TYPE = 'AG';
        q.VERSION = quote.Name;

        if (isInsert) {
            q.COMPL_DLV = 'X';
            q.DISTR_CHAN = quote.Distribution_Channel__c;
            q.DIVISION = quote.Division__c;
            q.INCOTERMS1 = quote.Incoterms__r.Code__c;
            q.INCOTERMS2 = quote.Incoterms2_Text__c;
            q.PMNTTRMS = quote.Payment_Terms_SAP__r.Code__c;
            q.QT_VALID_F = quote.Valid_From__c;
            q.QT_VALID_T = quote.SBQQ__ExpirationDate__c;
            q.PURCH_NO_C = quote.Reference_Information_Number__c;
            q.REQ_DATE_H = quote.Customer_Requested_Date__c;
            q.SALES_OFF = quote.Sales_Office__c;
            q.SALES_ORG = quote.Sales_Organization__c;
            q.SAP_CURRENCY = quote.Currency_Code__c;
            q.SHIP_COND = quote.Shipping_Conditions__r.Code__c;

        } else {
            q.INCOTERMS1 = quote.Incoterms__r.Code__c;
            q.INCOTERMS2 = quote.Incoterms2_Text__c;
            q.PMNTTRMS = quote.Payment_Terms_SAP__r.Code__c;
            q.QT_VALID_F = quote.Valid_From__c;
            q.QT_VALID_T = quote.SBQQ__ExpirationDate__c;
            q.PURCH_NO_C = quote.Reference_Information_Number__c;
            q.REQ_DATE_H = quote.Customer_Requested_Date__c;
            q.SHIP_COND = quote.Shipping_Conditions__r.Code__c;
        }

        return q;
    }

    @TestVisible
    private static List<SBQQ__Quote__c> processHttpResponse(Id quoteId, String rawBody, Boolean isInsert, Boolean isHeader) {
        String userMessagePrefix = isHeader? USER_MESSAGE_PREFIX_HEADER : USER_MESSAGE_PREFIX_LINES;

        Map<String,Integration_Settings__c> settings = CustomSettingManager.fetchIntegrationSettingsMapByName();
        Boolean saveRawSapResponse = settings.containsKey(SETTING_SAVE_RAW_SAP_RESPONSE)? settings.get(SETTING_SAVE_RAW_SAP_RESPONSE).Boolean_Value__c : false;

        List<SBQQ__Quote__c> sfQuotesToUpsert = new List<SBQQ__Quote__c>{};

        String sapResult = '';
        String sapMessage = '';
        String sapQuoteNumber = '';

        SAPResponses responsePayload = null;

        Try {
            responsePayload = parseSapResponse(rawBody);
            sapMessage += precheckSapResponsePayload(responsePayload);

        } Catch(Exception e) {
            sapResult = SAP_RESULT_FAILED;
            sapMessage += USER_MESSAGE_ERROR_SEE_SYS_ADMIN + '; ' + Utils.combineExceptionMessages(e);

        }

        Integer numPositiveResponses = 0;
        Integer numErrors = 0;
        String unexpectedResponses = '';

        if (sapMessage=='') {

            for (SAPReturn r : responsePayload.returns) {
                if (r.SAP_TYPE=='S' && r.ID=='V1' && r.SAP_NUMBER=='311') {
                    String successMessage = isInsert ? USER_MESSAGE_QUOTE_CREATED : USER_MESSAGE_QUOTE_UPDATED;
                    sapResult = SAP_RESULT_SUCCESS;
                    sapMessage += successMessage + r.MESSAGE_V2 + '; ';
                    // Use only the first sapQuoteNumber returned by SAP (in case somehow more than one)
                    if (sapQuoteNumber=='') {
                        sapQuoteNumber=r.MESSAGE_V2;

                    }
                    numPositiveResponses++;

                } else if (r.SAP_TYPE=='E') {
                    sapResult = SAP_RESULT_FAILED;
                    sapMessage += r.MESSAGE + '; ';
                    numErrors++;

                } else {
                    unexpectedResponses += r.MESSAGE + '; ';

                }
            }

            if (numPositiveResponses == 0) {
                if (numErrors > 0) {
                    if (isInsert) {
                        sapResult = SAP_RESULT_FAILED;
                        sapMessage += USER_MESSAGE_QUOTE_CREATE_FAILED_WITHIN_SAP + '; ';

                    } else {
                        sapResult = SAP_RESULT_FAILED;
                        sapMessage += USER_MESSAGE_QUOTE_UPDATE_FAILED_WITHIN_SAP + '; ';

                    }

                } else {
                    sapResult = SAP_RESULT_UNEXPECTED;
                    sapMessage += USER_MESSAGE_ERROR_SAP_RESPONSE_UNEXPECTED + ': ' + unexpectedResponses;

                }
            }

        } else {
            sapResult = SAP_RESULT_FAILED;

        }

        //if (saveRawSapResponse) {
        //  sapMessage+= '\n\n' + rawBody;

        //}

        if (isInsert && numPositiveResponses > 0) {
            sfQuotesToUpsert.add(createQuoteObjForUpdate(quoteId, sapResult, userMessagePrefix+sapMessage, rawBody, sapQuoteNumber));

        } else {
            sfQuotesToUpsert.add(createQuoteObjForUpdate(quoteId, sapResult, userMessagePrefix+sapMessage, rawBody, false));

        }

        return sfQuotesToUpsert;
    }


    @TestVisible
    private static SAPResponses parseSapResponse(String rawJson) {

        SAPResponses responses = null;

        if (!String.isBlank(rawJson)) {
            responses = (SAPResponses)JSON.deserialize(rawJson, SAPResponses.class);

        }

        Utils.logContents('responses', String.valueOf(responses));

        return responses;

    }

    private static String precheckSapResponsePayload(SAPResponses responsePayload) {
        String returnUserMsg = '';

        if (responsePayload!=null) {
            if (responsePayload.returns!=null && responsePayload.returns.size() > 0) {
                // Payload is Ok

            } else {
                returnUserMsg += USER_MESSAGE_ERROR_SAP_RESPONSE_NO_RETURN + '; ';

            }

        } else {
            returnUserMsg += USER_MESSAGE_ERROR_SAP_RESPONSE_NULL + '; ';

        }

        return returnUserMsg;
    }

    private static SBQQ__Quote__c createQuoteObjForUpdate(Id quoteId, String sapResult, String sapMessage, String sapResponse, String sapQuoteNumber) {
        return new SBQQ__Quote__c(Id=quoteId, SAP_Sync_Last_Datetime__c=Datetime.Now(), SAP_Sync_Last_Result__c=sapResult, SAP_Sync_Last_Message__c=sapMessage, SAP_Sync_Last_Response__c=sapResponse, SAP_Quote_Number__c=sapQuoteNumber, SAP_Sync_In_Progress__c=false);
    return null;
    }

    private static SBQQ__Quote__c createQuoteObjForUpdate(Id quoteId, String sapResult, String sapMessage, String sapResponse, Boolean sapSyncInProgress) {
        return new SBQQ__Quote__c(Id=quoteId, SAP_Sync_Last_Datetime__c=Datetime.Now(), SAP_Sync_Last_Result__c=sapResult, SAP_Sync_Last_Message__c=sapMessage, SAP_Sync_Last_Response__c=sapResponse, SAP_Sync_In_Progress__c=sapSyncInProgress);
    return null;
    }

    global class SAPCreateQuotePayload {
        public List<SAPQuoteRequest> quoteRequests { get; set; }

    }

    global class SAPQuoteRequest {
        public String SALESDOCUMENTIN { get; set; }
        public List<SAPQuotationPartner> QUOTATION_PARTNERS { get; set; }
        public SAPQuotationHeaderInx QUOTATION_HEADER_INX { get; set; }
        public SAPQuotationHeaderIn QUOTATION_HEADER_IN { get; set; }
        public List<SAPQuotationItemInx> QUOTATION_ITEMS_INX { get; set; }
        public List<SAPQuotationItemIn> QUOTATION_ITEMS_IN { get; set; }
        public List<SAPQuotationScheduleInx> QUOTATION_SCHEDULES_INX { get; set; }
        public List<SAPQuotationScheduleIn> QUOTATION_SCHEDULES_IN { get; set; }
        public List<SAPQuotationConditionInx> QUOTATION_CONDITIONS_INX { get; set; }
        public List<SAPQuotationConditionIn> QUOTATION_CONDITIONS_IN { get; set; }

    }

    global class SAPQuotationPartner {
        public String PARTN_ROLE { get; set; }
        public String PARTN_NUMB { get; set; }
        public String NAME { get; set; }
        public String STREET { get; set; }
        public String POSTL_CODE { get; set; }
        public String CITY { get; set; }
        public String COUNTR_ISO { get; set; }
        public String TELEX_NO { get; set; }

    }

    global class SAPQuotationHeaderInx {
        public String UPDATEFLAG { get; set; }
        public String DOC_TYPE { get; set; }
        public String SALES_ORG { get; set; }
        public String DISTR_CHAN { get; set; }
        public String DIVISION { get; set; }
        public String ORD_REASON { get; set; }
        public String SHIP_COND { get; set; }
        public String REQ_DATE_H { get; set; }
        public String QT_VALID_F { get; set; }
        public String QT_VALID_T { get; set; }
        public String INCOTERMS1 { get; set; }
        public String INCOTERMS2 { get; set; }
        public String COMPL_DLV { get; set; }
        public String SALES_OFF { get; set; }
        public String SAP_CURRENCY { get; set; }
        public String PMNTTRMS { get; set; }
        public String VERSION { get; set; }
        public String PURCH_NO_C { get; set; }

    }

    global class SAPQuotationHeaderIn {
        public String DOC_TYPE { get; set; }
        public String SALES_ORG { get; set; }
        public String DISTR_CHAN { get; set; }
        public String DIVISION { get; set; }
        public String ORD_REASON { get; set; }
        public String SHIP_COND { get; set; }
        public Date REQ_DATE_H { get; set; }
        public Date QT_VALID_F { get; set; }
        public Date QT_VALID_T { get; set; }
        public String INCOTERMS1 { get; set; }
        public String INCOTERMS2 { get; set; }
        public String COMPL_DLV { get; set; }
        public String SALES_OFF { get; set; }
        public String SAP_CURRENCY { get; set; }
        public String PMNTTRMS { get; set; }
        public String VERSION { get; set; }
        public String PURCH_NO_C { get; set; }

    }

    global class SAPQuotationItemInx {
        public String ITM_NUMBER { get; set; }
        public String UPDATEFLAG { get; set; }
        public String MATERIAL { get; set; }
        public String PLANT { get; set; }
        public String REQMTS_TYP { get; set; }
        public String SALES_UNIT { get; set; }
        public String SHIP_POINT { get; set; }

    }

    global class SAPQuotationItemIn {
        public String ITM_NUMBER { get; set; }
        public String MATERIAL { get; set; }
        public String PLANT { get; set; }
        public String REQMTS_TYP { get; set; }
        public String SALES_UNIT { get; set; }
        public String SHIP_POINT { get; set; }

    }

    global class SAPQuotationScheduleInx {
        public String ITM_NUMBER { get; set; }
        public String UPDATEFLAG { get; set; }
        public String REQ_QTY { get; set; }

    }

    global class SAPQuotationScheduleIn {
        public String ITM_NUMBER { get; set; }
        public Double REQ_QTY { get; set; }

    }

    global class SAPQuotationConditionInx {
        public String ITM_NUMBER { get; set; }
        public String UPDATEFLAG { get; set; }
        public String COND_TYPE { get; set; }
        public String COND_VALUE { get; set; }
        public String SAP_CURRENCY { get; set; }

    }

    global class SAPQuotationConditionIn {
        public String ITM_NUMBER { get; set; }
        public String COND_TYPE { get; set; }
        public Double COND_VALUE { get; set; }
        public String SAP_CURRENCY { get; set; }

    }

    global class SAPResponses {
        public List<SAPReturn> returns { get; set; }
        public List<SAPQuoteRequest> quoteRequests { get; set; }

    }

    global class SAPReturn {
        public String SAP_TYPE { get; set; }
        public String ID { get; set; }
        public String SAP_NUMBER { get; set; }
        public String LOG_NO { get; set; }
        public String LOG_MSG_NO { get; set; }
        public String MESSAGE { get; set; }
        public String MESSAGE_V1 { get; set; }
        public String MESSAGE_V2 { get; set; }
        public String MESSAGE_V3 { get; set; }
        public String MESSAGE_V4 { get; set; }
        public String PARAMETER { get; set; }
        public String ROW { get; set; }
        public String FIELD { get; set; }
        public String SAP_SYSTEM { get; set; }

    }

}