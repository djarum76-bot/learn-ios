//
//  AddBookView.swift
//  Bookworm
//
//  Created by habil . on 23/12/23.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State private var title = ""
    @State private var author = ""
    @State private var genre = "Fantasy"
    @State private var review = ""
    @State private var rating = 0
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    var body: some View {
        NavigationStack{
            Form{
                Section{
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)
                    
                    Picker("Genre", selection: $genre){
                        ForEach(genres, id: \.self){
                            Text($0)
                        }
                    }
                }
                
                Section("Write a review"){
                    TextEditor(text: $review)
                    RatingView(rating: $rating)
                }
                
                Section{
                    Button("Save"){
                        review = review.trimmingCharacters(in: .whitespacesAndNewlines)
                        let newReview = review.isEmpty ? "N/A" : review
                        
                        let newBook = Book(title: title, author: author, genre: genre, review: newReview, rating: rating)
                        
                        modelContext.insert(newBook)
                        
                        dismiss()
                    }
                    .disabled(hasValidBookData() == false)
                }
            }
            .navigationTitle("Add Book")
        }
    }
    
    func hasValidBookData() -> Bool{
        let validTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let validAuthor = author.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if validTitle.isEmpty || validAuthor.isEmpty || (rating == 0) {
            return false
        }
        
        return true
    }
}

#Preview {
    AddBookView()
}
