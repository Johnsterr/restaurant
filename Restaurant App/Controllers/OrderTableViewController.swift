//
//  OrderTableViewController.swift
//  Restaurant App
//
//  Created by Евгений Пашко on 18.01.2022.
//

import UIKit

class OrderTableViewController: UITableViewController {
    
    @IBOutlet weak var submitButton: UIBarButtonItem!
    
    
    // MARK: - Properties
    private var cellManager = CellManager()
    private let networkManager = NetworkManager()
    
    // Store minutes
    var minutes = 0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Added Edited Button
        navigationItem.setLeftBarButton(editButtonItem, animated: false)
        NotificationCenter.default.addObserver(
            tableView!,
            selector: #selector(UITableView.reloadData),
            name: OrderManager.orderUpdateNotification,
            object: nil
        )
        
        //Hide Edit Button Edit and Submit, if OrderList is Empty.
        submitButton.isEnabled = false
        checkEditButton()
    }
    
    
    //MARK: - UITableViewSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OrderManager.share.order.menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell",for: indexPath)
        let menuItem = OrderManager.share.order.menuItems[indexPath.row]
        cellManager.configure(cell, with: menuItem, for: tableView, IndexPath: indexPath)
        checkEditButton()
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "OrderConfirmationSegue" else { return }
        let destination = segue.destination as! OrderConfirmationViewController
        destination.minutes = minutes
        
    }
    
    // Move UITableView rows
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedTodos = OrderManager.share.order.menuItems.remove(at: sourceIndexPath.row)
        OrderManager.share.order.menuItems.insert(movedTodos, at: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    
    // MARK: - Custom Methods
    private func uploadOrder() {
        let menuIds = OrderManager.share.order.menuItems.map { $0.id }
        networkManager.submitOrder(forMenuIDs: menuIds) { minutes, error in
            if let error = error {
                // print(#line,#function, "ERROR: \(error.localizedDescription)")
            } else {
                guard let minutes = minutes else {
                    // print(#line,#function, "ERROR: didn't get minutes from server")
                    return
                }
                self.minutes = minutes
                // print(#line,#function, minutes)
                DispatchQueue.main.async {
                self.performSegue(withIdentifier: "OrderConfirmationSegue", sender: nil)
                }
            }
        }
    }
    
    // Check and hide buttons if list order is empty
    private func checkEditButton() {
        navigationItem.leftBarButtonItem?.isEnabled = OrderManager.share.order.menuItems.count != 0 ? true : false
        submitButton.isEnabled = OrderManager.share.order.menuItems.count != 0 ? true : false
    }
    
    
    // MARK: - IBActions
    @IBAction func unwind(_ segue: UIStoryboardSegue)  {
        OrderManager.share.order = Order()
    }
    
    @IBAction func submitButton(_ sender: UIBarButtonItem) {
        let orderTotal = OrderManager.share.order.menuItems.reduce(0) { $0 + $1.price }
        let alert = UIAlertController(
            title: "Confirm Order",
            message: "You are about to submit your order with a total of \(orderTotal.formatedHundres)",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Submit", style: .default) { _ in
            self.uploadOrder()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert,animated: true)
    }
    
}

// MARK: - UITableViewDelegate
extension OrderTableViewController /*: UITableViewDelegate */ {
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            //Remove row from table
            OrderManager.share.order.menuItems.remove(at: indexPath.row)
        case .insert:
            break
        case .none:
            break
        @unknown default:
            // print(#line, #function, "Unknown case in filie \(#file)")
            break
            
        }
        checkEditButton()
    }
}
