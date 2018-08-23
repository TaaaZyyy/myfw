# My Salesforce Library
勉強・試行錯誤で得られたナレッジを集積する場

## Layer Architecture
### 1. Presentation Layer
### 2. Service Layer
サービスレイヤは、ビジネスタスク、計算、プロセスを実装するコードを明確かつ厳密にカプセル化することに役立ちます。サービスレイヤが、異なるコンテキスト (モバイルアプリケーション、UI フォーム、リッチ Web UI、各種 API など) で確実に使用できるようにすることが重要です。また、今後の時代や要求の変化に対応するために、純粋かつ抽象的であり続ける必要があります。

サービスの操作を示す静的メソッドで適切に名前を付けたクラスのためのレイヤ。
メソッドのロジックは、データベースを更新するか、カスタムの Apex の例外を使用してメソッドの戻り値のデータ型の情報を返し、エラーを示します。
publicをglobalにかえてAPIを公開することもある。
* APIの公開
    * RESTプロトコルの使用（モバイル、IoTなど）:Apex REST Annotation
    * フロー・プロセスビルダーに開放: InvocableMethod Annotation
### 3. Domain Layer
### 4. Selector Layer
## Link
- [凝集度（Wikipedia）](https://ja.wikipedia.org/wiki/%E5%87%9D%E9%9B%86%E5%BA%A6)
- [サービスレイヤ（Trailhead）](https://trailhead.salesforce.com/ja/trails/force_com_dev_advanced/modules/apex_patterns_sl/units/apex_patterns_sl_apply_sl_principles)