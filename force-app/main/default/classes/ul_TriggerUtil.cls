public with sharing class ul_TriggerUtil {
    private ul_TriggerUtil() {}
    
    /** newObj と oldObj の項目fieldの変更有無 */
    public static Boolean isChanged(SObject oldObj, SObject newObj, Schema.SObjectField field) {
        return newObj.get(field) != oldObj.get(field);
    }
    
    
    
    /** newMap のうち 項目fieldに変更があるオブジェクトのリストを返却する */
    public static List<SObject> selectChangedObjs(Map<Id, SObject> oldMap, Map<Id, SObject> newMap, Schema.SObjectField field) {
        List<SObject> tList = new List<SObject>();
        for (Id objId : newMap.keySet()) {
            if (isChanged(oldMap.get(objId), newMap.get(objId), field)) {
                tList.add(newMap.get(objId));
            }
        }
        return tList;
    }
    
    
    
    /** newMap のうち 項目tokenに変更があり、値がvalueのオブジェクトのリストを返却する */
    public static List<SObject> selectChangedObjs(Map<Id, SObject> oldMap, Map<Id, SObject> newMap, Schema.SObjectField field, Object value) {
        List<SObject> tList = new List<SObject>();
        for (Id objId : newMap.keySet()) {
            if (newMap.get(objId).get(field) != value) { continue; }

            if (isChanged(oldMap.get(objId), newMap.get(objId), field)) {
                tList.add(newMap.get(objId));
            }
        }
        return tList;
    }
    
    
    
    /** 項目値設定メソッド */
    public static List<SObject> putFieldValue(List<SObject> objList, Schema.SObjectField field, Object value) {
        for (SObject obj : objList) {
            obj.put(field, value);
        }
        return objList;
    }
}
