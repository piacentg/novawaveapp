//
//  CustomerListView.swift
//  NovawaveManagementApp
//
//  Created by Gabriella Piacentino on 4/28/23.
//
import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct CustomerListView: View {
    @FirestoreQuery(collectionPath: "customers") var customers: [Customer]
    @State private var sheetIsPresented = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Image("header")
                .resizable()
                .scaledToFit()
            
            List(customers) { customer in
                NavigationLink {
                    CustomerDetailView(customer: customer)
                } label: {
                    Text(customer.name)
                        .font(.title2)
                }
                
            }
            .listStyle(.plain)
            .navigationTitle("Customers")
            .navigationBarTitleDisplayMode(.inline) // Bug shows large jump
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Sign Out") {
                        do {
                            try Auth.auth().signOut()
                            print("🪵➡️ Log out successful!")
                            dismiss()
                        } catch {
                            print("😡 ERROR: Could not sign out!")
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        sheetIsPresented.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $sheetIsPresented) {
                NavigationStack {
                    CustomerDetailView(customer: Customer())
                }
            }
        }
    }
}

struct CustomerListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CustomerListView()
        }
    }
}
