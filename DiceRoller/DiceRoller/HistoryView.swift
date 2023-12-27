//
//  HistoryView.swift
//  DiceRoller
//
//  Created by habil . on 27/12/23.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject private var viewModel: ViewModel
    
    var body: some View {
        List{
            Section("History Dice"){
                ForEach(viewModel.historyResults, id: \.self) { history in
                    Text("\(history.map { String($0) }.joined(separator: ", "))")
                }
            }
        }
    }
}

#Preview {
    HistoryView()
        .environmentObject(ViewModel())
}
