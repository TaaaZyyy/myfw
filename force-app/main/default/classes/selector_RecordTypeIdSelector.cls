public with sharing class selector_RecordTypeIdSelector {
    private static selector_RecordTypeIdSelector singleton = new selector_RecordTypeIdSelector();
    private Map<String, Id>  pool = new Map<String, Id>();

    private selector_RecordTypeIdSelector() {}

    public static UL_RecordTypeUtil getInstance() { return recordTypeUtil; }

    /**
    * オブジェクト名とレコードタイプ名を引数にしてレコードタイプIDを返却する
    */
    public Id getRecordTypeId( String objName, String recordTypeName ) {
        Id tRecordTypeId = pool.get( objName + '@' + recordTypeName );
        if ( tRecordTypeId == null ) {
            for ( RecordType rt : [
                                SELECT
                                    Id,
                                    DeveloperName,
                                    SObjectType
                                FROM
                                    RecordType
                                WHERE
                                    SObjectType = :objName
                                ] ) {
                String mapKey = rt.SObjectType + '@' + rt.DeveloperName;
                this.pool.put( mapKey, rt.Id );
                if ( recordTypeName == rt.DeveloperName ) { tRecordTypeId = rt.Id; }
            }
        }
        return ( tRecordTypeId != null ) ? tRecordTypeId : null;
    }
}