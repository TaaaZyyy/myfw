/** 
* 動的SOSL作成用クラス
* まだ簡易版のみ
*/
public with sharing class selector_SoslSelector {
    private selector_SoslSelector() {}
    
    /** 動的SOSLの作成 */
    private static String buildSosl(String word, String searchGroup, Map<Schema.SObjectType, Set<Schema.SObjectField>> fieldsMap) {
        // バリデーション
        Set<String> searchGroupSet = new Set<String>{'ALL FIELDS','NAME FIELDS','EMAIL FIELDS','PHONE FIELDS','SIDEBAR FIELDS'};
        System.assert(searchGroupSet.contains(searchGroup), 'SOSL: 不正な Search Group名');

        // 動的SOSLの作成
        List<String> parts = new List<String>();
        parts.add('FIND \'' + String.escapeSingleQuotes(word) + '\'');
        parts.add('IN ' + searchGroup);

        List<String> fieldSpecs = new List<String>();
        for (Schema.SObjectType token_obj : fieldsMap.keySet()) {
            Set<Schema.SObjectField> tokens_field = fieldsMap.get(token_obj);
            if ((tokens_field == null) || tokens_field.isEmpty()) { continue; }

            String objName = token_obj.getDescribe().getName();
            // SOSLは同じ項目を複数含むとエラーになるため、一度Setにして重複をなくす
            List<String> fieldNames = new List<String>(ul_FieldUtil.toFieldNameSet(tokens_field));
            fieldSpecs.add(objName + '(' + String.join(fieldNames, ',') + ')');
        }
        if (!fieldSpecs.isEmpty()) {
            parts.add('RETURNING ' + String.join(fieldSpecs, ','));
        }

        String str = String.join(parts, ' ');
        System.debug(LoggingLevel.DEBUG, 'SOSL: ' + str);
        return str;
    }
}
