public with sharing class service_CaseService {
    public static void closeCases(Set<Id> caseIds, String reason) {
        if (caseIds == null || caseIds.isEmpty() ) {
            throw new CaseServiceException('ケースが見つかりません');
        }

        List<Case> cases = [SELECT Id FROM Case WHERE Id IN :caseIds];
        for (Case obj : cases) {
            obj.status = 'closed';
            obj.reason = reason;
        }
        update cases;
    }


    public class CaseServiceException extends Exception {}
}