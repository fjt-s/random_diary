import SwiftUI
import SwiftData
import PhotosUI

struct ComposeView: View {
    let location: LocationProvider

    @Environment(\.modelContext) private var context
    @Environment(\.scenePhase) private var scenePhase
    @FocusState private var focused: Bool

    @State private var text = ""
    @State private var pickerItem: PhotosPickerItem?
    @State private var photo: UIImage?
    @State private var savedBanner = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                // 日付・場所（保存されるメタ情報を先に見せる）
                TimelineView(.periodic(from: .now, by: 30)) { ctx in
                    Label(ctx.date.diaryFormatted, systemImage: "calendar")
                        .font(.subheadline.weight(.semibold))
                }
                if let place = location.placeName, !place.isEmpty {
                    Label(place, systemImage: "mappin.and.ellipse")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                TextEditor(text: $text)
                    .focused($focused)
                    .scrollContentBackground(.hidden)
                    .padding(8)
                    .background(.quaternary, in: RoundedRectangle(cornerRadius: 12))
                    .overlay(alignment: .topLeading) {
                        if text.isEmpty {
                            Text("いま何してる？")
                                .foregroundStyle(.tertiary)
                                .padding(.horizontal, 13).padding(.vertical, 16)
                                .allowsHitTesting(false)
                        }
                    }

                if let photo {
                    ZStack(alignment: .topTrailing) {
                        Image(uiImage: photo)
                            .resizable().scaledToFill()
                            .frame(height: 120)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        Button {
                            self.photo = nil
                            pickerItem = nil
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.white, .black.opacity(0.6))
                                .font(.title2)
                        }
                        .padding(6)
                    }
                }

                HStack {
                    PhotosPicker(selection: $pickerItem, matching: .images) {
                        Label("写真", systemImage: "photo")
                    }
                    Spacer()
                    Button("保存", action: save)
                        .buttonStyle(.borderedProminent)
                        .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && photo == nil)
                }
            }
            .padding()
            .navigationTitle("日記を書く")
            .navigationBarTitleDisplayMode(.inline)
            .overlay(alignment: .top) {
                if savedBanner {
                    Text("保存しました")
                        .padding(.horizontal, 16).padding(.vertical, 8)
                        .background(.regularMaterial, in: Capsule())
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
        }
        .onAppear(perform: prepare)
        .onChange(of: scenePhase) { _, phase in
            if phase == .active { prepare() }
        }
        .onChange(of: pickerItem) { _, item in
            Task {
                guard let data = try? await item?.loadTransferable(type: Data.self) else { return }
                photo = UIImage(data: data)
            }
        }
    }

    private func prepare() {
        focused = true
        location.refresh()
    }

    private func save() {
        let body = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let fileName = photo.flatMap { PhotoStore.save($0) }
        let entry = DiaryEntry(
            text: body,
            placeName: location.placeName,
            latitude: location.coordinate?.latitude,
            longitude: location.coordinate?.longitude,
            photoFileName: fileName
        )
        context.insert(entry)
        text = ""
        photo = nil
        pickerItem = nil
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        withAnimation { savedBanner = true }
        Task {
            try? await Task.sleep(for: .seconds(1.5))
            withAnimation { savedBanner = false }
        }
    }
}
