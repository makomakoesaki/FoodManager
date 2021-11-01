//
//  FoodData.swift
//  FoodManager
//
//  Created by ESAKI MAKOTO on 2021/10/29.
//

import UIKit
import FirebaseFirestore

class FoodData: NSObject {
    var id: String
    var food: String
    var number: Int
    var plice: Int
    
    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID
        let foodDic = document.data()
        self.food = foodDic["food"] as! String
        self.number = foodDic["number"] as! Int
        self.plice = foodDic["plice"] as! Int
    }
}
