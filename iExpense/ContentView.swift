//
//  ContentView.swift
//  iExpense
//
//  Created by Anurag on 11/01/25.
//

import SwiftUI
import Observation


struct AmountModifer : ViewModifier{
    var amount : Double;
    func body(content:Content) -> some View{
        if(amount < 10) {
            content
                .foregroundStyle(.black)
            .background(.green)
        }
        else if(amount < 100){
            content
                .foregroundStyle(.black)
                .background(.yellow)
        }
        else{
            content
                .foregroundStyle(.black)
                .background(.red)
        }
        
    }
}

extension View{
    func amountModifier(amount:Double) -> some View{
        modifier(AmountModifer(amount:amount))
    }
}


struct ContentView: View {
    @State private var expenses = Expenses()
    
    var personalExpenses:[ExpenseItem] {
        expenses.items.filter{$0.type == "Personal"}
    }
    
    var businessExpenses:[ExpenseItem] {
        expenses.items.filter{$0.type == "Business"}
    }
    
    func removeItems(for type:String,at offsets: IndexSet){
        let itemsToRemove:[ExpenseItem]
        if type == "Personal"{
            itemsToRemove = personalExpenses
        }
        else{
            itemsToRemove = businessExpenses
        }
        
        for offset in offsets {
                   if let index = expenses.items.firstIndex(where: { $0.id == itemsToRemove[offset].id }) {
                       expenses.items.remove(at: index)
                   }
               }
    }
    @State private var showingAddExpense = false
    
    
    var body: some View {
        NavigationStack{
        
            List{
                Section(header: Text("Personal Expenses")
                    .font(.headline)
                    .foregroundStyle(.black)
                    .fontWeight(.semibold)
                ){
                    ForEach(personalExpenses){ item in
                        HStack{
                            VStack(alignment:.leading){
                                Text(item.name)
                                    .font(.headline)
                                    .foregroundStyle(.yellow)
                                Text(item.type)
                                    .foregroundStyle(.orange)
                            }
                            Spacer()
                            Text(item.amount,format:.currency(code:Locale.current.currency?.identifier ?? "USD"))
                                .frame(width: 100, height: 50)
                                .amountModifier(amount:item.amount)
                                .background(Color.black)
                                .padding(20)
                            
                        }
                    }
                    .onDelete { offsets in
                                           removeItems(for: "Personal", at: offsets)
                                       }
                    .padding(10)
                    .background(Color(red: 0.2, green: 0.192, blue: 0.02))
                }
                
                Section(header:Text("Business Expenses")
                    .font(.headline)
                    .foregroundStyle(.black)
                    .fontWeight(.semibold)
                ){
                    ForEach(businessExpenses){ item in
                        HStack{
                            VStack(alignment:.leading){
                                Text(item.name)
                                    .font(.headline)
                                    .foregroundStyle(.yellow)
                                Text(item.type)
                                    .foregroundStyle(.orange)
                            }
                            Spacer()
                            Text(item.amount,format:.currency(code:Locale.current.currency?.identifier ?? "USD"))
                                .frame(width: 100, height: 50)
                                .amountModifier(amount:item.amount)
                                .background(Color.black)
                                .padding(20)
                                
                        }
                    }
                    .onDelete { offsets in
                                           removeItems(for: "Business", at: offsets)
                                       }
                    .padding(10)
                    .background(Color(red: 0.5, green: 0.192, blue: 0.4))

                }
                
                
                
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button("Add Expense",systemImage: "plus"){
                    showingAddExpense = true
                }
            }
            
        }
        .sheet(isPresented: $showingAddExpense){
            AddView(expenses:expenses)
        }
    }
}

#Preview {
    ContentView()
}
