public class FioriCanvasLifecycleHandler implements Canvas.CanvasLifecycleHandler {
    
    private Map<String, String> languageToISOCode = new Map<String, String> { 'English' => 'en',
                                                                              'German' => 'de',
                                                                              'Dutch' => 'nl',
                                                                              'French' => 'fr',
                                                                              'Italian' => 'it',
                                                                              'Swedish' => 'sv',
                                                                              'Polish' => 'pl',
                                                                              'Bulgarian' => 'bg',
                                                                              'Russian' => 'ru',
                                                                              'Danish' => 'da',
                                                                              'Finnish' => 'fi',
                                                                              'Czech' => 'cz',
                                                                              'Slovak' => 'sk',
                                                                              'Norwegian' => 'no',
                                                                              'Turkish' => 'tr'};
    
    public Set<Canvas.ContextTypeEnum> excludeContextTypes(){
        Set<Canvas.ContextTypeEnum> excluded = new Set<Canvas.ContextTypeEnum>();

        // Code goes here to add items to excluded list
        // that should be excluded from Context data
        excluded.add(Canvas.ContextTypeEnum.ORGANIZATION);
        excluded.add(Canvas.ContextTypeEnum.USER);
        excluded.add(Canvas.ContextTypeEnum.RECORD_DETAIL);

        return excluded;
    }

    public void onRender(Canvas.RenderContext renderContext) {
        // Get the Application and Environment context from the RenderContext
        Canvas.ApplicationContext app = renderContext.getApplicationContext();
        Canvas.EnvironmentContext env = renderContext.getEnvironmentContext();

        // Get current custom params
        Map<String, Object> currentParams = (Map<String, Object>) JSON.deserializeUntyped(env.getParametersAsJSON());
        System.debug('Environment Context custom paramters: ' + currentParams);
        
        String recordId;
        String lang;
        if(currentParams.containsKey('recordId')) {
            recordId = (String) currentParams.get('recordId');
        } else {
            throw new Canvas.CanvasRenderException(Label.Fiori_Canvas_No_Record_Id_Specified);      
        }
    
        if(currentParams.containsKey('lang')) {
            lang = (String) currentParams.get('lang');  
        }
    
        // Override app URL to include record Id
        List<Fiori_Canvas_Settings__mdt> canvasSettings = [ SELECT Record_URL__c FROM Fiori_Canvas_Settings__mdt WHERE DeveloperName = 'Default' ];
        if(canvasSettings.isEmpty()) {
            throw new Canvas.CanvasRenderException(Label.Fiori_Canvas_No_Default_URL_Specified);
        }
        
        String url = canvasSettings[0].Record_URL__c.subStringAfter('https://').subStringAfter('/').replace('%ID%', recordId);
        
        // add language param
        if(!String.isEmpty(lang) && languageToISOCode.containsKey(lang)) {
            url += '&lang=' + languageToISOCode.get(lang).toUpperCase();
        }
        
        system.debug(url);
        
        app.setCanvasUrlPath('/'+url);
    }
}