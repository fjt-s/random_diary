import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \DiaryEntry.createdAt, order: .reverse) private var entries: [DiaryEntry]

    var body: some View {
        NavigationStack {
            List {
                ForEach(entries) { entry in
                    EntryCard(entry: entry)
                }
                .onDelete(perform: delete)
            }
            .overlay {
                if entries.isEmpty {
                    ContentUnavailableView("まだ日記がありません", systemImage: "book",
                                           description: Text("「書く」タブから最初の一言を残しましょう"))
                }
            }
            .navigationTitle("履歴")
        }
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets {
            let entry = entries[index]
            if let name = entry.photoFileName { PhotoStore.delete(named: name) }
            context.delete(entry)
        }
    }
}
