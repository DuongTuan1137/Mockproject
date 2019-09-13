//
//  NewModel.swift
//  MockProject
//
//  Created by AnhDCT on 9/11/19.
//  Copyright © 2019 AnhDCT. All rights reserved.
//

import Foundation
import UIKit
struct NewsStruct: Codable {
    var title : String
    var thumb_img : String
    var detail_url : String
    var feed : String
    var author : String
    var publish_date : String
}

struct ResponseStruct: Codable {
    var news: [NewsStruct]
}

struct JsonStruct: Codable {
    var status: Int
    var response: ResponseStruct
}
