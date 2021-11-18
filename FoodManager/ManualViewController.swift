//
//  ManualViewController.swift
//  FoodManager
//
//  Created by ESAKI MAKOTO on 2021/11/17.
//

import UIKit

class ManualViewController: UIViewController {

    @IBOutlet weak var manualText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manualText.text = ""
        manualText.isEditable = false
        manualText.isSelectable = false
    }
}
