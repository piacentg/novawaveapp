//
//  Customer.swift
//  NovawaveManagementApp
//
//  Created by Gabriella Piacentino on 4/28/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

enum HomeType: String, CaseIterable, Codable {
    case House, Townhouse, Apartment
}
struct Customer: Identifiable, Codable{
    @DocumentID var id: String?
    var name = ""
    var contact = ""
    var address = ""
    var sq_ft = ""

    var homeType = HomeType.House.rawValue

    var dictionary: [String: Any] {
        return ["name": name, "contact": contact, "address": address, "sq_ft": sq_ft, "homeType": homeType]
    }
}
