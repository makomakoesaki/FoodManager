//
//  MonthlyTotalAmountViewController.swift
//  FoodManager
//
//  Created by ESAKI MAKOTO on 2021/10/29.
//

import UIKit
import FirebaseFirestore

struct Sumally {
    var yyyyMM: String
    var price: Int
}

class MonthlyTotalAmountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var totalValue: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var totalPrice: Int!
    var sumallyArray: [Sumally] = []
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "MonthlyTotalAmountTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MonthlyTotalAmountCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        totalPrice = 0
        Firestore.firestore().collection(Collection.documentPath).getDocuments { (querySnapShot, error) in
            if let error = error {
                print(error)
                return
            } else {
                for document in querySnapShot!.documents {
                    let documentPrice = document.data()["price"] as! Int
                    self.totalPrice = documentPrice + self.totalPrice
                }
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                self.totalValue.text = formatter.string(from: NSNumber(integerLiteral: self.totalPrice))! + "円"
            }
        }
        Firestore.firestore().collection(Collection.documentPath).order(by: "timestamp", descending: true).getDocuments { (querySnapShot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                for document in querySnapShot!.documents {
                    let documentDate = document.data()["timestamp"] as! Timestamp
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy年MM月"
                    let dateString = formatter.string(from: documentDate.dateValue())
                    let documentPrice = document.data()["price"] as! Int
                    var hitSumallyIndex: Int?
                    for (index, sumally) in self.sumallyArray.enumerated() {
                        if sumally.yyyyMM == dateString {
                            hitSumallyIndex = index
                        }
                    }
                    if let hitSumallyIndex = hitSumallyIndex {
                        var sumally = self.sumallyArray[hitSumallyIndex]
                        sumally.price = sumally.price + documentPrice
                        self.sumallyArray[hitSumallyIndex] = sumally
                    } else {
                        self.sumallyArray.append(Sumally(yyyyMM: dateString, price: documentPrice))
                    }
                }
                self.tableView.reloadData()
            }
        }
        self.sumallyArray.removeAll()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sumallyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MonthlyTotalAmountCell") as! MonthlyTotalAmountTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.setSumallyData(sumallyArray[indexPath.row])
        return cell
    }
}
