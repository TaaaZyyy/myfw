({
  dispErrorMsg : function(response) {
    let errors = response.getError();
    console.log`error: ${JSON.stringify(errors)}`;
    let toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
      "message": `エラーが発生しました: ${errors[0].pageErrors[0].message}`,
      "type": "error"
    });
    toastEvent.fire();
  },
})
