//
//  CategoryTableViewController.swift
//  Restaurant App
//
//  Created by Евгений Пашко on 18.01.2022.
//

import UIKit

class CategoryTableViewController: UITableViewController {
    
    // MARK: - Properties
    private let networkManager = NetworkManager()
    private var categories = [String]()
    private let cellManager = CellManager()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getCategories()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "MenuSegue" else { return }
        guard let categoryIndex = tableView.indexPathForSelectedRow else { return }
        let destination = segue.destination as! MenuTableViewController
        destination.category = categories[categoryIndex.row]
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell",for: indexPath)
        cellManager.configure(cell, with: categories[indexPath.row])
        return cell
    }
    
    // MARK: - Methods
    private func getCategories() {
        networkManager.getCategories { categories, error in
            guard let categories = categories else {
                if let error = error {
                    // print(#line, #function, "ERROR:",error.localizedDescription)
                } else {
                    // print(#line, #function, "ERROR: Can't load categories")
                }
                return
            }
            
            self.categories = categories
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
