//
//  Double+Extension.swift
//  Restaurant App
//
//  Created by Евгений Пашко on 18.01.2022.
//

import Foundation

extension Double {
    var formatedHundres: String {
        return String(format: "$%.2f", self)
    }
}
