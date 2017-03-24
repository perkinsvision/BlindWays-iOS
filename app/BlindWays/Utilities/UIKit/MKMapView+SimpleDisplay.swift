//
//  MKMapView+SimpleDisplay.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 5/10/16.
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

import Foundation
import MapKit
import CoreLocation

private class RZAnnotation: NSObject, MKAnnotation {

    @objc var coordinate: CLLocationCoordinate2D

    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }

}

extension MKMapView: MKMapViewDelegate {

    func rz_showLocation(_ location: CLLocation, animated: Bool = true, spanDelta: Double = 0.001) {
        guard CLLocationCoordinate2DIsValid(location.coordinate) else {
            return
        }

        self.isUserInteractionEnabled = false
        self.delegate = self

        let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: spanDelta, longitudeDelta: spanDelta))
        self.setRegion(region, animated: animated)
        self.addAnnotation(RZAnnotation(coordinate: location.coordinate))
    }

    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return MKPinAnnotationView(annotation: annotation, reuseIdentifier: "reuse")
    }

}
