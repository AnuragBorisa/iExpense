//
//  iExpenseApp.swift
//  iExpense
//
//  Created by Anurag on 11/01/25.
//

import SwiftUI
import SwiftData
@main
struct iExpenseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for:ExpenseItem.self)
    }
}
