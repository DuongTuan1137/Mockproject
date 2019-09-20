//
//  PostApi.swift
//  MockProject
//
//  Created by AnhDCT on 9/20/19.
//  Copyright © 2019 AnhDCT. All rights reserved.
//

import Foundation
func postGenericData<T: Decodable> (urlString: String, parameters:[String: String?], completion: @escaping (T) -> ()) {
    guard let url = URL(string: urlString) else { return }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
    request.httpBody = httpBody
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let data = data {
            do {
                let json = try JSONDecoder().decode(T.self, from: data)
                completion(json)
            } catch let err{
                print(err.localizedDescription)
            }
        }
    }.resume()
}
