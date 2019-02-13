@isTest
private class ul_DatetimeUtilTest {
    @isTest
    static void testPerseToDatetime() {
        // JST
        String param1 = '2019-01-01T22:08:40+09:00';
        Datetime result1 = CTI_CallLogService.perseToDatetime(param1);
        System.assertEquals(Datetime.newInstanceGmt(2019,01,01,13,08,40), result1, 'JST');

        // マイナスのタイムゾーン
        String param2 = '2019-01-01T22:08:40-03:00';
        Datetime result2 = CTI_CallLogService.perseToDatetime(param2);
        System.assertEquals(Datetime.newInstanceGmt(2019,01,02,01,08,40), result2, 'マイナスのタイムゾーン');

        // UTC
        String param3 = '2019-01-01T22:08:40Z';
        Datetime result3 = CTI_CallLogService.perseToDatetime(param3);
        System.assertEquals(Datetime.newInstanceGmt(2019,01,01,22,08,40), result3, 'UTC');

        // タイムゾーン指定なし → 不正値
        String param4 = '2019-01-01T22:08:40';
        Datetime result4 = CTI_CallLogService.perseToDatetime(param4);
        System.assertEquals(null, result4, 'JST2');

        // 不正なパラメーター
        String param5 = '2019-01-01 22:08:40';
        Datetime result5 = CTI_CallLogService.perseToDatetime(param5);
        System.assertEquals(null, result5, '不正値');
    }
}