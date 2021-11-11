//
//  FoodManagementViewController.swift
//  FoodManager
//
//  Created by ESAKI MAKOTO on 2021/10/29.
//

import UIKit
import FirebaseFirestore
import SVProgressHUD

class FoodManagementViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var foodArray: [FoodData] = []
    var listener: ListenerRegistration?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "FoodTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        searchBar.delegate = self
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        let foodRef = Firestore.firestore().collection(Const.FoodPath).order(by: "date", descending: true)
        listener = foodRef.addSnapshotListener() { (querysnapshot, error) in
            if let error = error {
                print(error)
                return
            }
            self.foodArray = querysnapshot!.documents.map { document in
                let foodData = FoodData(document: document)
                return foodData
            }
            self.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        listener?.remove()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FoodTableViewCell
        cell.setFoodData(foodArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "削除") { (action, view, completionHandler) in
            let removed = self.foodArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
            Firestore.firestore().collection(Const.FoodPath).document(removed.id).delete()
            
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        Firestore.firestore().collection(Const.FoodPath).getDocuments { (snap, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                for i in snap!.documents {
                    let food = i.get("food") as! String
                    if food == self.searchBar.text {
                        self.foodArray = self.foodArray.filter({ $0.food.lowercased().contains((self.searchBar.text?.lowercased())!) })
                    }
                }
                if self.foodArray.filter({ $0.food == searchBar.text }).isEmpty {
                    SVProgressHUD.showError(withStatus: "データは見つかりませんでした。")
                    SVProgressHUD.dismiss(withDelay: 1)
                } else {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let foodRef = Firestore.firestore().collection(Const.FoodPath).order(by: "date", descending: true)
        listener = foodRef.addSnapshotListener() { (querysnapshot, error) in
            if let error = error {
                print(error)
                return
            }
            self.foodArray = querysnapshot!.documents.map { document in
                let foodData = FoodData(document: document)
                return foodData
            }
            self.tableView.reloadData()
        }
    }
}
