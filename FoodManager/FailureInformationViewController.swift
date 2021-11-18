//
//  FailureInformationViewController.swift
//  FoodManager
//
//  Created by ESAKI MAKOTO on 2021/11/17.
//

import UIKit

class FailureInformationViewController: UIViewController {

    @IBOutlet weak var failureInformationText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        failureInformationText.text = "現時点での障害情報はございません。\n障害発生時に、順次載せていきます。"
        failureInformationText.isEditable = false
        failureInformationText.isSelectable = false
    }
}
