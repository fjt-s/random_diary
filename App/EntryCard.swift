import SwiftUI

extension Date {
    var diaryFormatted: String {
        formatted(.dateTime.year().month().day().weekday(.wide).hour().minute()
            .locale(Locale(identifier: "ja_JP")))
    }
}

/// 日付 / 場所 / メモ / 写真 を見やすく並べたカード
struct EntryCard: View {
    let entry: DiaryEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(entry.createdAt.diaryFormatted, systemImage: "calendar")
                .font(.subheadline.weight(.semibold))

            if let place = entry.placeName, !place.isEmpty {
                Label(place, systemImage: "mappin.and.ellipse")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Text(entry.text)
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)

            if let name = entry.photoFileName, let image = PhotoStore.image(named: name) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(maxHeight: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(.vertical, 6)
    }
}
