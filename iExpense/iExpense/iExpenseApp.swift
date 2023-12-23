//
//  iExpenseApp.swift
//  iExpense
//
//  Created by habil . on 19/12/23.
//

import SwiftData
import SwiftUI

@main
struct iExpenseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Expense.self)
    }
}
