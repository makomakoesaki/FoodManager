//
//  UpdateNoticeViewController.swift
//  FoodManager
//
//  Created by ESAKI MAKOTO on 2021/11/17.
//

import UIKit

class UpdateNoticeViewController: UIViewController {

    @IBOutlet weak var updateNoticeText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateNoticeText.text = "現時点での更新のお知らせはございません。\n更新後に、順次載せていきます。"
        updateNoticeText.isEditable = false
        updateNoticeText.isSelectable = false
    }
}
