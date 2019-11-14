//
//  Puntos.swift
//  Proyecto2MPOO
//
//  Created by 2020-1 on 11/4/19.
//  Copyright © 2019 Omar Rios. All rights reserved.
//

import UIKit
import MapKit


struct Punto: Codable {
    var title: String
    var Latitude: Double
    var Longitude: Double
}

class Direccion: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
    
}
