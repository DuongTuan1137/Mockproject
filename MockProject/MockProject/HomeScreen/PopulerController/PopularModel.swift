//
//  PopularModel.swift
//  MockProject
//
//  Created by AnhDCT on 9/11/19.
//  Copyright © 2019 AnhDCT. All rights reserved.
//

import Foundation
import UIKit
//struct VenuaStruct: Codable {
//    var id: Int?
//    var name: String?
//    var type: Int?
//    var description: String?
//    var schedule_openinghour: String?
//    var schedule_closinghour: String?
//    var schedule_closed: String?
//}


struct EventsStruct: Codable {
    var id: Int?
//    var status: Int?
    var photo: String?
    var name: String?
//    var description_raw: String?
    var description_html: String?
//    var schedule_permanent: String?
//    var schedule_date_warning: String?
//    var schedule_time_alert: String?
    var schedule_start_date: String?
//    var schedule_start_time: String?
    var schedule_end_date: String?
//    var schedule_end_time: String?
//    var schedule_one_day_event: String?
//    var schedule_extra: String?
    var going_count: Int?
//    var went_count: Int?
//    var venua: VenuaStruct
}

struct ResStruct: Codable {
    var events : [EventsStruct]
}
struct PopularStruct : Codable {
    var status : Int
    var response : ResStruct
}
