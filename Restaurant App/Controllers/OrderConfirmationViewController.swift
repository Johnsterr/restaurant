//
//  OrderConfirmationViewController.swift
//  Restaurant App
//
//  Created by Евгений Пашко on 18.01.2022.
//

import UIKit

class OrderConfirmationViewController: UIViewController {
    
    @IBOutlet weak var timeRemainingLabel: UILabel!
    public var minutes: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        timeRemainingLabel.text = "Thank you for your order! Your waiting time is approximately \(minutes!) minutes."

    }
}
