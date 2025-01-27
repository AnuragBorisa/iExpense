//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Anurag on 12/01/25.
//
import Observation
import Foundation
import SwiftData
@Model
class ExpenseItem : Identifiable{
    var id = UUID()
    var name : String
    var type : String
    var amount : Double
    
    init(id: UUID = UUID(), name: String, type: String, amount: Double) {
        self.id = id
        self.name = name
        self.type = type
        self.amount = amount
    }
}


