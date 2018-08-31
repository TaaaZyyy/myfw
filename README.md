# My Salesforce Library
勉強・試行錯誤で得られたナレッジを集積する場

## Layer Architecture
レイヤアーキテクチャというのはアプリケーションを責務に応じたいくつかの層としてとらえる設計手法。
このとき上の層が下の層を一方的に利用するようにすることで、オブジェクト間の結合を疎に保ち、ドメインロジックの凝集度を高めることがでる。
* 各オブジェクトはいずれかの層に属し、複数の層にまたがることはない
* 層の関係は一方通行であり、相互参照する関係は層をまたがない
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
- [中規模Web開発のためのMVC分割とレイヤアーキテクチャ(Qiita)](https://qiita.com/yuku_t/items/961194a5443b618a4cac)
- [アプリケーションのレイヤ化](http://terasolunaorg.github.io/guideline/5.4.1.RELEASE/ja/Overview/ApplicationLayering.html)