/**
* クエリ作成ファイル
* selector_SObjectSelectorクラスで扱う
* SELECTのサブクエリは入れ子にして使用（subselectQueryMap）
*/
public with sharing class selector_QueryFactory {
    private selector_QueryFactory() {}

    // SELECT
    private Set<String> fields;
    private Map<Schema.ChildRelationship, selector_QueryFactory> subselectQueryMap;
    // FROM
    private Schema.SObjectType table; // ベースクエリのとき設定
    private Schema.ChildRelationship relationship; // サブクエリのとき設定
    // WHERE
    private String filter;
    // ORDER BY
    private String order;
    // LIMIT
    private Integer limitCount;
    // OFFSET
    private Integer offsetCount;



// =====================
// インスタンス作成
// =====================
    /** ベースクエリを作成する */
    public static selector_QueryFactory createQueryFactory(Schema.SObjectType pTable) {
        return new selector_QueryFactory().setTable(pTable);
    }
    /** サブクエリを作成する */
    public static selector_QueryFactory createSubqueryFactory(Schema.ChildRelationship pRelationship) {
        return new selector_QueryFactory().setRelationship(pRelationship);
    }



// =====================
// SELECT句 を設定
// =====================
    public void setFields(Set<String> fieldNames) {
        this.fields = fieldNames;
    }



// =====================
// SELECT句（サブクエリ）を設定
// =====================
    public void setSubselectQueries(Set<selector_QueryFactory> subselectQueries) {
        System.assert(this.relationship == null, 'サブクエリは1階層までしか設定できません');
        this.subselectQueryMap = new Map<Schema.ChildRelationship, selector_QueryFactory>();
        for (selector_QueryFactory subselectQuery : subselectQueries) {
            this.subselectQueryMap.put(subselectQuery.getRelationship(), subselectQuery);
        }
    }



// =====================
// FROM句 を設定・取得
// =====================
    private selector_QueryFactory setTable(Schema.SObjectType pTable) {
        this.table = pTable;
        return this;
    }
    private selector_QueryFactory setRelationship(Schema.ChildRelationship pRelationship) {
        this.relationship = pRelationship;
        return this;
    }
    public Schema.ChildRelationship getRelationship() {
        return relationship;
    }



// =====================
// WHERE句 を設定・取得
// =====================
    public void setFilter(String pFilter) {
        this.filter = pFilter;
    }
    public String getFilter() {
        return this.filter;
    }



// =====================
// ORDER BY句 を設定・取得
// =====================
    public void setOrder(String pOrder) {
        this.order = pOrder;
    }
    public String getOrder() {
        return this.order;
    }



// =====================
// LIMIT句 を設定
// =====================
    public void setLimitCount(Integer pLimitCount) {
        this.limitCount = pLimitCount;
    }



// =====================
// OFFSET句 を設定
// =====================
    public void setOffsetCount(Integer pOffsetCount) {
        this.limitCount = pOffsetCount;
    }



// =====================
// クエリを作成
// =====================
    public String toSoql() {
        String result = 'SELECT ';

        // fields
        if ((fields != null) && !fields.isEmpty()) {
            result += String.join(new List<String>(fields), ', ');
        }

        // subselector
        if ((subselectQueryMap != null) && (!subselectQueryMap.isEmpty())) {
            for (selector_QueryFactory childQuery : subselectQueryMap.values()) {
                result += ', (' + childQuery.toSOQL() + ')';
            }
        }

        // table または relationship
        result += ' FROM ';
        result += (relationship != null) ? relationship.getRelationshipName() : table.getDescribe().getName();

        // filter
        if (String.isNotEmpty(filter)) {
            result += ' WHERE ' + filter;
        }

        // orders
        if (String.isNotEmpty(order)) {
            result += ' ORDER BY ' + order;
        }

        // limitCount
        if (limitCount != null) {
            result += ' LIMIT ' + limitCount;
        }

        // offsetCount
        if (offsetCount != null) {
            result += ' OFFSET ' + offsetCount;
        }

        return result;
    }
}