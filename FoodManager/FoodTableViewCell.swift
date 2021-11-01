//
//  FoodTableViewCell.swift
//  FoodManager
//
//  Created by ESAKI MAKOTO on 2021/10/29.
//

import UIKit

class FoodTableViewCell: UITableViewCell {

    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var numberlabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setFoodData(_ foodData: FoodData) {
        self.foodLabel.text = foodData.food
        self.numberlabel.text = "\(foodData.number)"
        self.priceLabel.text = "\(foodData.plice)"
    }
}
