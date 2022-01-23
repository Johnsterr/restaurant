//
//  Order.swift
//  Restaurant App
//
//  Created by Евгений Пашко on 18.01.2022.
//

import Foundation

struct Order {
    var menuItems: [MenuItem]
    
    init(menuItems: [MenuItem] = []) {
        self.menuItems = menuItems
    }
}
