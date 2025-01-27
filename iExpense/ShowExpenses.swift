//
//  ShowExpenses.swift
//  iExpense
//
//  Created by Anurag on 27/01/25.
//

import SwiftUI
import SwiftData

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

struct BackgroundModifier : ViewModifier{
    var filterBased : String
    var itemType : String
    func body(content:Content)->some View {
        if(filterBased == "Personal" || itemType == "Personal" ){
            content
                .background(Color(red: 0.2, green: 0.192, blue: 0.02))
        }
        else if(filterBased == "Business" || itemType == "Business"){
            content
                 .background(Color(red: 0.2, green: 0.192, blue: 0.4))
        }
    }
}

extension View {
    func backgroundModifier(filterBased: String, itemType: String) -> some View {
        modifier(BackgroundModifier(filterBased: filterBased, itemType: itemType))
    }
}

extension View{
    func amountModifier(amount:Double) -> some View{
        modifier(AmountModifer(amount:amount))
    }
}

struct ShowExpenses: View {
    @Environment(\.modelContext) var modelContext
    @Query var  expenses : [ExpenseItem]
    var filterBased : String
    func deleteExpense(at offsets:IndexSet){
        for offset in offsets {
            let item = expenses[offset]
            
            modelContext.delete(item);
        }
    }
    
    init(filterBased:String,sortOrder:[SortDescriptor<ExpenseItem>]){
        self.filterBased = filterBased
        _expenses = Query(filter:#Predicate<ExpenseItem>{expense in
            expense.type == filterBased || filterBased == "All"
        },sort:sortOrder)
    }
    
    var body: some View {
        Section(header: Text("\(filterBased) Expenses")
            .font(.headline)
            .foregroundStyle(.black)
            .fontWeight(.semibold)
        ){
            ForEach(expenses){ item in
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
                .padding(10)
                .backgroundModifier(filterBased: filterBased, itemType: item.type)
                
            }
            .onDelete(perform:deleteExpense)
            
            
        }

    }
}

#Preview {
    
    do{
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for:ExpenseItem.self,configurations: config)
        
        let mockExpenses = [
                  ExpenseItem(name: "Dinner", type: "Personal", amount: 50.0),
                  ExpenseItem(name: "Taxi", type: "Business", amount: 30.0),
                  ExpenseItem(name: "Groceries", type: "Personal", amount: 100.0)
              ]
        
        for expense in mockExpenses{
            container.mainContext.insert(expense);
        }
        return  ShowExpenses(filterBased:"All",sortOrder:[SortDescriptor(\ExpenseItem.name)])
            .modelContainer(container)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
