//
//  RoomViewModel.swift
//  NovawaveManagementApp
//
//  Created by Gabriella Piacentino on 4/28/23.
//


import Foundation
import FirebaseFirestore

class RoomViewModel: ObservableObject {
    @Published var room = Room()
    
    func saveRoom(customer: Customer, room: Room) async -> Bool {
        let db = Firestore.firestore() // ignore any error that shows up here. Wait for indexing. Clean build if it persists with shift+command+K. Error usually goes away with build + run. Otherwise try restarting Mac/Xcode and deleting derived data. For instructions on derived data deletion, see: https://deriveddata.dance
        
        guard let customerID = customer.id else {
            print("😎 ERROR: customer.id = nil")
            return false
        }
        
        let collectionString = "customers/\(customerID)/rooms"
        
        if let id = room.id { // review must alrady exist, so save
            do {
                try await db.collection(collectionString).document(id).setData(room.dictionary)
                print("😎 Data updated successfully!")
                return true
            } catch {
                print("😡 ERROR: Could not update data in 'rooms' \(error.localizedDescription)")
                return false
            }
        } else { // no id? Then this must be a new review to add
            do {
                _ = try await db.collection(collectionString).addDocument(data: room.dictionary)
                print("🐣 Data added successfully!")
                return true
            } catch {
                print("😡 ERROR: Could not create a new review in 'reviews' \(error.localizedDescription)")
                return false
            }
        }
    }
}

