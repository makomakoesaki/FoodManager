//
//  ListTableViewCell.swift
//  FoodManager
//
//  Created by ESAKI MAKOTO on 2021/11/10.
//

import UIKit
import FirebaseFirestore

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var yearMonthLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setSpendingCell(_ cell: Spending) {
        self.yearMonthLabel.text = cell.yearMonth
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        self.priceLabel.text = formatter.string(from: NSNumber(integerLiteral: cell.spending))! + "円"
    }
    
    func setIncomeCell(_ cell: Income) {
        self.yearMonthLabel.text = cell.yearMonth
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        self.priceLabel.text = formatter.string(from: NSNumber(integerLiteral: cell.income))! + "円"
    }
    
    func setDiffence(_ cell: Diffence) {
        self.yearMonthLabel.text = cell.yearMonth
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        self.priceLabel.text = formatter.string(from: NSNumber(integerLiteral: cell.diffence))! + "円"
    }
}
