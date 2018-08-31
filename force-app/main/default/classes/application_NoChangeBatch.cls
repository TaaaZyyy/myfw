/** 空更新バッチ */
global with sharing class application_NoChangeBatch implements Database.Batchable<SObject>, Database.stateful {
    global static final Integer BATCH_SIZE = 200;
    private Schema.SObjectType sObjectType;
    private String condition;


    global application_NoChangeBatch(Schema.SObjectType pSObjectType) {
        this.sObjectType = pSObjectType;
    }


    global application_NoChangeBatch(Schema.SObjectType pObjectType, String pCondition) {
        this(pObjectType);
        this.condition = pCondition;
    }


    /** 開始メソッド */
    global Database.QueryLocator start(Database.BatchableContext BC) {
        System.debag('### start ###');

        String query = '';
        query += 'SELECT '             ;
        query +=     'Id '              ;
        query += 'FROM '               ;
        query +=     sObjectType.getDescribe().getName() + ' '  ;
        query += condition             ;

        return Database.getQueryLocator(query);
    }


    /** 実行メソッド */
    global void execute(Database.BatchableContext BC, List<SObject> objects) {
        System.debug('### execute ###');
        update objects;
    }


    /** 終了メソッド */
    global void finish(Database.BatchableContext BC) {
        System.debug('### finish ###');
    }
}
