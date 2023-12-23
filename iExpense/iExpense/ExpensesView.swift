//
//  ExpensesView.swift
//  iExpense
//
//  Created by habil . on 23/12/23.
//

import SwiftData
import SwiftUI

struct ExpensesView: View {
    @Environment(\.modelContext) var modelContext
    @Query var expenses: [Expense]
    
    var body: some View {
        List{
            ForEach(expenses){ expense in
                HStack{
                    VStack(alignment: .leading){
                        Text(expense.name)
                            .font(.headline)
                        
                        Text(expense.type)
                    }
                    
                    Spacer()
                    
                    Text(expense.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }
            }
            .onDelete(perform: removeItem)
        }
    }
    
    func removeItem(at offsets: IndexSet){
        for offset in offsets {
            let expense = expenses[offset]
            
            modelContext.delete(expense)
        }
    }
    
    init(sortOrder: [SortDescriptor<Expense>], type: String){
        _expenses = Query(
            filter: #Predicate<Expense>{ expense in
                expense.type == type
            },
            sort: sortOrder
        )
    }
}

//#Preview {
//    ExpensesView()
//}
