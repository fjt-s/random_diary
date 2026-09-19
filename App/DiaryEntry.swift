import Foundation
import SwiftData
import UIKit

@Model
final class DiaryEntry {
    var id: UUID = UUID()
    var createdAt: Date = Date()
    var text: String = ""
    /// 位置情報の許可がない場合は nil
    var placeName: String?
    var latitude: Double?
    var longitude: Double?
    /// Documents/Photos 内のファイル名。写真がなければ nil
    var photoFileName: String?

    init(text: String, createdAt: Date = .now, placeName: String? = nil,
         latitude: Double? = nil, longitude: Double? = nil, photoFileName: String? = nil) {
        self.text = text
        self.createdAt = createdAt
        self.placeName = placeName
        self.latitude = latitude
        self.longitude = longitude
        self.photoFileName = photoFileName
    }
}

enum PhotoStore {
    private static var directory: URL {
        let dir = URL.documentsDirectory.appending(path: "Photos", directoryHint: .isDirectory)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }

    /// 長辺を縮小してJPEG保存し、ファイル名を返す
    static func save(_ image: UIImage) -> String? {
        let maxSide: CGFloat = 1600
        let scale = min(1, maxSide / max(image.size.width, image.size.height))
        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let resized = UIGraphicsImageRenderer(size: size).image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
        guard let data = resized.jpegData(compressionQuality: 0.8) else { return nil }
        let name = UUID().uuidString + ".jpg"
        do {
            try data.write(to: directory.appending(path: name))
            return name
        } catch {
            return nil
        }
    }

    static func image(named name: String) -> UIImage? {
        UIImage(contentsOfFile: directory.appending(path: name).path)
    }

    static func delete(named name: String) {
        try? FileManager.default.removeItem(at: directory.appending(path: name))
    }
}
