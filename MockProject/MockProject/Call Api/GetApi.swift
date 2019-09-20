//
//  GetApi.swift
//  MockProject
//
//  Created by AnhDCT on 9/20/19.
//  Copyright © 2019 AnhDCT. All rights reserved.
//

import Foundation
func getGenericData<T: Decodable>(urlString: String, completion: @escaping (T) -> ()) {
    guard let url = URL(string: urlString) else { return }
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data else { return }
        do {
            let json = try JSONDecoder().decode(T.self, from: data)
            completion(json)
        } catch let err {
            print(err.localizedDescription)
        }
    }.resume()
}
