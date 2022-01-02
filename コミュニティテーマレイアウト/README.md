## Trailhead
[ExperienceBuilderサイト用のカスタムテーマレイアウトコンポーネントを構築する](https://trailhead.salesforce.com/ja/content/learn/projects/communities_theme_layout)

## テーマレイアウトコンポーネント
[condensedThemeLayout.cmp](aura/condensedThemeLayout/condensedThemeLayout.cmp)

* エクスペリエンスビルダーの[設定] | [設定]に表示するには テーマ| エリアを構成します。
* テーマレイアウトコンポーネントは、`forceCommunity：themeLayout`インターフェイスを実装する必要があります。
* ページごとに変化するコンテンツをテーマレイアウトコンポーネント内に表示する場所に`{！v.body}`を追加します。
* `Aura.Component[]`として宣言され、マークアップに含まれる属性は、テーマレイアウトコンポーネントでオープンリージョンとしてレンダリングされます。これは、テーマレイアウトの基本構造を形成します。ユーザーは、ExperienceBuilderでこれらのリージョンにドラッグアンドドロップコンポーネントを追加できます。
* このコードは、SLDSグリッドシステムを使用して、レイアウトに構造を追加します。

![カスタムレイアウト選択画面](.pic/custom-theme.png)

変更前
![before](.pic/layout-before.png)

変更後
![after](.pic/layout-after.png)
