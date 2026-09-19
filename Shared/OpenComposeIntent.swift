import AppIntents

/// ロック画面のコントロールから日記アプリを開くためのIntent。
/// アプリは常に入力画面から起動するので、開くだけでよい。
struct OpenComposeIntent: AppIntent {
    static let title: LocalizedStringResource = "日記を書く"
    static let openAppWhenRun = true

    func perform() async throws -> some IntentResult {
        .result()
    }
}
