//
//  SearchViewController.swift
//  FoodManager
//
//  Created by ESAKI MAKOTO on 2021/10/29.
//

import UIKit
import FirebaseFirestore
import SVProgressHUD
import GoogleMobileAds

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, GADBannerViewDelegate {
    
    var documentArray: [Document] = []
    var timeStampArray: [String] = []
    var listener: ListenerRegistration?
    var bannerView: GADBannerView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.endEditing(true)
        let nib = UINib(nibName: "SearchTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SearchCell")
        searchBar.delegate = self
        searchBar.resignFirstResponder()
        searchBar.searchBarStyle = .minimal
        searchBar.setShowsCancelButton(true, animated: true)
        bannerView = GADBannerView(adSize: kGADAdSizeLargeBanner)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.text = ""
        self.navigationController?.isNavigationBarHidden = true
        Firestore.firestore().collection(Collection.documentPath).order(by: "timestamp", descending: true).getDocuments { (querySnapShot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                self.documentArray = querySnapShot!.documents.map { document in
                    let documentData = Document(document: document)
                    return documentData
                }
            }
            self.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        listener?.remove()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.setDocumentData(documentArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "削除") { (action, view, completionHandler) in
            let removed = self.documentArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
            Firestore.firestore().collection(Collection.documentPath).document(removed.id).delete()
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        Firestore.firestore().collection(Collection.documentPath).getDocuments { (querySnapShot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                for document in querySnapShot!.documents {
                    let documentproductName = document.data()["productName"] as! String
                    let documentTimestamp = document.data()["timestamp"] as! Timestamp
                    let documentBalanceOfPayments = document.data()["balanceOfPayments"] as! String
                    let formatter = DateFormatter()
                    formatter.locale = Locale(identifier: "ja_JP")
                    formatter.dateFormat = "yyyy"
                    self.timeStampArray.append(formatter.string(from: documentTimestamp.dateValue()))
                    formatter.dateFormat = "MM"
                    self.timeStampArray.append(formatter.string(from: documentTimestamp.dateValue()))
                    formatter.dateFormat = "dd"
                    self.timeStampArray.append(formatter.string(from: documentTimestamp.dateValue()))
                    formatter.dateFormat = "MMdd"
                    self.timeStampArray.append(formatter.string(from: documentTimestamp.dateValue()))
                    formatter.dateFormat = "yyyyMM"
                    self.timeStampArray.append(formatter.string(from: documentTimestamp.dateValue()))
                    formatter.dateFormat = "yyyyMMdd"
                    self.timeStampArray.append(formatter.string(from: documentTimestamp.dateValue()))
                    formatter.dateFormat = "EEE"
                    self.timeStampArray.append(formatter.string(from: documentTimestamp.dateValue()))
                    if documentproductName == self.searchBar.text {
                        self.documentArray = self.documentArray.filter({ $0.productName.lowercased().contains((self.searchBar.text?.lowercased())!) })
                        print(self.documentArray)
                    }
                    if self.timeStampArray.contains(self.searchBar.text!)  {
                        self.documentArray = self.documentArray.filter({ $0.timeStampArray.contains((self.searchBar.text?.lowercased())!) })
                        print(self.documentArray)
                    }
                    if documentBalanceOfPayments == self.searchBar.text {
                        self.documentArray = self.documentArray.filter({ $0.balanceOfPayments.lowercased().contains((self.searchBar.text?.lowercased())!) })
                        print(self.documentArray)
                    }
                }
                if self.documentArray.filter({ $0.productName == searchBar.text }).isEmpty
                    && self.timeStampArray.contains(self.searchBar.text!) == false
                    && self.documentArray.filter({ $0.balanceOfPayments == searchBar.text }).isEmpty {
                    SVProgressHUD.showError(withStatus: "データは見つかりませんでした。")
                    SVProgressHUD.dismiss(withDelay: 1)
                } else {
                    SVProgressHUD.showSuccess(withStatus: "データが見つかりました。")
                    SVProgressHUD.dismiss(withDelay: 1)
                    self.tableView.reloadData()
                }
            }
            self.timeStampArray.removeAll()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        let documentRef = Firestore.firestore().collection(Collection.documentPath).order(by: "timestamp", descending: true)
        listener = documentRef.addSnapshotListener() { (querySnapShot, error) in
            if let error = error {
                print(error)
                return
            }
            self.documentArray = querySnapShot!.documents.map { document in
                let documentData = Document(document: document)
                return documentData
            }
            self.view.endEditing(true)
            self.tableView.reloadData()
        }
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
