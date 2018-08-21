public with sharing class selector_AccountSelector extends selector_SObjectSelector {

    private selector_AccountSelector(){}

// =====================
// インスタンスの作成
// =====================
    public static selector_AccountSelector getInstance() {
        selector_AccountSelector objectSelector = new selector_AccountSelector();
        objectSelector.sObjectType = Account.sObjectType;
        return objectSelector;
    }
    public static selector_AccountSelector getInstanceForSubquery(Schema.ChildRelationship pRelationship) {
        selector_AccountSelector objectSelector = new selector_AccountSelector();
        objectSelector.relationship = pRelationship;
        return objectSelector;
    }


// =====================
// クエリの発行
// =====================
    public List<Account> queryByIds(Set<Id> wcmIdSet) {
        return (List<Account>) querySObjectByIds(wcmIdSet);
    }
    public List<Account> query() {
        return (List<Account>) querySObject();
    }
}