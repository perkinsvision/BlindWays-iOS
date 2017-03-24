//
//  MapViewController.swift
//  BlindWays
//
//  Created by Zev Eisenberg on 9/22/16.
//  Copyright© 2016 Perkins School for the Blind
//
//  All "Perkins Bus Stop App" Software is licensed under Apache Version 2.0.
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit
import MapKit
import Anchorage

final class MapViewController: UIViewController {

    // Private Properties
    fileprivate let viewModel: MapViewModel

    fileprivate let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.userTrackingMode = .none
        mapView.isRotateEnabled = false
        return mapView
    }()

    fileprivate lazy var directionsButton: UIButton = {
        let button = SolidColorButton(titleColor: Colors.Common.white, backgroundColor: Colors.Common.darkGrassGreen)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.addTarget(self, action: #selector(MapViewController.directionsButtonTapped(_:)), for: .touchUpInside)
        button.heightAnchor >= 56
        button.setTitle(UIStrings.stopDetailLocationNavigateSubtitle.string, for: .normal)
        return button
    }()

    fileprivate let userBeak = LocationBeakView()

    fileprivate let geo = GeoLocator()

    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = viewModel.title
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = UIView()
        view.backgroundColor = Colors.Common.marineBlue

        view.addSubview(mapView)
        view.addSubview(directionsButton)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self

        mapView.topAnchor == topLayoutGuide.bottomAnchor
        mapView.horizontalAnchors == horizontalAnchors

        mapView.bottomAnchor == directionsButton.topAnchor
        directionsButton.horizontalAnchors == horizontalAnchors
        directionsButton.bottomAnchor == bottomLayoutGuide.topAnchor

        let annotation = MKPointAnnotation()
        annotation.coordinate = viewModel.stop.location.coordinate
        annotation.title = viewModel.stop.name
        mapView.addAnnotation(annotation)

        geo.startMonitoringHeading { [weak self] (heading: CLHeading) in
            self?.updateHeading(heading)
        }
    }

    deinit {
        geo.stopMonitoringHeading()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Array of rects with a size of (0, 0), because we need rects,
        // not points, to pass into `MKMapRectUnion`.
        let userExtremaRects = viewModel.userLocationExtrema
            .map(MKMapPointForCoordinate)
            .map { MKMapRect(origin: $0, size: MKMapSize(width: 0.0, height: 0.0)) }

        let stopPoint = MKMapPointForCoordinate(viewModel.stop.location.coordinate)

        let stopRect = MKMapRect(origin: stopPoint, size: MKMapSize(width: 0.0, height: 0.0))

        let unionRect = userExtremaRects.reduce(stopRect, { MKMapRectUnion($0, $1) })

        let inset = CGFloat(30.0)
        mapView.setVisibleMapRect(unionRect, edgePadding: UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset), animated: false)
    }

}

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        switch annotation {
        case is MKUserLocation:
            return nil
        default:
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.annotationReuseIdentifier) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: Constants.annotationReuseIdentifier)
            view.image = Asset.icnMappin.image
            view.canShowCallout = true
            return view
        }
    }

    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        for annotationView in views {
            if annotationView.annotation is MKUserLocation {
                annotationView.superview?.bringSubview(toFront: annotationView)
                break
            }
        }
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        for annotation in mapView.annotations {
            if annotation is MKUserLocation {
                if let annotationView = mapView.view(for: annotation) {
                    annotationView.superview?.bringSubview(toFront: annotationView)
                }
            }
        }
    }

}

private extension MapViewController {

    struct Constants {

        static let annotationReuseIdentifier = AppDelegate.reverseDomain("reuse.identifier.map.annotation")

    }

    @objc func directionsButtonTapped(_ sender: UIButton) {
        NavigationService.requestNavigation(
            to: viewModel.stop.location,
            placeName: viewModel.stop.name,
            inViewController: self)
    }

    func updateHeading(_ heading: CLHeading?) {
        guard let heading = heading, heading.headingAccuracy > 0.0 else {
            return
        }

        if let userAnnotation = mapView.view(for: mapView.userLocation) {
            if userAnnotation.subviews.isEmpty {
                userAnnotation.addSubview(userBeak)
                userBeak.transform = CGAffineTransform.identity
                userBeak.frame = CGRect(origin: .zero, size: CGSize(width: 44.0, height: 44.0))
                userBeak.setNeedsDisplay()
            }

            userBeak.center = CGPoint(x: userAnnotation.bounds.width / 2, y: userAnnotation.bounds.height / 2)
        }

        let direction = heading.magneticHeading

        // Animate heading changes to smooth out juddery motion, which is a result
        // of heading updates coming in less frequently than screen redraws.
        UIView.animate(
            withDuration: 0.1,
            delay: 0.0,
            options: [.beginFromCurrentState],
            animations: {
                let mapAngle = self.mapView.camera.heading
                self.userBeak.transform = CGAffineTransform(rotationAngle: CGFloat(degreesToRadians(direction) - mapAngle))
            }, completion: nil)
    }

}
