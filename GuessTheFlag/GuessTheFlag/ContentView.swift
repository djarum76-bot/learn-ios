//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by habil . on 17/12/23.
//

import SwiftUI

struct TitleStyle: ViewModifier{
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.bold())
            .foregroundStyle(.red)
    }
}

extension View{
    func titleStyle() -> some View{
        modifier(TitleStyle())
    }
}

struct FlagImage: View {
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]

    var number: Int
    var countries: [String]
    
    var body: some View {
        Image(countries[number])
            .clipShape(.capsule)
            .shadow(radius: 5)
            .accessibilityLabel(labels[countries[number], default: "Unknown flag"])
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    @State private var scoreTotal = 0
    @State private var question = 0
    
    @State private var animationAmount = [0.0, 0.0, 0.0]
    @State private var selected: Int? = nil
    
    var body: some View {
        ZStack{
            RadialGradient(
                stops: [
                    .init(color: .blue, location: 0.3),
                    .init(color: .red, location: 0.3),
                ],
                center: .top,
                startRadius: 200,
                endRadius: 700
            )
                .ignoresSafeArea()
            
            VStack{
                Spacer()
                
                Text("Guess The Flag")
                    .titleStyle()
                
                VStack(spacing: 30){
                    VStack{
                        Text("Tap the correct flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                            .multilineTextAlignment(.center)
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3){ number in
                        Button{
                            flagTapped(number)
                        } label: {
                            FlagImage(number: number, countries: countries)
                                .rotation3DEffect(
                                    .degrees(animationAmount[number]),
                                    axis: (x: 0.0, y: 1.0, z: 0.0)
                                )
                                .opacity(selected == nil ? 1 : selected == number ? 1 : 0.25)
                                .animation(.easeInOut(duration: 0.2), value: selected)
                        }
                    }
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score : \(scoreTotal)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore){
            Button(question == 10 ? "Restart" : "Continue", action: question == 10 ? restartGame : askQuestion)
        } message: {
            Text(scoreMessage)
        }
    }
    
    func flagTapped(_ number: Int){
        withAnimation{
            animationAmount[number] += 360
        }
        
        question += 1
        
        if number == correctAnswer{
            scoreTotal += 1
        }else{
            selected = number
            
            scoreTitle = "Wrong"
            scoreMessage = "Wrong! That’s the flag of \(countries[number])"
        }
        
        showingScore = number != correctAnswer
        
        if question == 10{
            selected = number
            
            scoreTitle = "Game Over"
            scoreMessage = "Your Score is \(scoreTotal)"
            showingScore = true
        }else if !showingScore{
            askQuestion()
        }
    }
    
    func askQuestion(){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        selected = nil
    }
    
    func restartGame(){
        askQuestion()
        
        showingScore = false
        scoreTitle = ""
        scoreMessage = ""
        scoreTotal = 0
        question = 0
        
        selected = nil
    }
}

#Preview {
    ContentView()
}
