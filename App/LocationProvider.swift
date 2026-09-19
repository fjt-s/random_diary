import CoreLocation
import Observation

/// 現在地を1回取得して地名に変換する。許可がなければ何もしない（placeName は nil のまま）。
@Observable
@MainActor
final class LocationProvider: NSObject, CLLocationManagerDelegate {
    private(set) var placeName: String?
    private(set) var coordinate: CLLocationCoordinate2D?

    @ObservationIgnored private let manager = CLLocationManager()
    @ObservationIgnored private let geocoder = CLGeocoder()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    private var isAuthorized: Bool {
        manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways
    }

    /// 入力画面が開くたびに呼ぶ
    func refresh() {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        default:
            placeName = nil
            coordinate = nil
        }
    }

    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in self.refresh() }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        Task { @MainActor in
            self.coordinate = location.coordinate
            let placemarks = try? await self.geocoder.reverseGeocodeLocation(location)
            guard let pm = placemarks?.first else { return }
            let parts = [pm.locality, pm.subLocality ?? pm.name]
            self.placeName = parts.compactMap { $0 }.joined(separator: " ")
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // 取得失敗時は前回の値を保持（無ければ nil のまま）
    }
}
