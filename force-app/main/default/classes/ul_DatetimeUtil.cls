public with sharing class ul_DatetimeUtil {
    private ul_DatetimeUtil() {}

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
            }
            return dt;
        } catch (Exception e) {
            System.debug( LoggingLevel.ERROR, 'error: ' + e.getMessage() );
            System.debug( LoggingLevel.ERROR, 'stacktrace: ' +e.getStackTraceString() );
            return null;
        }
    }
}