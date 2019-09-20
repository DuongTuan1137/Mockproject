//
//  PostModel.swift
//  MockProject
//
//  Created by AnhDCT on 9/20/19.
//  Copyright © 2019 AnhDCT. All rights reserved.
//

import Foundation
struct ResponsePost: Codable {
    var token : String?
}
struct ResponseSample: Codable {
    var status: Int
    var response : ResponsePost?
    var error_message: String?
}
