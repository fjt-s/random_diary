# random_diary
ロック画面から最短で日記を書き始められる iOS アプリ。

## 仕組み
iOS ではロック画面にテキスト入力欄を直接置けないため、次の方式にしています。

- **ロック画面のコントロール（iOS 18+）**: ロック画面下部のボタンに「日記を書く」を割り当て。
  タップ → Face ID → 入力画面がキーボード表示済みで起動。
- **ロック画面ウィジェット**: 時計の上下の枠にも置けます（同じ動作）。
- アプリは常に「書く」画面から起動し、自動でキーボードを開きます。

各記録には次を保存し、カード形式で表示します。
日付 / 場所（位置情報を許可した場合のみ）/ メモ / 写真（任意）

## ビルド
```sh
brew install xcodegen
xcodegen generate        # project.yml から RandomDiary.xcodeproj を生成
open RandomDiary.xcodeproj
```
`project.yml` の `DEVELOPMENT_TEAM` と `bundleIdPrefix` を自分のものに変更してください。

ロック画面への配置: ロック画面長押し →「カスタマイズ」→ 下部のボタンを外して「＋」から「日記を書く」を選択。
