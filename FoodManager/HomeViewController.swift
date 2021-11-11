//
//  HomeViewController.swift
//  FoodManager
//
//  Created by ESAKI MAKOTO on 2021/10/29.
//

import UIKit
import FirebaseFirestore

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var totalValue: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var totalPlice: Int!
    var foodArray: [FoodData] = []
    var listener: ListenerRegistration?
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "MonthTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "HomeCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        totalPlice = 0
        Firestore.firestore().collection(Const.FoodPath).getDocuments() { (querySnapshot, error) in
            if let error = error {
                print(error)
                return
            } else {
                for document in querySnapshot!.documents {
                    let documentPlice = document.data()["plice"] as! Int
                    self.totalPlice = documentPlice + self.totalPlice
                }
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                self.totalValue.text = formatter.string(from: NSNumber(integerLiteral: self.totalPlice))! + "円"
            }
        }
        listener = Firestore.firestore().collection(Const.FoodPath).order(by: "date", descending: true).addSnapshotListener() { (querysnapshot, error) in
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
        return self.foodArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as! MonthTableViewCell
        cell.setPliceData(foodArray[indexPath.row])
        return cell
    }
}
