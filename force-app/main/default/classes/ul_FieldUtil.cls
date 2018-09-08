public with sharing class ul_FieldUtil {
    private ul_FieldUtil() {}

    public static List<String> toFieldNameList(Schema.FieldSet fs) {
        List<String> fieldNames = new List<String>();
        for (Schema.FieldSetMember fsm : fs.getFields()) {
            fieldNames.add(fsm.getFieldPath());
        }
        return fieldNames;
    }
}
