//
//  AddBookView.swift
//  Bookworm
//
//  Created by Consultant on 8/11/20.
//  Copyright © 2020 Osulor Inc. All rights reserved.
//

import SwiftUI

struct AddBookView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode

    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = ""
    @State private var review = ""
    @State private var showingAlert = false
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]

    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)

                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }

                Section {
                    RatingView(rating: $rating)
                    TextField("Write a review", text: $review)
                }
                
                Section {
                    Button("Save") {
                        
                        if self.checkGenreSelection(){
                            let newBook = Book(context: self.moc)
                            newBook.title = self.title
                            newBook.author = self.author
                            newBook.rating = Int16(self.rating)
                            newBook.genre = self.genre
                            newBook.review = self.review
                            newBook.date = Date()
                            
                            try? self.moc.save()
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        
                    }
                }
            }
            .alert(isPresented: $showingAlert){
                Alert(title: Text("Empty field"), message: Text("The Genre field cannot be empty. Please choose a genre."), dismissButton: .cancel())
            }
            .navigationBarTitle("Add Book")
        }

    }
    
    func checkGenreSelection() -> Bool{
        if genre.isEmpty {
            showingAlert = true
            return false
        } else {
            showingAlert = false
            return true
        }
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
