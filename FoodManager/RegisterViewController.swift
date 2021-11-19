//
//  RegisterViewController.swift
//  FoodManager
//
//  Created by ESAKI MAKOTO on 2021/10/29.
//

import UIKit
import FirebaseFirestore
import Firebase
import SVProgressHUD
import GoogleMobileAds

class RegisterViewController: UIViewController, UITextFieldDelegate, GADBannerViewDelegate {
        
    var productNameLength: Int = 14
    var priceLength: Int = 8
    var bannerView: GADBannerView!
    
    @IBOutlet weak var productNameText: UITextField!
    @IBOutlet weak var priceText: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func registerButton(_ sender: Any) {
        if let productName = productNameText.text {
            if productName.isEmpty {
                SVProgressHUD.showError(withStatus: "品名を入力して下さい。")
                SVProgressHUD.dismiss(withDelay: 1)
                return
            } else if productName.count > productNameLength {
                SVProgressHUD.showError(withStatus: "品名は14文字以内で入力して下さい。")
                SVProgressHUD.dismiss(withDelay: 1)
                return
            } else if Double(productName) != nil {
                SVProgressHUD.showError(withStatus: "品名は文字を入力して下さい。")
                SVProgressHUD.dismiss(withDelay: 1)
                return
            }
            if let price = priceText.text {
                if price.isEmpty {
                    SVProgressHUD.showError(withStatus: "金額を入力して下さい。")
                    SVProgressHUD.dismiss(withDelay: 1)
                    return
                }
                else if price.count > priceLength {
                    SVProgressHUD.showError(withStatus: "金額は8桁以内で入力して下さい。")
                    SVProgressHUD.dismiss(withDelay: 1)
                    return
                }
                let intPrice = Int((price as NSString).doubleValue)
                if segmentedControl.selectedSegmentIndex == 0{
                    let spending = "支出"
                    Firestore.firestore().collection(Collection.documentPath).addDocument(data:["timestamp": Firebase.Timestamp(),"balanceOfPayments": spending,"productName": productName, "price": intPrice])
                } else if segmentedControl.selectedSegmentIndex == 1 {
                    let income = "収入"
                    Firestore.firestore().collection(Collection.documentPath).addDocument(data:["timestamp": Firebase.Timestamp(), "balanceOfPayments": income, "productName": productName, "price": intPrice])
                }
            }
        }
        SVProgressHUD.showSuccess(withStatus: "登録しました。")
        SVProgressHUD.dismiss(withDelay: 1)
        self.productNameText.text = ""
        self.priceText.text = ""
        self.priceText.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.priceText.keyboardType = UIKeyboardType.numberPad
        self.productNameText.delegate = self
        bannerView = GADBannerView(adSize: kGADAdSizeLargeBanner)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.productNameText.text = ""
        self.priceText.text = ""
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
