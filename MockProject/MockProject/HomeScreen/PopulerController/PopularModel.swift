//
//  PopularModel.swift
//  MockProject
//
//  Created by AnhDCT on 9/11/19.
//  Copyright © 2019 AnhDCT. All rights reserved.
//

import Foundation
import UIKit


struct EventsStruct: Codable {
    var id: Int?
    var photo: String?
    var name: String?
    var description_html: String?
    var schedule_start_date: String?
    var schedule_end_date: String?
    var going_count: Int?
}

struct ResStruct: Codable {
    var events : [EventsStruct]
}

struct PopularStruct : Codable {
    var status : Int
    var response : ResStruct
}

