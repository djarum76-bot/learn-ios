//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by habil . on 22/12/23.
//

import SwiftUI

struct CheckoutView: View {
    var order: Order
    
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        ScrollView{
            VStack{
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3){ image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)
                
                Text("Your total cost is \(order.cost, format: .currency(code: "USD"))")
                    .font(.title)
                
                Button("Place Order"){
                    Task{
                        await placeOrder()
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .alert(alertTitle, isPresented: $showingAlert){} message: {
            Text(alertMessage)
        }
    }
    
    func placeOrder()async{
        guard let encoded = try? JSONEncoder().encode(order) else {
            alertTitle = "Error"
            alertMessage = "Failed to encode order"
            showingAlert = true
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            alertTitle = "Thank You!"
            alertMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
            showingAlert = true
        } catch {
            alertTitle = "Error"
            alertMessage = "Check out failed: \(error.localizedDescription)"
            showingAlert = true
        }
    }
}

#Preview {
    CheckoutView(order: Order())
}
