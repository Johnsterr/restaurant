//
//  PreparationTime.swift
//  Restaurant App
//
//  Created by Евгений Пашко on 18.01.2022.
//

import Foundation

struct PreparationTime: Codable {
    let prepTime: Int
    enum CodingKeys: String, CodingKey {
        case prepTime = "preparation_time"
    }
}
