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
import SnapKit
import Then
import UIKit

final class TravelMapView: UIView {

    // MARK: - UI Components

    private let mapView = MKMapView().then {
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.isScrollEnabled = true
        $0.isZoomEnabled = true
        $0.isPitchEnabled = false
        $0.isRotateEnabled = false
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

        // 전체 마커가 한눈에 들어오도록 자동 맞춤
        let annotations = mapView.annotations.filter { !($0 is MKUserLocation) }
        let edgePadding = UIEdgeInsets(top: 48, left: 48, bottom: 48, right: 48)
        mapView.showAnnotations(annotations, animated: false)
        mapView.setVisibleMapRect(
            mapView.visibleMapRect,
            edgePadding: edgePadding,
            animated: false
        )
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
            renderer.strokeColor = .black
            renderer.lineWidth = 1
            renderer.lineDashPattern = [4, 4]
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }

    private func createCircleView(sequence: Int) -> UIView {
        let size: CGFloat = 30
        let view = UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        view.backgroundColor = UIColor(hexCode: "#28A745")
        view.layer.cornerRadius = size / 2

        let label = UILabel(frame: view.bounds)
        label.text = "\(sequence)"
        label.textColor = UIColor(hexCode: "#FFFFFF")
        label.font = UIFont.NDGL.bodyMSB.font
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
