//
//  OrderManager.swift
//  Restaurant App
//
//  Created by Евгений Пашко on 18.01.2022.
//

import Foundation

class OrderManager {
    static let orderUpdateNotification = Notification.Name("OrderManager.orderUpdated")
    
    static var share = OrderManager()
    
    private init() {}
    
    var order = Order() {
        didSet {
            NotificationCenter.default.post(name: OrderManager.orderUpdateNotification, object: nil)
        }
    }
}
