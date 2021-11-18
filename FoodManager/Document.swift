//
//  Document.swift
//  FoodManager
//
//  Created by ESAKI MAKOTO on 2021/10/29.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class Document: NSObject {
    var id: String
    var timestamp: Timestamp
    var timeStampArray: [String] = []
    var productName: String
    var price: Int
    
    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID
        let documentDic = document.data()
        self.timestamp = documentDic["timestamp"] as! Timestamp
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy"
        self.timeStampArray.append(formatter.string(from: timestamp.dateValue()))
        formatter.dateFormat = "MM"
        self.timeStampArray.append(formatter.string(from: timestamp.dateValue()))
        formatter.dateFormat = "dd"
        self.timeStampArray.append(formatter.string(from: timestamp.dateValue()))
        formatter.dateFormat = "MMdd"
        self.timeStampArray.append(formatter.string(from: timestamp.dateValue()))
        formatter.dateFormat = "yyyyMM"
        self.timeStampArray.append(formatter.string(from: timestamp.dateValue()))
        formatter.dateFormat = "yyyyMMdd"
        self.timeStampArray.append(formatter.string(from: timestamp.dateValue()))
        formatter.dateFormat = "EEE"
        self.timeStampArray.append(formatter.string(from: timestamp.dateValue()))
        self.productName = documentDic["productName"] as! String
        self.price = documentDic["price"] as! Int
    }
}
