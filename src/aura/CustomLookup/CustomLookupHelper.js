({	

	searchHelper : function(component,event,getInputkeyWord) {
	  // call the apex class method 
     var action = component.get("c.fetchLookupValues");
      // set param to method  
        action.setParams({
            'searchKeyword': getInputkeyWord,
            'objectName' : component.get("v.objectAPIName"),
            'filter' : component.get("v.filter")
          });
      // set a callBack    
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
              // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecords", storeResponse);
            }
 
        });
      // enqueue the Action  
        $A.enqueueAction(action);
    
	},
})