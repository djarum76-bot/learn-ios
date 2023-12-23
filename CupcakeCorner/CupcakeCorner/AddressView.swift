//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by habil . on 22/12/23.
//

import SwiftUI

struct AddressView: View {
    @Bindable var order: Order
    
    var body: some View {
        Form{
            Section{
                TextField("Name", text: $order.userAddress.name)
                TextField("Street Address", text: $order.userAddress.streetAddress)
                TextField("City", text: $order.userAddress.city)
                TextField("Zip", text: $order.userAddress.zip)
            }
            
            Section{
                NavigationLink("Check out"){
                    CheckoutView(order: order)
                }
            }
            .disabled(order.hasValidAddress == false)
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AddressView(order: Order())
}
