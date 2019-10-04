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
    var id: Int
    var photo: String?
    var name: String?
    var description_html: String?
    var schedule_start_date: String?
    var schedule_end_date: String?
    var going_count: Int?
    var my_status: Int?
    var venue: VenueStruct
}

struct ResponseNear: Codable {
    var events: [Event]
}

struct NearStruct: Codable {
    var status: Int
    var response: ResponseNear
}
