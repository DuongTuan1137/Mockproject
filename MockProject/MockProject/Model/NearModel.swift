//
//  NearModel.swift
//  MockProject
//
//  Created by AnhDCT on 10/1/19.
//  Copyright © 2019 AnhDCT. All rights reserved.
//

import Foundation
struct VenueStruct: Codable {
    var name : String
    var contact_address: String
    var geo_long: String
    var geo_lat: String
}

struct Event: Codable {
    var venue: VenueStruct
}

struct ResponseNear: Codable {
    var events: [Event]
}

struct NearStruct: Codable {
    var status: Int
    var response: ResponseNear
}
