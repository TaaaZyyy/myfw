public with sharing class selector_AccountHistorySelector extends selector_SObjectSelector {
    public selector_AccountHistorySelector() {}

// =====================
// インスタンスの作成
// =====================
    public static selector_AccountHistorySelector getInstance() {
        selector_AccountHistorySelector objectSelector = new selector_AccountHistorySelector();
        objectSelector.sObjectType = Account__History.sObjectType;
        return objectSelector;
    }


// =====================
// クエリの発行
// =====================
    public List<Account__History> query() {
        return (List<Account__History>) querySObject();
    }
}