//
//  DocumentTableViewCell.swift
//  FoodManager
//
//  Created by ESAKI MAKOTO on 2021/10/29.
//

import UIKit

class DocumentTableViewCell: UITableViewCell {

    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDocumentData(_ document: Document) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy年MM月dd日 EEE曜日 HH時mm分"
        let stringTimestamp = formatter.string(from: document.timestamp.dateValue())
        self.dateLabel.text = stringTimestamp
        self.productNameLabel.text = document.productName
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        self.priceLabel.text = numberFormatter.string(from: NSNumber(integerLiteral: document.price))! + "円"
    }
}

