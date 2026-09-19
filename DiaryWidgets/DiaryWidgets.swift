import SwiftUI
import WidgetKit
import AppIntents

@main
struct DiaryWidgetBundle: WidgetBundle {
    var body: some Widget {
        DiaryControl()
        DiaryLockScreenWidget()
    }
}

// MARK: - ロック画面下部のコントロール (iOS 18+)

struct DiaryControl: ControlWidget {
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: "com.example.RandomDiary.compose") {
            ControlWidgetButton(action: OpenComposeIntent()) {
                Label("日記を書く", systemImage: "square.and.pencil")
            }
        }
        .displayName("日記を書く")
        .description("タップして日記の入力画面をすぐ開きます。")
    }
}

// MARK: - ロック画面ウィジェット (時計の上下の枠)

struct DiaryEntryTimeline: TimelineProvider {
    struct Entry: TimelineEntry { let date: Date }

    func placeholder(in context: Context) -> Entry { Entry(date: .now) }
    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        completion(Entry(date: .now))
    }
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        completion(Timeline(entries: [Entry(date: .now)], policy: .never))
    }
}

struct DiaryLockScreenWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "com.example.RandomDiary.lockscreen", provider: DiaryEntryTimeline()) { _ in
            DiaryLockScreenView()
                .widgetURL(URL(string: "randomdiary://compose"))
                .containerBackground(.clear, for: .widget)
        }
        .configurationDisplayName("日記を書く")
        .description("タップして日記の入力画面を開きます。")
        .supportedFamilies([.accessoryCircular, .accessoryRectangular])
    }
}

struct DiaryLockScreenView: View {
    @Environment(\.widgetFamily) private var family

    var body: some View {
        switch family {
        case .accessoryRectangular:
            HStack {
                Image(systemName: "square.and.pencil")
                Text("日記を書く").font(.headline)
            }
        default:
            Image(systemName: "square.and.pencil").font(.title2)
        }
    }
}
