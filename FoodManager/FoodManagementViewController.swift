//
//  FoodManagementViewController.swift
//  FoodManager
//
//  Created by ESAKI MAKOTO on 2021/10/29.
//

import UIKit
import FirebaseFirestore
import SVProgressHUD

class FoodManagementViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var foodArray: [FoodData] = []
    var listener: ListenerRegistration?
    
    @IBAction func registerButton(_ sender: Any) {
        let foodInputScreenViewController = storyboard?.instantiateViewController(withIdentifier: "InputScreen")
        present(foodInputScreenViewController!, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "FoodTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let foodRef = Firestore.firestore().collection(Const.FoodPath).order(by: "food", descending: true)
        listener = foodRef.addSnapshotListener() { (querysnapshot, error) in
            if let error = error {
                SVProgressHUD.showError(withStatus: "\(error)")
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
