public with sharing class ul_FieldUtil {
    private ul_FieldUtil() {}

    /** 項目セットを項目名のリストに変換 */
    public static List<String> toFieldNameList(Schema.FieldSet fs) {
        List<String> fieldNames = new List<String>();
        for (Schema.FieldSetMember fsm : fs.getFields()) {
            fieldNames.add(fsm.getFieldPath());
        }
        return fieldNames;
    }
    
    
    /** 項目のトークンを項目名のセットに変換に変換 */
    public static Set<String> toFieldNameSet(Set<Schema.SObjectField> tokens) {
        Set<String> fieldNames = new Set<string>();
        for (Schema.SObjectField token : tokens) {
            fieldNames.add(token.getDescribe().getName());
        }
        return fieldNames;
    }
}
