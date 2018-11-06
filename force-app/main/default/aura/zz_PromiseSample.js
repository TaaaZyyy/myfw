({
  handleCreatePurchases : function(component) {
    this.handlePromise(() => this.createPurchases(component), component)
  },

  handleCreateBillings : function(component) {
    this.handlePromise(() => this.createBillings(component), component);
  },



  handlePromise : function(promise, component) { // 仮引数に関数をもたせられる
    // 多重実行防止(ボタンの非活性化とスピナーの表示)
    component.set("v.showSpinner","true");
    component.set("v.disabled","true");

    promise(component)
    .then($A.getCallback(() => {   // $A.getCallbackがないと画面に反映されない
      return this.setDisabled(component);  // Promiseオブジェクトを返すことでチェーンがつながる
    }))
    .then($A.getCallback(() => {
      component.set("v.showSpinner","false");
      return Promise.resolve(); // 特に処理はなく、チェーンだけつなげたいときの書き方
    }))
    .catch(errors => { // rejectはここで処理する
      console.log`error: ${JSON.stringify(errors)}`;
      $A.reportError("エラーが発生しました", errors);
    });
  },


  setDisabled : function(component) { // 非同期を同期的に扱いたいときはPromiseを返すようにする
    return new Promise($A.getCallback((resolve, reject) =>{
      let action = component.get("c.getOrderHasChildMap");
      action.setParams({"orderId": component.get("v.recordId")});
      action.setCallback(this, function(response) {
        let state = response.getState();

        if (state === "SUCCESS") {
          let disabledMap = response.getReturnValue();
          component.set("v.disabledCreatePurchases", disabledMap["purchase"]);
          component.set("v.disabledCreateBillings", disabledMap["billing"]);
          resolve();

        } else if (state === "ERROR") {
          reject(response.getError());
        }
      });
      $A.enqueueAction(action);
    }));
  },


  createPurchases : function(component) {
    return new Promise($A.getCallback((resolve, reject) => {
      let action = component.get("c.createPurchases");
      action.setParams({"orderId": component.get("v.recordId")});
      action.setCallback(this, function(response) {
        let state = response.getState();

        if (state === "SUCCESS") {
          this.dispSuccessMsg("仕入");
          $A.get("e.force:refreshView").fire();

        } else if (state === "ERROR") {
          this.dispErrorMsg(response);
        }
        resolve();
      });
      $A.enqueueAction(action);
    }));
  },


  createBillings : function(component) {
    return new Promise($A.getCallback((resolve, reject) => {
      let action = component.get("c.createBillings");
      action.setParams({"orderId": component.get("v.recordId")});
      action.setCallback(this, function(response) {
        let state = response.getState();

        if (state === "SUCCESS") {
          this.dispSuccessMsg("請求");
          $A.get("e.force:refreshView").fire();

        } else if (state === "ERROR") {
          this.dispErrorMsg(response);
        }
        resolve();
      });
      $A.enqueueAction(action);
    }));
  },


  dispSuccessMsg : function(objName) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
        "message": `${objName}レコードを作成しました`,
        "type": "success"
    });
    toastEvent.fire();
  },


  dispErrorMsg : function(response) {
    let errors = response.getError();
    console.log`error: ${JSON.stringify(errors)}`;
    let toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
      "message": `エラーが発生しました: ${errors[0].message}`,
      "type": "error"
    });
    toastEvent.fire();
  },
})