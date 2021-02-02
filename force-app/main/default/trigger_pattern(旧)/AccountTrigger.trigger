/** 取引先トリガ */
trigger AccountTrigger on Account (
        before insert,
        after  insert,
        before update,
        after  update,
        before delete,
        after  delete,
        after  undelete) {

    TH_AccountTriggerHandler handler = new TH_AccountTriggerHandler(Trigger.isExecuting, Trigger.size);

    UL_Logger.info('start AccountTrigger ' + Trigger.operationType);
    switch on Trigger.operationType {
        when BEFORE_INSERT  { handler.onBeforeInsert(Trigger.new                                             ); }
        when AFTER_INSERT   { handler.onAfterInsert( Trigger.new,                              Trigger.newMap); }
        when BEFORE_UPDATE  { handler.onBeforeUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap); }
        when AFTER_UPDATE   { handler.onAfterUpdate( Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap); }
        when BEFORE_DELETE  { handler.onBeforeDelete(Trigger.old,              Trigger.oldMap                ); }
        when AFTER_DELETE   { handler.onAfterDelete( Trigger.old,              Trigger.oldMap                ); }
        when AFTER_UNDELETE { handler.onUndelete(    Trigger.new                                             ); }
    }
    UL_Logger.info('finish AccountTrigger ' + Trigger.operationType);
}
