//
//  CityAnnotation.swift
//  Climcity
//
//  Created by Mervin Flores on 5/19/21.
//

import Foundation
import MapKit

class CityAnnotation: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    let subtitle: String?

    init(
        title: String?,
        subtitle: String?,
        coordinate: CLLocationCoordinate2D
    ) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate

        super.init()
    }
}
