//
//  Room.swift
//  NovawaveManagementApp
//
//  Created by Gabriella Piacentino on 4/28/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift


enum ProductType: String, CaseIterable, Codable {
    case Amazon, Google
}
struct Room: Identifiable, Codable {
    @DocumentID var id: String?
    var title = ""
    var body = ""
    var installer = Auth.auth().currentUser?.email ?? ""
    var date = ""
    
    var productType = ProductType.Amazon.rawValue
    
    var dictionary: [String: Any] {
        return ["title": title, "body": body, "installer": installer, "productType": productType, "date": date]
    }
}


