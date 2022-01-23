//
//  NetworkManager.swift
//  Restaurant App
//
//  Created by Евгений Пашко on 18.01.2022.
//

import Foundation
import UIKit

class NetworkManager {
    let baseURL = URL(string: "http://mda.getoutfit.co:8090")!
    
    //MARK: - GET Methods
    func getCategories(complection: @escaping ([String]?, Error?) -> Void) {
        let url = baseURL.appendingPathComponent("categories")
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                complection(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let decodedData = try? decoder.decode(Categories.self, from: data)
                complection(decodedData?.categories, nil)
            } catch let error {
                complection(nil, error)
            }
        }
        task.resume()
    }
    
    func getMenuItems(for category: String, complection: @escaping ([MenuItem]?, Error?) -> Void) {
        let initialUrl = baseURL.appendingPathComponent("menu")
        guard let url = initialUrl.withQueries(["category" : category]) else {
            complection(nil, nil)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                complection(nil, error)
                return
            }
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(MenuItems.self, from: data)
                complection(decodedData.items, nil)
            } catch let error {
                complection(nil, error)
                
            }
        }
        task.resume()
    }
    
    func getImage(_ initialUrl: URL, completion: @escaping (UIImage?, Error?) -> Void) {
        var components = URLComponents(url: initialUrl,resolvingAgainstBaseURL: true)
        components?.host = baseURL.host
        guard let url = components?.url else {
            completion(nil, nil)
            return
        }
        let task = URLSession.shared.dataTask(with: url) {data, _, error in
            guard let data = data else {
                completion(nil, nil)
                return
            }
            let image = UIImage(data: data)
            completion(image, nil)
        }
        task.resume()
    }
    
    
    //MARK: - POST Methods
    func submitOrder(forMenuIDs menuIDs: [Int], completion: @escaping (Int?, Error?) -> Void) {
        let url = baseURL.appendingPathComponent("order")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let data = ["menuIds": menuIDs]
        let encoder = JSONEncoder()
        let jsonData = try? encoder.encode(data)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                completion(nil, error)
                return
            }
            guard let data = data else {
                completion(nil, nil)
                return
            }
            let decoder = JSONDecoder()
            guard let preparationTime = try? decoder.decode(PreparationTime.self, from: data) else {
                completion(nil, nil)
                return
            }
            completion(preparationTime.prepTime, nil)
        }
        task.resume()
    }
}
