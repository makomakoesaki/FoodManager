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
        if foodLabel.text == foodData.food {
            numberlabel.text = "\(foodData.number + foodData.number)"
            priceLabel.text = "\(foodData.plice + foodData.plice)"
        } else {
            foodLabel.text = foodData.food
            numberlabel.text = "\(foodData.number)"
            priceLabel.text = "\(foodData.plice)"
        }
    }
}
