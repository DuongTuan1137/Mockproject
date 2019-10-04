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
    let status: Int?
    let id: Int
    init(title: String, locationName: String, coordinate : CLLocationCoordinate2D, status: Int, id: Int){
        self.coordinate = coordinate
        self.title = title
        self.locationName = locationName
        self.status = status
        self.id = id
        super.init()
    }
    var subtitle: String? {
        return locationName
    }
    
    class func from(json: Event) -> Venue{
        let id = json.id
        let title = json.venue.name
        let locationName = json.venue.contact_address
        let long = json.venue.geo_long
        let lat = json.venue.geo_lat
        let status = json.my_status ?? 0
        let coordinate = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(long)!)
        return Venue(title: title, locationName: locationName, coordinate: coordinate, status: status, id: id)
    }
}


