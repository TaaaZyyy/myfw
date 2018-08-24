public abstract with sharing class selector_SObjectSelector {

    // SOQL部品
    protected Set<String> fields;
    protected Set<DA_QueryFactory> subqueries;
    protected Schema.SObjectType sObjectType; // ベースクエリのとき設定
    protected Schema.ChildRelationship relationship; // サブクエリのとき設定
    protected String filter;
    protected String order;
    protected Integer limitCount;
    protected Integer offsetCount;



// =====================
// クエリの発行
// =====================
    /** 引数に設定したIDのレコードを取得する */
    public List<SObject> querySObjectByIds(Set<Id> idSet) {
        return (List<SObject>) Database.query(buildQueryByIds());
    }


    public Database.QueryLocator getQueryLocatorByIds(Set<Id> idSet) {
        return Database.getQueryLocator(buildQueryByIds());
    }


    /** メンバ変数に設定した条件を使用してクエリを発行する */
    public List<SObject> querySObject() {
        return (List<SObject>) Database.query(buildQuery());
    }


    public Database.QueryLocator getQueryLocator() {
        return Database.getQueryLocator(buildQuery());
    }


    /** 指定した項目に設定されている値を重複を削除して返却する */
    public List<Object> queryAllValueOf(Schema.SObjectField field) {
        return queryAllValueOf(field.getDescribe().getName());
    }
    
    public List<Object> queryAllValueOf(String fieldName) {
        String tmpFilter = (String.isNotBlank(getFilter())) ? getFilter() + ' AND ' : '';
        tmpFilter += fieldName + ' != null';
        
        String tmpOrder = (String.isNotBlank(getOrder())) ? getOrder() : fieldName + ' ASC';

        String query = '' +
                'SELECT ' +
                    fieldName + ' ' +
                'FROM ' +
                    sObjectType.getDescribe().getName() + ' ' +
                'WHERE ' +
                    tmpFilter + ' ' +
                'GROUP BY ' +
                    fieldName + ' ' +
                'ORDER BY ' +
                    tmpOrder;

        List<Object> valueList = new List<Object>();
        for (AggregateResult ar : (List<AggregateResult>) Database.query(query)) {
            valueList.add(ar.get(fieldName));
        }

        return valueList;
    }



// =====================
// クエリのそれぞれの句を設定・取得
// =====================
    public void setFields(Set<String> fieldSet) {
        this.fields = fieldSet;
    }
    public void addFields(Set<String> fieldNames) {
        if (fields == null) {
            setFields(fieldNames);
        } else {
            this.fields.addAll(fieldNames);
        }
    }

    public void setSubquery(selector_SObjectSelector subquerySelector) {
        System.assert(this.relationship == null, 'サブクエリは1階層までしか設定できません');
        this.subqueries = new Set<DA_QueryFactory>{subquerySelector.createQueryFactoryOfsubquery()};
    }
    public void addSubquery(selector_SObjectSelector subquerySelector) {
        System.assert(this.relationship == null, 'サブクエリは1階層までしか設定できません');
        if (subqueries == null) {
            setSubquery(subquerySelector);
        } else {
            this.subqueries.add(subquerySelector.createQueryFactoryOfsubquery());
        }
    }

    public void setFilter(String pFilter) {
        this.filter = pFilter;
    }
    public String getFilter() {
        return this.filter;
    }

    public void setOrder(String pOrder) {
        this.order = pOrder;
    }
    public String getOrder() {
        return this.order;
    }

    public void setLimitCount(Integer pLimitCount) {
        this.limitCount = pLimitCount;
    }

    public void setOffsetCount(Integer pOffsetCount) {
        this.limitCount = pOffsetCount;
    }

    /** filterとorderの一括設定 */
    public void setCondition(DA_QueryConditionContainer queryConditionContainer) {
        setFilter(queryConditionContainer.getQueryFilter());
        setOrder(queryConditionContainer.getQueryOrder());
    }



// =====================
// クエリファクトリを作成
// =====================
    // サブクエリとして使用されるときのQueryFactoryを作成する
    public DA_QueryFactory createQueryFactoryOfsubquery() {
        return createQueryFactory();
    }

    public DA_QueryFactory createQueryFactory() {
        DA_QueryFactory queryFactory = DA_QueryFactory.createQueryFactory(SObjectType);

        if (fields != null) {
            queryFactory.setFields(this.fields);
        } else {
            queryFactory.setFields(new Set<String>{'Id'});
        }

        if (subqueries != null)  {
            queryFactory.setSubselectQueries(this.subqueries);
        }

        if (filter != null) {
            queryFactory.setFilter(this.filter);
        }

        if (order != null) {
            queryFactory.setOrder(this.order);
        }

        if (limitCount != null) {
            queryFactory.setLimitCount(this.limitCount);
        }

        if (offsetCount != null) {
            queryFactory.setOffsetCount(this.offsetCount);
        }
        return queryFactory;
    }



// =====================
// クエリを作成
// =====================
    private String buildQueryByIds() {
        DA_QueryFactory queryFactory = createQueryFactory();
        queryFactory.setFilter('id IN :idSet');
        return queryFactory.toSoql();
    }
    
    private String buildQuery() {
        return createQueryFactory().toSoql();
    }
}
