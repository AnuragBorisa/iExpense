//
//  AddView.swift
//  iExpense
//
//  Created by Anurag on 12/01/25.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    var expenses: Expenses
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    
    let types = ["Business", "Personal"]
    
    
    var body: some View {
        NavigationStack{
            Form{
                TextField("Name", text: $name)
                Picker("Type",selection: $type){
                    ForEach(types,id:\.self){
                        Text($0)
                    }
                }
                TextField("Amount" ,value: $amount,format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .keyboardType(.decimalPad)
            }
            
            .navigationTitle("Add New expense")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    Button("Cancel"){
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Save"){
                        let item = ExpenseItem(name:name,type:type,amount:amount)
                        expenses.items.append(item)
                        dismiss()
                    }
                }
               
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    AddView(expenses: Expenses())
}
