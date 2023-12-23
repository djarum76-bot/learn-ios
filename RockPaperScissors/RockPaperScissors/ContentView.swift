//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by habil . on 18/12/23.
//

import SwiftUI

enum HitResult { case win, lose, draw }
enum GameStatus { case initial, live, finished }

struct HealthBar: View {
    var isPlayer: Bool
    var health: Double
    
    var body: some View {
        HStack{
            Image(systemName: isPlayer ? "person.fill" : "laptopcomputer")
            
            GeometryReader{ geometry in
                ZStack(alignment: .leading){
                    Rectangle()
                        .frame(width: geometry.size.width, height: 20)
                        .foregroundColor(.gray)
                    
                    Rectangle()
                        .frame(width: CGFloat(health) * geometry.size.width, height: 20)
                        .foregroundColor(health > 0.5 ? .green : health > 0.2 ? .yellow : .red)
                }
            }
            .frame(width: 300, height: 20)
            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
            .clipShape(.rect(cornerRadius: 20))
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .padding(.vertical, 16)
        .background(.regularMaterial)
        .clipShape(.rect(cornerRadius: 10))
    }
}

struct MoveButton: View{
    var moves: [String]
    var move: Int
    var index: Int
    var onTap: () -> Void
    
    var body: some View{
        Button{
            onTap()
        } label: {
            Text(moves[index])
                .moveTextColor(active: move == index)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .padding(.vertical, 36)
                .moveButtonBackground(active: move == index)
                .clipShape(.rect(cornerRadius: 10))
        }
    }
}

extension View{
    @ViewBuilder
    func moveTextColor(active: Bool) -> some View{
        if !active {
            foregroundStyle(.blue)
        }else{
            foregroundStyle(.white)
        }
    }
    
    @ViewBuilder
    func moveButtonBackground(active: Bool) -> some View{
        if active {
            background(Color(.blue))
        }else{
            background(.regularMaterial)
        }
    }
}

struct ContentView: View {
    let moves = ["Scissors", "Paper", "Rock"]
    @State private var enemyMove = -1
    @State private var enemyHealth = 1.0
    @State private var playerMove = -1
    @State private var playerHealth = 1.0
    @State private var showAlert = false
    @State private var hitMessage = ""
    @State private var gameStatus: GameStatus = GameStatus.initial
    
    var body: some View {
        NavigationStack{
            ZStack{
                RadialGradient(stops: [
                    .init(color: .blue, location: 0.3),
                    .init(color: .purple, location: 0.3)
                ], center: .top, startRadius: 100, endRadius: 700).ignoresSafeArea()
                
                VStack{
                    HealthBar(isPlayer: false, health: enemyHealth)
                    
                    Spacer()
                    
                    Text("VS")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/.weight(.bold))
                        .padding()
                        .background(.regularMaterial)
                        .clipShape(.rect(cornerRadius: 10))
                    
                    Spacer()
                    
                    HStack{
                        ForEach(0..<3){ number in
                            MoveButton(moves: moves, move: playerMove, index: number){
                                onTap(number)
                            }
                        }
                    }
                    
                    HealthBar(isPlayer: true, health: playerHealth)
                }
                .padding()
            }
            .navigationTitle("Game")
            .navigationBarTitleDisplayMode(.inline)
        }
        .alert("", isPresented: $showAlert){
            Button(gameStatus == GameStatus.finished ? "Restart" : "Continue"){
                playerMove = -1
                showAlert = false
                
                if gameStatus == GameStatus.finished {
                    gameRestart()
                }
            }
        } message: {
            Text(hitMessage)
        }
    }
    
    private func onTap(_ number: Int){
        playerMove = number
        var randomEnemyMove = Int.random(in: 0..<3)
        enemyMove = randomEnemyMove
        
        var hitResult = hitResult(randomEnemyMove)
        switch hitResult{
        case HitResult.win:
            enemyHealth -= 0.1
        case HitResult.lose:
            playerHealth -= 0.1
        default:
            enemyHealth = enemyHealth
            playerHealth = playerHealth
        }
        
        gameStatus = gameResult()
        
        if gameStatus == GameStatus.finished {
            if enemyHealth <= 0.1 {
                hitMessage = "You Win"
            } else {
                hitMessage = "You Lose"
            }
        }else{
            switch hitResult{
            case HitResult.win:
                hitMessage = "Enemy Choose : \(moves[randomEnemyMove])\n You landed a hit"
            case HitResult.lose:
                hitMessage = "Enemy Choose : \(moves[randomEnemyMove])\n Awww, you get hit"
            default:
                hitMessage = "Enemy Choose : \(moves[randomEnemyMove])\n Good, you guard ur self"
            }
        }
        
        showAlert = true
    }
    
    private func hitResult(_ randomEnemyMove: Int) -> HitResult {
        if playerMove == randomEnemyMove {
            return HitResult.draw
        }
        
        switch playerMove{
        case 0:
            return randomEnemyMove == 1 ? HitResult.win : HitResult.lose
        case 1:
            return randomEnemyMove == 0 ? HitResult.lose : HitResult.win
        default:
            return randomEnemyMove == 0 ? HitResult.win : HitResult.lose
        }
    }
    
    private func gameResult() -> GameStatus {
        if enemyHealth <= 0.1 || playerHealth <= 0.1 {
            return GameStatus.finished
        }
        
        return GameStatus.live
    }
    
    private func gameRestart(){
        enemyMove = -1
        enemyHealth = 1.0
        playerHealth = 1.0
        gameStatus = GameStatus.initial

    }
}

#Preview {
    ContentView()
}
