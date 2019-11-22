//
//  CheckoutView.swift
//  Idine
//
//  Created by luu van on 11/22/19.
//  Copyright © 2019 luu van. All rights reserved.
//

import SwiftUI

struct CheckoutView: View {
    @EnvironmentObject var order: Order
    
    static let paymentTypes = ["Cash", "Credit", "iDine Points"]
    static let tipAmounts = [10, 15, 20, 25, 0]
    
    @State private var paymentType = 0
    @State private var addLoyaltyDetails = false
    @State private var loyaltyNumber = ""
    @State private var tipAmount = 1
    @State private var showingPaymentAlert = false
    
    var totalPrice: Double {
        let total = Double(order.total)
        let tipValue = total / 100 * Double(Self.tipAmounts[tipAmount])
        return total + tipValue
    }
    
    var body: some View {
        Form {
            Section {
                Picker("How you want to pay", selection: $paymentType) {
                    ForEach(Self.paymentTypes, id: \.self) {
                        Text($0)
                    }
                }
                
                Toggle(isOn: $addLoyaltyDetails.animation()) {
                    Text("add iDine loyalty card")
                }
                
                if(addLoyaltyDetails) {
                    TextField("add your loyalty number", text: $loyaltyNumber)
                }
            }
            
            Section(header: Text("add a tip?")) {
                Picker("Percentage", selection: $tipAmount) {
                    ForEach(0..<Self.tipAmounts.count) {
                        Text("\(Self.tipAmounts[$0])%")
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
            
            Section(header:
                Text("Total: $\(totalPrice, specifier: "%.2f")")
                .font(.largeTitle)
            ) {
                Button("Confirm order") {
                    self.showingPaymentAlert.toggle()
                }
            }
        }.alert(isPresented: $showingPaymentAlert) {
            Alert(title: Text("Order confirmed"), message: Text("Your order total is: $\(totalPrice, specifier: "%.2f")"), dismissButton: .default(Text("OK")))
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static let order = Order()
    static var previews: some View {
        CheckoutView().environmentObject(order)
    }
}
