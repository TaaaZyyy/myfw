public with sharing class ul_FieldUtil {
    private ul_FieldUtil() {}

    /**
     * 入力判定判定
     *
     * 項目セットの値がすべて入力済み(Booleanの場合はtrue)のとき、trueを返却する
     * 空の項目セットが設定された場合、trueを返却する
     */
    public static Boolean hasValue(SObject obj, Schema.FieldSet fs) {
        Boolean targetValue;
        List<Schema.SObjectField> fieldList = toFieldTokenList(fs);
        for (Schema.SObjectField token : fieldList) {
            if (isBoolean(token)) {
                if (!(Boolean) obj.get(token)) { return false; }
            } else {
                if (obj.get(token) == null) { return false; }
            }
        }
        return true;
    }


    /** 項目セットをトークンに変換 */
    public static List<Schema.SObjectField> toFieldTokenList(Schema.FieldSet fs) {
        List<Schema.SObjectField> tList = new List<Schema.SObjectField>();
        for (Schema.FieldSetMember fsm : fs.getFields()) {
            tList.add(fsm.getSObjectField());
        }
        return tList;
    }


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


    /** 項目種別判定 : Boolean */
    private static Boolean isBoolean(Schema.SObjectField field) {
        return (field.getDescribe().getType() == Schema.DisplayType.Boolean);
    }
}
