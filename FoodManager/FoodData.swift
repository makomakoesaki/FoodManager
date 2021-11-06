//
//  FoodData.swift
//  FoodManager
//
//  Created by ESAKI MAKOTO on 2021/10/29.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class FoodData: NSObject {
    var id: String
    var food: String
    var number: Int
    var plice: Int
    var pliceArray: [Int]
    var date: Date
    var dateArray: [Date]
    
    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID
        let foodDic = document.data()
        self.food = foodDic["food"] as! String
        self.number = foodDic["number"] as! Int
        self.plice = foodDic["plice"] as! Int
        self.pliceArray = [self.plice]
        let timeStamp = foodDic["date"] as! Timestamp
        self.date = timeStamp.dateValue()
        self.dateArray = [self.date]
    }
}
