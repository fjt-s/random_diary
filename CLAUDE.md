# random_diary

ロック画面から最短で日記を書き始められる iOS アプリ（SwiftUI + SwiftData, iOS 18+）。

## 設計判断
- iOS ではロック画面にテキスト入力欄を置けない。代替として、ロック画面のコントロール（iOS 18 ControlWidget）と
  ロック画面ウィジェットから起動し、アプリは常に入力画面（キーボード自動表示）から始まる。
- 記録項目: 日付 / 場所（位置情報を許可した場合のみ）/ メモ / 写真（任意）。
- Xcode プロジェクトは XcodeGen（`project.yml`）から生成する。`.xcodeproj` と Info.plist は git 管理外。

## 構成
- `App/`: アプリ本体（ComposeView=入力, HistoryView=履歴, EntryCard=表示レイアウト, LocationProvider, DiaryEntry/PhotoStore）
- `DiaryWidgets/`: ロック画面のコントロールとウィジェット
- `Shared/OpenComposeIntent.swift`: アプリ・ウィジェット共通の AppIntent

## 状況
- 開発環境は Linux（Codespaces）で Xcode が無いため、**一度もビルド・実行していない**。コンパイルエラーの可能性あり。
- bundle ID は仮の `com.example`、`DEVELOPMENT_TEAM` は未設定。

## 次のTODO
1. GitHub Actions（macos ランナー）で `xcodegen generate` → `xcodebuild` のビルド確認と、
   simctl によるスクリーンショット取得を自動化する（`.github/workflows/build.yml`）。
2. Mac + 実機でロック画面からの起動速度、位置情報の地名取得タイミング（保存時に空にならないか）を確認する。
