//
//  ListViewController.swift
//  FoodManager
//
//  Created by ESAKI MAKOTO on 2021/10/29.
//

import UIKit
import FirebaseFirestore
import GoogleMobileAds

struct Spending {
    var yearMonth: String
    var spending: Int
}

struct Income {
    var yearMonth: String
    var income: Int
}

struct Diffence {
    var yearMonth: String
    var diffence: Int
}

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate {

    var spending: Int = 0
    var income: Int = 0
    var spendingArray: [Spending] = []
    var incomeArray: [Income] = []
    var differenceArray: [Diffence] = []
    var bannerView: GADBannerView!
    
    @IBOutlet weak var totalValue: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    @IBAction func setAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            self.totalValue.text = formatter.string(from: NSNumber(integerLiteral: self.spending))! + "円"
            self.tableView.reloadData()
        case 1:
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            self.totalValue.text = formatter.string(from: NSNumber(integerLiteral: self.income))! + "円"
            self.tableView.reloadData()
        case 2:
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            self.totalValue.text = formatter.string(from: NSNumber(integerLiteral: self.income - self.spending))! + "円"
            self.tableView.reloadData()
        default:
            print("該当なし")
        }
    }
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "ListTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ListCell")
        bannerView = GADBannerView(adSize: kGADAdSizeLargeBanner)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        spending = 0
        income = 0
        Firestore.firestore().collection(Collection.documentPath).getDocuments { (querySnapShot, error) in
            if let error = error {
                print(error)
                return
            } else {
                for document in querySnapShot!.documents {
                    let documentPrice = document.data()["price"] as! Int
                    let documentbalanceOfPayments = document.data()["balanceOfPayments"] as! String
                    if documentbalanceOfPayments == "支出" {
                        self.spending = documentPrice + self.spending
                    } else {
                        self.income = documentPrice + self.income
                    }
                    if self.segmentedControl.selectedSegmentIndex == 0 {
                        let formatter = NumberFormatter()
                        formatter.numberStyle = .decimal
                        self.totalValue.text = formatter.string(from: NSNumber(integerLiteral: self.spending))! + "円"
                    } else if self.segmentedControl.selectedSegmentIndex == 1 {
                        let formatter = NumberFormatter()
                        formatter.numberStyle = .decimal
                        self.totalValue.text = formatter.string(from: NSNumber(integerLiteral: self.income))! + "円"
                    } else {
                        let formatter = NumberFormatter()
                        formatter.numberStyle = .decimal
                        self.totalValue.text = formatter.string(from: NSNumber(integerLiteral: self.income - self.spending))! + "円"
                    }
                }
            }
        }
        Firestore.firestore().collection(Collection.documentPath).order(by: "timestamp", descending: true).getDocuments { (querySnapShot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                for document in querySnapShot!.documents {
                    let documentTimestamp = document.data()["timestamp"] as! Timestamp
                    let documentPrice = document.data()["price"] as! Int
                    let documentBalanceOfPayments = document.data()["balanceOfPayments"] as! String
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy年MM月"
                    let stringTimestamp = formatter.string(from: documentTimestamp.dateValue())
                    var hitSpendingIndex: Int?
                    for (index, spending) in self.spendingArray.enumerated() {
                        if spending.yearMonth == stringTimestamp {
                            hitSpendingIndex = index
                        }
                    }
                    if self.segmentedControl.selectedSegmentIndex == 0 || self.segmentedControl.selectedSegmentIndex == 1 || self.segmentedControl.selectedSegmentIndex == 2 {
                        if let hitSpendingIndex = hitSpendingIndex {
                            if documentBalanceOfPayments == "支出" {
                                var sumally = self.spendingArray[hitSpendingIndex]
                                sumally.spending = sumally.spending + documentPrice
                                self.spendingArray[hitSpendingIndex] = sumally
                            }
                        } else {
                            if documentBalanceOfPayments == "支出" {
                                self.spendingArray.append(Spending(yearMonth: stringTimestamp, spending: documentPrice))
                            }
                        }
                    }
                    var hitIncomeIndex: Int?
                    for (index, income) in self.incomeArray.enumerated() {
                        if income.yearMonth == stringTimestamp {
                            hitIncomeIndex = index
                        }
                    }
                    if self.segmentedControl.selectedSegmentIndex == 0 || self.segmentedControl.selectedSegmentIndex == 1 || self.segmentedControl.selectedSegmentIndex == 2 {
                        if let hitIncomeIndex = hitIncomeIndex {
                            if documentBalanceOfPayments == "収入" {
                                var sumally = self.incomeArray[hitIncomeIndex]
                                sumally.income = sumally.income + documentPrice
                                self.incomeArray[hitIncomeIndex] = sumally
                            }
                        } else {
                            if documentBalanceOfPayments == "収入" {
                                self.incomeArray.append(Income(yearMonth: stringTimestamp, income: documentPrice))
                            }
                        }
                    }
                    var hitDiffenceIndex: Int?
                    for (index, diffence) in self.differenceArray.enumerated() {
                        if diffence.yearMonth == stringTimestamp {
                            hitDiffenceIndex = index
                        }
                    }
                    if self.segmentedControl.selectedSegmentIndex == 0 || self.segmentedControl.selectedSegmentIndex == 1 || self.segmentedControl.selectedSegmentIndex == 2 {
                        if let hitDiffenceIndex = hitDiffenceIndex {
                            if documentBalanceOfPayments == "収入" {
                                var sumally = self.differenceArray[hitDiffenceIndex]
                                sumally.diffence = documentPrice + sumally.diffence
                                self.differenceArray[hitDiffenceIndex] = sumally
                            } else {
                                var sumally = self.differenceArray[hitDiffenceIndex]
                                print(sumally.diffence)
                                sumally.diffence = sumally.diffence - documentPrice
                                self.differenceArray[hitDiffenceIndex] = sumally
                            }
                        } else {
                            if documentBalanceOfPayments == "収入" {
                                self.differenceArray.append(Diffence(yearMonth: stringTimestamp, diffence: documentPrice))
                            } else {
                                self.differenceArray.append(Diffence(yearMonth: stringTimestamp, diffence: -documentPrice))
                            }
                        }
                    }
                }
                print(self.differenceArray)
                self.tableView.reloadData()
            }
        }
        self.spendingArray.removeAll()
        self.incomeArray.removeAll()
        self.differenceArray.removeAll()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            return self.spendingArray.count
        } else if self.segmentedControl.selectedSegmentIndex == 1 {
            return self.incomeArray.count
        } else if self.segmentedControl.selectedSegmentIndex == 2 {
            return self.differenceArray.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! ListTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        if self.segmentedControl.selectedSegmentIndex == 0 {
            cell.setSpendingCell(spendingArray[indexPath.row])
        } else if self.segmentedControl.selectedSegmentIndex == 1 {
            cell.setIncomeCell(incomeArray[indexPath.row])
        } else {
            cell.setDiffence(differenceArray[indexPath.row])
        }
        return cell
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        addBannerViewToView(bannerView)
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
        })
    }
}
