//
//  ScheduledUpdatedViewController.swift
//  FoodManager
//
//  Created by ESAKI MAKOTO on 2021/11/17.
//

import UIKit

class ScheduledUpdatedViewController: UIViewController {

    @IBOutlet weak var scheduledUpdatedText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduledUpdatedText.text = "・収入と支出を区別できるようにします。\n・分類を追加します。"
        scheduledUpdatedText.isEditable = false
        scheduledUpdatedText.isSelectable = false
    }
}
