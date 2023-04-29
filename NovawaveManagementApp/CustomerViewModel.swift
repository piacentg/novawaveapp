//
//  CustomerViewModel.swift
//  NovawaveManagementApp
//
//  Created by Gabriella Piacentino on 4/28/23.
//

import Foundation
import FirebaseFirestore

@MainActor

class CustomerViewModel: ObservableObject {
    @Published var customer = Customer()
    
    func saveCustomer(customer: Customer) async -> Bool {
        let db = Firestore.firestore() // ignore any error that shows up here. Wait for indexing. Clean build if it persists with shift+command+K. Error usually goes away with build + run. Otherwise try restarting Mac/Xcode and deleting derived data. For instructions on derived data deletion, see: https://deriveddata.dance
        
        if let id = customer.id { // spot must alrady exist, so save
            do {
                try await db.collection("customers").document(id).setData(customer.dictionary)
                print("😎 Data updated successfully!")
                return true
            } catch {
                print("😡 ERROR: Could not update data in 'customers' \(error.localizedDescription)")
                return false
            }
        } else { // no id? Then this must be a new spot to add
            do {
                let documentRef = try await db.collection("customers").addDocument(data: customer.dictionary)
                self.customer = customer
                self.customer.id = documentRef.documentID
                print("🐣 Data added successfully!")
                return true
            } catch {
                print("😡 ERROR: Could not create a new spot in 'customers' \(error.localizedDescription)")
                return false
            }
        }
    }
}

