//
//  EventsModel.swift
//  MockProject
//
//  Created by AnhDCT on 9/17/19.
//  Copyright © 2019 AnhDCT. All rights reserved.
//

import Foundation
struct CategoryStr: Codable {
    var name: String
}
struct VenueStr: Codable {
    var name: String
    var contact_address: String
    var geo_long: String
    var geo_lat: String
}
struct EventsStr: Codable {
    var id: Int?
    var status: Int?
    var photo: String?
    var name: String?
    var artist: String?
    var description_html: String?
    var schedule_start_date: String?
    var schedule_end_date: String?
    var my_status: Int?
    var going_count: Int?
    var venue: VenueStr
    var category: CategoryStr
    
}
struct EventsModel: Codable {
    var status: Int
    var response: ResEvents
}
struct ResEvents: Codable {
    var events: EventsStr
}


