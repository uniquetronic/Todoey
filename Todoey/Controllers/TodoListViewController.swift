//
//  ViewController.swift
//  Todoey
//
//  Created by Josip on 9/17/19.
//  Copyright © 2019 Josip. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? { // ? because the value may be nil until it is set. Once it is set, it will perform loadItems()
        didSet{
           loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //self.toDoTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
 //      searchBar.delegate = self

    }

//MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell")!
        
        if let item = todoItems?[indexPath.row] {   //checks if nil is present
            cell.textLabel?.text = item.title
            
            //Ternary Operator ==>
            // value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.done == true ? .checkmark : .none
        } else {
            cell.textLabel?.text    = "No Items Added"
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    
//MARK: - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {   //checks if nil is present
            do {
                try realm.write {
                   item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        tableView.reloadData()
    }

//MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var alertTextFieldEntered = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action)
            in //what will happen once the user clicks the Add Item button on our UIAlert
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = alertTextFieldEntered.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }

            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item."
            alertTextFieldEntered = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
//MARK: - Model Manupulation Methods
    

    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
}

//MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate { //extends the TodoListViewcontroller (helps splitting up sections better)
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems() //default action that fetches all the items from the Item list

            DispatchQueue.main.async {          //Ask the dispatch que to prioritize this action (make it foreground)
                searchBar.resignFirstResponder()
            }

        }
    }

}
