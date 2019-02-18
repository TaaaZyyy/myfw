@RestResource(urlMapping='/calllog')
global with sharing class CTI_CallLogService {
    public static final Integer TIME_DIFFERENCE = -9;

    @HttpPost
    webservice static String doPost() {
        // win
        // curl.exe https://cti-seed-rkm.cs74.force.com/ctiapi/services/apexrest/calllog -XPOST -H “Content-Type:application/json” -d '{\"session_id\":\"test001\",\"phone\":\"08012341234\",\"call_when\":\"2019-01-01T22:08:40\",\"call_duration\":100,\"record_url\":\"https://example.com\",\"call_type\":\"inbound\",\"agent_id\":\"F09180001\"}'

        RestRequest req = RestContext.request;
        CTI_CallLogEntity params = (CTI_CallLogEntity) JSON.deserialize(req.requestBody.toString(), CTI_CallLogEntity.class);

        CallLog__c call              = new CallLog__c();
        call.AgentId__c              = params.agent_id;      // エージェントID
        call.Type__c                 = params.call_type;     // コールタイプ
        call.SessionId__c            = params.session_id;    // セッションID
        call.Phone__c                = params.phone;         // 相手先電話番号
        call.RecordUrl__c            = params.record_url;    // 録音URL
        call.CallDurationTime_sec__c = Decimal.valueOf(params.call_duration); // 通話時間(秒)
        call.CallWhen__c             = perseToDatetime(params.call_when); // 通話開始日時(DateTime)


        List<User> operators = [ SELECT Id FROM USER WHERE IsActive = true AND AgentId__c = :params.agent_id ];
        call.Operator__c = operators.isEmpty() ? null : operators[0].Id; // オペレーター

        insert call;
        return call.Id;
    }



    /**
    * Datetime変換メソッド
    * @parameter datetimeStr: YYYY-MM-DDThh:mm:ss+hh:mm  (ISO 8601 拡張形式)
    * @return 変換後のDatetime型。戻り値のタイムゾーンはUTC。エラー時はnullを返却。
    */
    public static Datetime perseToDatetime(String datetimeStr) {
        try {
            System.debug(LoggingLevel.DEBUG, datetimeStr);

            // 日付
            Pattern p_1 = Pattern.compile('(\\d+)-(\\d+)-(\\d+)T');
            Matcher m_1 = p_1.matcher(datetimeStr);
            if (!m_1.find()) { return null; }
            Integer yearInt  = Integer.valueOf(m_1.group(1));
            Integer monthInt = Integer.valueOf(m_1.group(2));
            Integer dateInt  = Integer.valueOf(m_1.group(3));
            System.debug(LoggingLevel.DEBUG, m_1.group());

            // 時間
            Pattern p_2 = Pattern.compile('T(\\d+):(\\d+):(\\d+)');
            Matcher m_2 = p_2.matcher(datetimeStr);
            if (!m_2.find()) { return null; }
            Integer hourInt   = Integer.valueOf(m_2.group(1));
            Integer minuteInt = Integer.valueOf(m_2.group(2));
            Integer secondInt = Integer.valueOf(m_2.group(3));
            System.debug(LoggingLevel.DEBUG, m_2.group());

            // GMT
            Pattern p_plus = Pattern.compile('\\+(\\d+):(\\d+)');
            Matcher m_plus = p_plus.matcher(datetimeStr);
            Boolean isPlus = m_plus.find();
            if (isPlus) { System.debug(LoggingLevel.DEBUG, m_plus.group()); }

            Pattern p_minus = Pattern.compile('-(\\d+):(\\d+)');
            Matcher m_minus = p_minus.matcher(datetimeStr);
            Boolean isMinus = m_minus.find();
            if (isMinus) { System.debug(LoggingLevel.DEBUG, m_minus.group()); }

            Boolean isUtc = datetimeStr.contains('Z');

            Datetime dt;
            if (isPlus) {
                dt = Datetime.newInstanceGmt(yearInt, monthInt, dateInt, hourInt, minuteInt, secondInt);
                Integer addedHour   = Integer.valueOf(m_plus.group(1));
                Integer addedMinute = Integer.valueOf(m_plus.group(2));
                dt = dt.addHours(-addedHour);
                dt = dt.addMinutes(-addedMinute);

            } else if (isMinus) {
                dt = Datetime.newInstanceGmt(yearInt, monthInt, dateInt, hourInt, minuteInt, secondInt);
                Integer addedHour   = Integer.valueOf(m_minus.group(1));
                Integer addedMinute = Integer.valueOf(m_minus.group(2));
                dt = dt.addHours(addedHour);
                dt = dt.addMinutes(addedMinute);

            } else if (isUtc) {
                dt = Datetime.newInstanceGmt(yearInt, monthInt, dateInt, hourInt, minuteInt, secondInt);
            } else {
                dt = Datetime.newInstanceGmt(yearInt, monthInt, dateInt, hourINt, minuteInt, secondInt);
                dt = dt.addHours(TIME_DIFFERENCE);
            }
            return dt;
        } catch (Exception e) {
            System.debug( LoggingLevel.ERROR, 'error: ' + e.getMessage() );
            System.debug( LoggingLevel.ERROR, 'stacktrace: ' +e.getStackTraceString() );
            return null;
        }
    }
}