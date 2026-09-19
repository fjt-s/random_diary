import SwiftUI
import SwiftData

@main
struct RandomDiaryApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: DiaryEntry.self)
    }
}

/// 起動時は常に「書く」タブ。キーボードも自動で開く。
struct RootView: View {
    @State private var location = LocationProvider()

    var body: some View {
        TabView {
            ComposeView(location: location)
                .tabItem { Label("書く", systemImage: "square.and.pencil") }
            HistoryView()
                .tabItem { Label("履歴", systemImage: "book") }
        }
    }
}
