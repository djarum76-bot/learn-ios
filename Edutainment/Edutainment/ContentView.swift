//
//  ContentView.swift
//  Edutainment
//
//  Created by habil . on 19/12/23.
//

import SwiftUI

enum GameStatus { case initial, lived, finished }

struct Question{
    let multiplication: Int
    let number: Int
    let answer: Int
}

struct ContentView: View {
    @State private var questionAmount = 2
    @State private var gameStatus = GameStatus.initial
    @State private var questionNumber = 1
    @State private var score = 0
    
    let questions = [
        Question(multiplication: 1, number: 2, answer: 2),
        Question(multiplication: 10, number: 4, answer: 40),
        Question(multiplication: 2, number: 6, answer: 12),
        Question(multiplication: 5, number: 9, answer: 45),
        Question(multiplication: 7, number: 3, answer: 21),
    ].shuffled()
    
    @State private var answer = 0
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack{
            ZStack{
                LinearGradient(colors: [.yellow, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                if gameStatus == GameStatus.initial {
                    VStack{
                        Text("How many question ?")
                            .font(.title.weight(.bold))
                        
                        Stepper("\(questionAmount) questions", value: $questionAmount, in: 2...5)
                        
                        Button("Continue", action: startGame)
                            .buttonStyle(.borderedProminent)
                    }
                    .padding()
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .background(.ultraThickMaterial)
                } else if gameStatus == GameStatus.lived {
                    VStack{
                        VStack{
                            Text("\(questions[questionNumber - 1].multiplication) * \(questions[questionNumber - 1].number) is ...")
                                .font(.title.weight(.bold))
                            
                            TextField("Answer Here", value: $answer, format: .number)
                            
                            Button("Check answer", action: checkAnswer)
                                .buttonStyle(.borderedProminent)
                        }
                        .padding()
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .background(.ultraThickMaterial)
                        
                        Text("Score : \(score)")
                            .padding()
                            .background(.ultraThickMaterial)
                            .clipShape(.rect(cornerRadius: 10))
                    }
                }
            }
            .navigationTitle("Edutainment")
            .navigationBarTitleDisplayMode(.inline)
            .alert(alertTitle, isPresented: $showingAlert){
                Button(gameStatus == GameStatus.finished ? "Restart" : "Ok"){
                    if gameStatus == GameStatus.finished {
                        restartGame()
                    }
                }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    func startGame(){
        gameStatus = GameStatus.lived
    }
    
    func checkAnswer(){
        let realAnswer = questions[questionNumber - 1].answer
        
        if answer == realAnswer {
            score += 1
            
            if questionNumber < questionAmount {
                questionNumber += 1
            } else {
                gameStatus = GameStatus.finished
                
                alertTitle = "Game Over"
                alertMessage = "Your score is \(score)"
                showingAlert = true
            }
        } else {
            alertTitle = "Wrong"
            alertMessage = "You stupid"
            showingAlert = true
        }
        
        answer = 0
    }
    
    func restartGame(){
        questionAmount = 2
        gameStatus = GameStatus.initial
        questionNumber = 1
        score = 0
        answer = 0
    }
}

#Preview {
    ContentView()
}
