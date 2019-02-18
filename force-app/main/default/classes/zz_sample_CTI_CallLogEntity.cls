public with sharing class CTI_CallLogEntity {
    public String session_id;    // 呼毎の固有ID
    public String phone;         // 相手先電話番号
    public String call_when;     // 通話開始日時「YYYY-MM-DDThh:mm:ss+hh:mm」日本時間
    public String call_duration; // 通話時間(秒)
    public String record_url;    // 録音URL
    public String call_type;     // インバウンド/アウトバウンド
    public String agent_id;      // エージェントID

    // JSON 例
    // {"session_id":"test001","phone":"08012341234","call_when":"2019-01-01T22:08:40+09:00","call_duration":100,"record_url":"https://example.com","call_type":"inbound","agent_id":"F09180001"}
}