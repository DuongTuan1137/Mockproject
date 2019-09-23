//
//  BrowseModel.swift
//  MockProject
//
//  Created by AnhDCT on 9/23/19.
//  Copyright © 2019 AnhDCT. All rights reserved.
//

import Foundation
struct BrowseModel: Codable {
    var status : Int
    var response: ResponseCategories
}

struct ResponseCategories: Codable {
    var categories: [CategoryStruct]
}

struct CategoryStruct: Codable {
    var id: Int
    var name: String
}
