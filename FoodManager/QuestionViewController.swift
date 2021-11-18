//
//  QuestionViewController.swift
//  FoodManager
//
//  Created by ESAKI MAKOTO on 2021/11/17.
//

import UIKit

class QuestionViewController: UIViewController {

    @IBOutlet weak var questionText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionText.text = "質問が寄せられましたら順次載せていきます。\n質問がある方は、お問い合わせ下さい。"
        questionText.isEditable = false
        questionText.isSelectable = false
    }
}
