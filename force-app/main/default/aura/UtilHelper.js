({
  dispErrorMsg : function(response) {
    let errors = response.getError();
    let errorMessage = (errors[0].message !== void 0) ? errors[0].message : errors[0].pageErrors[0].message;
    console.log`error: ${JSON.stringify(errors)}`;

    let toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
      "message": `エラーが発生しました: ${errorMessage}`,
      "type": "error"
    });
    toastEvent.fire();
  },
})
