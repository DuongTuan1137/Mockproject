//
//  Venue.swift
//  MockProject
//
//  Created by AnhDCT on 10/1/19.
//  Copyright © 2019 AnhDCT. All rights reserved.
//

import UIKit
import MapKit

class Venue: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    let title: String?
    let locationName: String?
    init(title: String, locationName: String, coordinate : CLLocationCoordinate2D){
        self.coordinate = coordinate
        self.title = title
        self.locationName = locationName
        super.init()
    }
    var subtitle: String? {
        return locationName
    }
    class func from(json: Event) -> Venue{
        let title = json.venue.name
        let locationName = json.venue.contact_address
        let long = json.venue.geo_long
        let lat = json.venue.geo_lat
        let coordinate = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(long)!)
        return Venue(title: title, locationName: locationName, coordinate: coordinate)
    }
}


