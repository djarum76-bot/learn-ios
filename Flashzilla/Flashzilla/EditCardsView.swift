//
//  EditCardsView.swift
//  Flashzilla
//
//  Created by habil . on 27/12/23.
//

import SwiftUI

struct EditCardsView: View {
    @EnvironmentObject private var viewModel: ViewModel
    @Environment(\.dismiss) var dismiss
    @State private var newPrompt = ""
    @State private var newAnswer = ""
    @State private var isCorrect = false
    
    var body: some View {
        NavigationStack{
            List{
                Section("Add new card") {
                    TextField("Prompt", text: $newPrompt)
                    TextField("Answer", text: $newAnswer)
                    Toggle("Is Correct?", isOn: $isCorrect)
                    Button("Add card", action: addCard)
                }
                
                Section {
                    ForEach(0..<viewModel.cards.count, id: \.self) { index in
                        VStack(alignment: .leading) {
                            Text(viewModel.cards[index].prompt)
                                .font(.headline)
                            
                            Text(viewModel.cards[index].answer)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete(perform: removeCards)
                }
            }
            .navigationTitle("Edit Cards")
            .toolbar{
                Button("Done", action: done)
            }
            .listStyle(.grouped)
            .onAppear(perform: viewModel.loadData)
        }
    }
    
    func addCard(){
        let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
        
        guard trimmedPrompt.isEmpty == false && trimmedAnswer.isEmpty == false else { return }
        
        let card = Card(id: UUID(), prompt: trimmedPrompt, answer: trimmedAnswer, isCorrect: isCorrect)
        viewModel.cards.insert(card, at: 0)
        viewModel.saveData()
        
        newPrompt = ""
        newAnswer = ""
        isCorrect = false
    }
    
    func removeCards(at offset: IndexSet){
        viewModel.cards.remove(atOffsets: offset)
        viewModel.saveData()
    }
    
    func done(){
        dismiss()
    }
}

#Preview {
    EditCardsView()
}
