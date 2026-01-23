//
//  TravelMapView.swift
//  FollowFeature
//
//  Created by kimnahun on 2026-01-23.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Core
import Domain
import DSKit
import MapKit
import UIKit
import SnapKit
import Then

final class TravelMapView: UIView {

    // MARK: - UI Components

    private let mapView = MKMapView().then {
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.isScrollEnabled = false
        $0.isZoomEnabled = false
    }

    // MARK: - Properties

    private var places: [TravelPlace] = []

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupUI() {
        addSubview(mapView)
        mapView.delegate = self
    }

    private func setupConstraints() {
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    // MARK: - Configuration

    func configure(with places: [TravelPlace]) {
        self.places = places

        // 기존 어노테이션 제거
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)

        guard !places.isEmpty else { return }

        // 어노테이션 추가
        var coordinates: [CLLocationCoordinate2D] = []

        for place in places {
            let coordinate = CLLocationCoordinate2D(
                latitude: place.place.latitude,
                longitude: place.place.longitude
            )
            coordinates.append(coordinate)

            let annotation = PlaceAnnotation(
                coordinate: coordinate,
                title: place.place.name,
                sequence: place.sequence
            )
            mapView.addAnnotation(annotation)
        }

        // 경로 선 추가
        if coordinates.count > 1 {
            let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
            mapView.addOverlay(polyline)
        }

        // 지도 영역 설정
        if let firstCoordinate = coordinates.first {
            let region = MKCoordinateRegion(
                center: firstCoordinate,
                latitudinalMeters: 10000,
                longitudinalMeters: 10000
            )
            mapView.setRegion(region, animated: false)
        }
    }
}

// MARK: - MKMapViewDelegate

extension TravelMapView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let placeAnnotation = annotation as? PlaceAnnotation else { return nil }

        let identifier = "PlaceAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }

        // 커스텀 원형 뷰 생성
        let circleView = createCircleView(sequence: placeAnnotation.sequence)
        annotationView?.image = circleView.asImage()

        return annotationView
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = UIColor.NDGL.Bg.Interactive.primary
            renderer.lineWidth = 2
            renderer.lineDashPattern = [4, 4]
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }

    private func createCircleView(sequence: Int) -> UIView {
        let size: CGFloat = 30
        let view = UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        view.backgroundColor = UIColor.NDGL.Bg.Interactive.primary
        view.layer.cornerRadius = size / 2

        let label = UILabel(frame: view.bounds)
        label.text = "\(sequence)"
        label.textColor = UIColor.NDGL.Text.Interactive.inverse
        label.font = DSKitFontFamily.Pretendard.bold.font(size: 14)
        label.textAlignment = .center
        view.addSubview(label)

        return view
    }
}

// MARK: - PlaceAnnotation

final class PlaceAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let sequence: Int

    init(coordinate: CLLocationCoordinate2D, title: String?, sequence: Int) {
        self.coordinate = coordinate
        self.title = title
        self.sequence = sequence
        super.init()
    }
}

// MARK: - UIView Extension

private extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { context in
            layer.render(in: context.cgContext)
        }
    }
}
