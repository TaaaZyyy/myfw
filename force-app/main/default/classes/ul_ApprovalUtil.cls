public with sharing class ul_ApprovalUtil {
    private ul_ApprovalUtil() {}

    /**
    * 承認者ID取得メソッド
    */
    public static List<Id> getApproverIdList(Id targetObjectId) {
        // 最新の最終承認の承認プロセスインスタンスを取得
        List<ProcessInstance> approvedProcess = queryProcessInstances(targetObjectId);
        if (approvedProcess.isEmpty()) { return new List<Id>(); }

        // 承認プロセスの各ステップから承認者IDを取得する
        List<Id> approverIdList = new List<Id>();
        for (ProcessInstanceHistory history : approvedProcess[0].StepsAndWorkitems) {
            Id actorId = history.ActorId;
            if (actorId.getSobjectType() == User.getSObjectType()) {
                approverIdList.add(actorId);
            } else {
                System.debug( LoggingLevel.ERROR, 'ユーザではない承認者: ' + actorId );
            }
        }
        return approverIdList;
    }



    /** 承認プロセスインスタンスクエリメソッド */
    private static List<ProcessInstance> queryProcessInstances(Id targetObjectId) {
            return [
                SELECT
                    Id,
                    (
                        SELECT
                            ActorId    // 承認者
                        FROM
                            StepsAndWorkitems
                        WHERE
                            StepStatus = 'Approved'
                        ORDER BY CreatedDate Asc
                    )
                FROM
                    ProcessInstance
                WHERE
                    TargetObjectId =: targetObjectId
                    AND Status = 'Approved'
                ORDER BY CreatedDate Desc
                LIMIT 1
            ];
    }
}