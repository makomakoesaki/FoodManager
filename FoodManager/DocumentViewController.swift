//
//  DocumentViewController.swift
//  FoodManager
//
//  Created by ESAKI MAKOTO on 2021/10/29.
//

import UIKit
import FirebaseFirestore
import SVProgressHUD

class DocumentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var documentArray: [Document] = []
    var timeStampArray: [String] = []
    var listener: ListenerRegistration?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "DocumentTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "DocumentCell")
        searchBar.delegate = self
        searchBar.resignFirstResponder()
        searchBar.searchBarStyle = .minimal
        searchBar.setShowsCancelButton(true, animated: true)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath) as! DocumentTableViewCell
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
                    let productName = document.data()["productName"] as! String
                    let timestamp = document.data()["timestamp"] as! Timestamp
                    let formatter = DateFormatter()
                    formatter.locale = Locale(identifier: "ja_JP")
                    formatter.dateFormat = "yyyy"
                    self.timeStampArray.append(formatter.string(from: timestamp.dateValue()))
                    formatter.dateFormat = "MM"
                    self.timeStampArray.append(formatter.string(from: timestamp.dateValue()))
                    formatter.dateFormat = "dd"
                    self.timeStampArray.append(formatter.string(from: timestamp.dateValue()))
                    formatter.dateFormat = "MMdd"
                    self.timeStampArray.append(formatter.string(from: timestamp.dateValue()))
                    formatter.dateFormat = "yyyyMM"
                    self.timeStampArray.append(formatter.string(from: timestamp.dateValue()))
                    formatter.dateFormat = "yyyyMMdd"
                    self.timeStampArray.append(formatter.string(from: timestamp.dateValue()))
                    formatter.dateFormat = "EEE"
                    self.timeStampArray.append(formatter.string(from: timestamp.dateValue()))
                    print(self.timeStampArray)
                    print(self.searchBar.text!)
                    if productName == self.searchBar.text {
                        self.documentArray = self.documentArray.filter({ $0.productName.lowercased().contains((self.searchBar.text?.lowercased())!) })
                        print(self.documentArray)
                    }
                    if self.timeStampArray.contains(self.searchBar.text!)  {
                        self.documentArray = self.documentArray.filter({ $0.timeStampArray.contains((self.searchBar.text?.lowercased())!) })
                        print(self.documentArray)
                    }
                }
                if self.documentArray.filter({ $0.productName == searchBar.text }).isEmpty && self.timeStampArray.contains(self.searchBar.text!) == false {
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
}
