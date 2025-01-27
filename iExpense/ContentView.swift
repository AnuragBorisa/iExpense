//
//  ContentView.swift
//  iExpense
//
//  Created by Anurag on 11/01/25.
//

import SwiftUI
import Observation
import SwiftData




struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var  expenses : [ExpenseItem]
    @State private var sortOrder = [SortDescriptor(\ExpenseItem.name),SortDescriptor(\ExpenseItem.amount)]
    
    @State var filterBasedOn = ["All","Personal","Business"];
    @State var filterValue = "All";
//    @State private var showingAddExpense = false
    
    
    var body: some View {
       
        NavigationStack{
            NavigationLink {
                AddView()
            } label: {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Expense")
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
           
            List{
                ShowExpenses(filterBased:filterValue,sortOrder: sortOrder)
            }
            .navigationTitle("iExpense")
            .toolbar{
                ToolbarItem{
                    Menu("Sort",systemImage:"arrow.up.arrow.down"){
                        Picker("Sort",selection:$sortOrder){
                            Text("Sort by Name")
                                .tag([
                                    SortDescriptor(\ExpenseItem.name),
                                    SortDescriptor(\ExpenseItem.amount)
                                ])
                            Text("Sort by Amount")
                                .tag([SortDescriptor(\ExpenseItem.amount),SortDescriptor(\ExpenseItem.name)])
                        }
                    }
                }
                
                ToolbarItem{
                    Menu("Show"){
                        Picker("Show",selection:$filterValue){
                            ForEach(filterBasedOn,id: \.self){ filter in
                                Text(filter)
                            }
                        }
                    }
                }
               
               
            }
//            .toolbar {
//                Button("Add Expense",systemImage: "plus"){
//                    showingAddExpense = true
//                }
//            }
            
        }
//        .sheet(isPresented: $showingAddExpense){
//            AddView(expenses:expenses)
//        }
    }
}

#Preview {
    ContentView()
}
