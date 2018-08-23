@RestResource(urlMapping='/case/*/close')
global with sharing class application_CaseCloseResource {
    @HttpPost
    global static void closeCase(String reason) {
        // Parse context
        RestRequest req = RestContext.request;
        List<String> uriParts = req.requestURI.split('/');
        Id caseId = uriParts.get(2);

        // Call the service
        CaseService.closeCases( new Set<Id>{caseId}, reason);
    }
}