({
  dispErrorMsg : function(response) {
    let errors = response.getError();
    let errorMessage = (errors[0].message !== void 0) ? errors[0].message : errors[0].pageErrors[0].message;
    console.log`error: ${JSON.stringify(errors)}`;
    this.dispErrorMsg(`エラーが発生しました: ${errorMessage}`);
  },
  
  
  dispSuccessMsg : function(message) {
    let toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
      "message": message,
      "type": "success"
    });
    toastEvent.fire();
  },


  dispErrorMsg : function(message) {
    let toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
      "message": message,
      "type": "error"
    });
    toastEvent.fire();
  },


  dispMsg : function(msg, type, data) {
    let toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
      "message": msg,
      "messageTemplate": msg, // 'Record {0} created! See it {1}!',
      "messageTemplateData": data, // ['Salesforce', {url: 'http://www.salesforce.com/',label: 'here',}],
      "type": type,
    });
    toastEvent.fire();
  },
})
