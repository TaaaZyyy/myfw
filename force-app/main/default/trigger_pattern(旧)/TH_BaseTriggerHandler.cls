/** トリガハンドラ基底クラス */
public virtual class TH_BaseTriggerHandler {
    protected String SOBJECT_NAME;
    protected boolean isExecuting = false; // Apexコードの現在のコンテキストがトリガのみかどうか
    protected integer batchSize   = 0;     // バッチサイズ

    public TH_BaseTriggerHandler(Boolean pIsExecuting, Integer pBatchSize) {
        this.isExecuting = pIsExecuting;
        this.batchSize   = pBatchSize;
    }


// ======================
//  DMLハンドラメソッド
// ======================
    /** 登録前処理 */
    public virtual void onBeforeInsert(List<SObject> newList) { System.debug(Logginglevel.INFO, '>>> ' + SOBJECT_NAME + '#onBeforeInsert'); }
    /** 登録後処理 */
    public virtual void onAfterInsert(List<SObject> newList, Map<Id, SObject> newMap) { System.debug(Logginglevel.INFO, '>>> ' + SOBJECT_NAME + '#onAfterInsert'); }
    /** 更新前処理 */
    public virtual void onBeforeUpdate(List<SObject> oldList, List<SObject> newList, Map<Id, SObject> oldMap, Map<Id, SObject> newMap) { System.debug(Logginglevel.INFO, '>>> ' + SOBJECT_NAME + '#onBeforeUpdate'); }
    /** 更新後処理 */
    public virtual void onAfterUpdate(List<SObject> oldList, List<SObject> newList, Map<Id, SObject> oldMap, Map<Id, SObject> newMap) { System.debug(Logginglevel.INFO, '>>> ' + SOBJECT_NAME + '#onAfterUpdate'); }
    /** 削除前処理 */
    public virtual void onBeforeDelete(List<SObject> oldList, Map<Id, SObject> oldMap) { System.debug(Logginglevel.INFO, '>>> ' + SOBJECT_NAME + '#onBeforeDelete'); }
    /** 削除後処理 */
    public virtual void onAfterDelete(List<SObject> oldList, Map<Id, SObject> oldMap) { System.debug(Logginglevel.INFO, '>>> ' + SOBJECT_NAME + '#onAfterDelete'); }
    /** 復元後処理 */
    public virtual void onUndelete(List<SObject> newList) { System.debug(Logginglevel.INFO, '>>> ' + SOBJECT_NAME + '#onUndelete'); }


// ======================================
//  トリガハンドラ内部処理用メソッド
// ======================================
    /** 項目値設定メソッド */
    protected List<SObject> putFieldValue(List<SObject> objList, Schema.SObjectField field, Object value) {
        for (SObject obj : objList) {
            obj.put(field, value);
        }
        return objList;
    }


    /** 複数レコードaddErrorメソッド */
    protected void addError(List<SObject> objs, String msg) {
        for (SObject obj : objs) {
            obj.addError(msg);
        }
    }


    /** ID変換メソッド */
    protected List<Id> toIdList(List<SObject> objs) {
        List<Id> idList = new List<Id>();
        for (SObject obj : objs) {
            idList.add(obj.Id);
        }
        return idList;
    }

// ===================
//  変更判定
// ===================
    /** newObj と oldObj の項目fieldの変更有無 */
    protected Boolean isChanged(SObject oldObj, SObject newObj, Schema.SObjectField field) {
        return newObj.get(field) != oldObj.get(field);
    }


    /** newObj と oldObj の 項目リストfieldsのいずれかの項目にに変更有無 */
    protected Boolean isChangedAnyFields(SObject oldObj, SObject newObj, List<Schema.SObjectField> fields) {
        for (Schema.SObjectField field : fields) {
            if (isChanged(oldObj, newObj, field)) {
                return true;
            }
        }
        return false;
    }


    /** newObj と oldObj の 項目リストfieldsのいずれかの項目にに変更有無 */
    protected Boolean isChangedAnyFields(SObject oldObj, SObject newObj, Schema.FieldSet fieldSet) {
        return isChangedAnyFields(oldObj, newObj, UL_FieldUtil.toFieldTokenList(fieldSet));
    }


// ===================
//  レコード抽出
// ===================
    /** レコード抽出メソッド */
    protected List<SObject> selectObjs(List<SObject> objList, Schema.SObjectField field, Object value) {
        List<SObject> targetObjs = new List<SObject>();
        for (SObject obj : objList) {
            if (obj.get(field) == value) {
                targetObjs.add(obj);
            }
        }
        return targetObjs;
    }


    /** newMap のうち 項目fieldに変更があるオブジェクトのリストを返却する */
    protected List<SObject> selectChangedObjs(Map<Id, SObject> oldMap, Map<Id, SObject> newMap, Schema.SObjectField field) {
        return selectChangedObjsAnyFields(oldMap, newMap, new List<Schema.SObjectField>{ field }, true);
    }


    /** newMap のうち 項目リストfieldsのいずれかの項目にに変更があるオブジェクトのリストを返却する */
    protected List<SObject> selectChangedObjsAnyFields(Map<Id, SObject> oldMap, Map<Id, SObject> newMap, List<Schema.SObjectField> fields) {
        return selectChangedObjsAnyFields(oldMap, newMap, fields, true);
    }


    /** newMap のうち 項目リストfieldsのいずれかの項目にに変更があるオブジェクトのリストを返却する */
    protected List<SObject> selectChangedObjsAnyFields(Map<Id, SObject> oldMap, Map<Id, SObject> newMap, Schema.FieldSet fieldSet) {
        return selectChangedObjsAnyFields(oldMap, newMap, UL_FieldUtil.toFieldTokenList(fieldSet), true);
    }


    /** newMap のうち 項目tokenに変更があり、値がvalueのオブジェクトのリストを返却する */
    protected List<SObject> selectChangedObjs(Map<Id, SObject> oldMap, Map<Id, SObject> newMap, Schema.SObjectField field, Object value) {
        List<SObject> tList = new List<SObject>();
        for (Id objId : newMap.keySet()) {
            if (newMap.get(objId).get(field) != value) { continue; }

            if (isChanged(oldMap.get(objId), newMap.get(objId), field)) {
                tList.add(newMap.get(objId));
            }
        }
        return tList;
    }


    protected List<SObject> selectChangedObjsAnyFields(Map<Id, SObject> oldMap, Map<Id, SObject> newMap, List<Schema.SObjectField> fields, Boolean isNew) {
        List<SObject> tList = new List<SObject>();
        for (Id objId : newMap.keySet()) {
            SObject oldObj = oldMap.get(objId);
            SObject newObj = newMap.get(objId);

            for (SObjectField field : fields) {
                if (isChanged(oldObj, newObj, field)) {
                    if (isNew) {
                        tList.add(newObj);
                    } else {
                        tList.add(oldObj);
                    }
                    break;
                }
            }
        }
        return tList;
    }
}
