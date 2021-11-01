//
//  FUICustomAuthPickerViewController.swift
//  FoodManager
//
//  Created by ESAKI MAKOTO on 2021/10/31.
//

import UIKit
import FirebaseAuthUI

class FUICustomAuthPickerViewController: FUIAuthPickerViewController,FUIAuthDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    private func setupUI() {
        self.authUI.shouldHideCancelButton = true
        self.view.subviews[0].subviews[0].subviews[0].subviews.forEach { (view: UIView) in
            if let button = view as? UIButton {
                button.layer.cornerRadius = 20.0
                button.layer.masksToBounds = true
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
}
