//
//  CustomerDetailView.swift
//  NovawaveManagementApp
//
//  Created by Gabriella Piacentino on 4/28/23.
//



import SwiftUI
import FirebaseFirestoreSwift

struct CustomerDetailView: View {
    
    @EnvironmentObject var customerVM: CustomerViewModel
    // The variable below does not have the right path. We'll change this in .onAppear
    @FirestoreQuery(collectionPath: "customers") var rooms: [Room]
    @State var customer: Customer
    @State private var showRoomViewSheet = false
    @State private var showSaveAlert = false
    @State private var showingAsSheet = false
    @Environment(\.dismiss) private var dismiss
    let regionSize = 500.0 // meters
    var previewRunning = false
    
    var body: some View {
        VStack {
            Group {
                TextField("Name", text: $customer.name)
                    .font(.title)
                
                TextField("Contact", text: $customer.contact)
                    .font(.title)
                    .autocapitalization(.none)
                
                TextField("Address", text: $customer.address)
                    .font(.title)
                
                HStack{
                    Text("Home Type:")
                        .font(.title2)
                    
                    Spacer()
                    
                    Picker("", selection: $customer.homeType) {
                        ForEach(HomeType.allCases, id: \.self) { HomeType in
                            Text(HomeType.rawValue.capitalized)
                                .tag(HomeType.rawValue)
                        }
                    }
                }
                
//                TextField("Square Feet", text: $customer.sq_ft)
//                    .font(.title)
                
            }
            .disabled(customer.id == nil ? false : true)
            .textFieldStyle(.roundedBorder)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray.opacity(0.5), lineWidth: customer.id == nil ? 2 : 0)
            }
            .padding(.horizontal)
            
            
            List {
//                Section {
//                    Text("\(rooms.count)")
//                }
                Section {
                    ForEach(rooms) { room in
                        NavigationLink {
                            RoomView(customer: customer, room: room)
                        } label: {
                            Text("Room Name") //TODO: Build a custom cell showing stars, title, and body
                        }
                    }
                } header: {
                    HStack {
//                        Text("Avg. Rating")
//                            .font(.title2)
//                            .bold()
//                        Text("4.5") //TODO: Change to a computed property
//                            .font(.title)
//                            .fontWeight(.black)
                        Spacer()
                        Button("Add room") {
                            if customer.id == nil {
                                showSaveAlert.toggle()
                            } else {
                                showRoomViewSheet.toggle()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .bold()
                        
                    }
                }
                .headerProminence(.increased)
            }
            .listStyle(.plain)
            
            Spacer()
        }
        .onAppear {
            if !previewRunning && customer.id != nil { // This is to prevent PreviewProvider error
                $rooms.path = "customers/\(customer.id ?? "")/rooms"
                print("reviews.path = \($rooms.path)")
            } else { // spot.id starts out as nil
                showingAsSheet = true
            }
            
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(customer.id == nil)
        .toolbar {
            if showingAsSheet { // New spot, so show Cancel / Save buttons
                if customer.id == nil && showingAsSheet { // New spot, so show Cancel/Save buttons
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            Task {
                                let success = await customerVM.saveCustomer(customer: customer)
                                if success {
                                    dismiss()
                                } else {
                                    print("😡 DANG! Error saving spot!")
                                }
                            }
                            dismiss()
                        }
                    }
                } else if showingAsSheet && customer.id != nil {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showRoomViewSheet) {
            NavigationStack {
                RoomView(customer: customer, room: Room())
            }
        }
        .alert("Cannot Rate Place Unless It is Saved", isPresented: $showSaveAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Save", role: .none) {
                Task {
                    let success = await customerVM.saveCustomer(customer: customer)
                    customer = customerVM.customer
                    if success {
                        // If we didn't update the path after saving spot, we wouldn't be able to show new reviews added
                        $rooms.path = "customers/\(customer.id ?? "")/rooms"
                        showRoomViewSheet.toggle()
                    } else {
                        print("😡 Dang! Error saving spot!")
                    }
                }
            }
        } message: {
            Text("Would you like to save this alert first so that you can enter a review?")
        }
    }
}

struct CustomerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CustomerDetailView(customer: Customer(), previewRunning: true)
                .environmentObject(CustomerViewModel())
        }
    }
}

