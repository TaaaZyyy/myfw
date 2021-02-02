public inherited sharing class th_AccountTriggerHandler extends th_BaseTriggerHandler {
    private List<Account> oldList;
    private List<Account> newList;
    private Map<Id, Account> oldMap;
    private Map<Id, Account> newMap;


    public th_AccountTriggerHandler() {
        this.oldList = (List<Account>) Trigger.old;
        this.newList = (List<Account>) Trigger.new;
        this.oldMap  = (Map<Id, Account>) Trigger.oldMap;
        this.newMap  = (Map<Id, Account>) Trigger.newMap;
    }


    public override void beforeInsert() {
        // do something
    }


    public override void afterInsert() {
        // do something
    }


    public override void beforeUpdate() {
        // do something
    }
}
