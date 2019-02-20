public with sharing class ul_TriggerUtil {
    private ul_TriggerUtil() {}
    
    /** newObj と oldObj の項目tokenの変更有無 */
    private Boolean isChanged(SObject oldObj, SObject newObj, Schema.SObjectField token) {
        return newObj.get(token) != oldObj.get(token);
    }
    
    
    
    /** newMapのうちtokenに変更があるオブジェクトを返却する */
    /*
    private Map<Id, Order> selectChangedObjMap(Map<Id, Order> oldMap, Map<Id, Order> newMap, Schema.SObjectField token) {
        Map<Id, Order> targetMap = new Map<Id, Order>();
        for (Id objId : newMap.keySet()) {
            if (isChanged(oldMap.get(objId), newMap.get(objId), token)) {
                targetMap.put(objId, newMap.get(objId));
            }
        }
        return targetMap;
    }
    */



    /** newMapのうちtokenに変更があり、値がvalueのオブジェクトを返却する */
    /*
    private Map<Id, Order> selectChangedObjMap(Map<Id, Order> oldMap, Map<Id, Order> newMap, Schema.SObjectField token, Object value) {
        Map<Id, Order> targetMap = new Map<Id, Order>();
        for (Id objId : newMap.keySet()) {
            if (newMap.get(objId).get(token) != value) { continue; }

            if (isChanged(oldMap.get(objId), newMap.get(objId), token)) {
                targetMap.put(objId, newMap.get(objId));
            }
        }
        return targetMap;
    }
    */
    
    
    
    /** 項目値設定メソッド */
    private static List<SObject> putFieldValue(List<SObject> objList, Schema.SObjectField field, Object value) {
        for (SObject obj : objList) {
            obj.put(field, value);
        }
        return objList;
    }
