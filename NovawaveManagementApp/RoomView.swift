//
//  RoomView.swift
//  NovawaveManagementApp
//
//  Created by Gabriella Piacentino on 4/28/23.
//

//
//  ReviewView.swift
//  SnacktacularUI
//  Created by John Gallaugher on 11/26/22
//  YouTube: YouTube.com/profgallaugher, Twitter: @gallaugher

import SwiftUI

struct RoomView: View {
    @State var customer: Customer
    @State var room: Room
    @StateObject var roomVM = RoomViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            VStack (alignment: .leading) {
                Text(customer.name)
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.leading)
                .lineLimit(1)
                
                Text(customer.address)
                    .padding(.bottom)
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack (alignment: .leading) {
                Text("Room Name:")
                    .bold()
                
                TextField("name", text: $room.title)
                    .textFieldStyle(.roundedBorder)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.5), lineWidth: 2)
                    }
                
                
                HStack{
                    Text("Product Type:")
                        .bold()
                        .font(.title2)
                    
                    Spacer()
                    
                    Picker("", selection: $room.productType) {
                        ForEach(ProductType.allCases, id: \.self) { ProductType in
                            Text(ProductType.rawValue.capitalized)
                                .tag(ProductType.rawValue)
                        }
                    }
                }
                
                Text("Description:")
                    .bold()
                
                TextField("review", text: $room.body, axis: .vertical)
                    .padding(.horizontal, 6)
                    .frame(maxHeight: .infinity, alignment: .topLeading)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.5), lineWidth: 2)
                    }
                
                
            }
            .padding(.horizontal)
            .font(.title2)
            
            Spacer()
            
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    Task {
                        let success = await roomVM.saveRoom(customer: customer, room: room)
                        if success {
                            dismiss()
                        } else {
                            print("😡 ERROR: saving data in ReviewView")
                        }
                    }
                }
            }
        }
    }
}

struct RoomView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RoomView(customer: Customer(name: "John", address: "49 Boyleston St., Chestnut Hill, MA 02467"), room: Room())
        }
    }
}

