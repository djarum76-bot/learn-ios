//
//  ContentView.swift
//  Moonshot
//
//  Created by habil . on 20/12/23.
//

import SwiftUI

enum LayoutType { case List, Grid }

struct GridLayout: View{
    let astronauts: [String: Astronaut]
    let missions: [Mission]
    
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        LazyVGrid(columns: columns){
            ForEach(missions){ mission in
                NavigationLink(value: mission){
                    VStack{
                        Image(mission.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .padding()
                        
                        VStack{
                            Text(mission.displayName)
                                .font(.headline)
                                .foregroundStyle(.white)
                            
                            Text(mission.formattedLaunchDate)
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.75))
                        }
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(.lightBackground)
                    }
                    .clipShape(.rect(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.lightBackground)
                    )
                }
                .navigationDestination(for: Mission.self) { mission in
                    MissionView(mission: mission, astronauts: astronauts)
                }
            }
        }
        .padding([.horizontal, .bottom])
    }
}

struct ListLayout: View{
    let astronauts: [String: Astronaut]
    let missions: [Mission]
    
    var body: some View {
        LazyVStack{
            ForEach(missions){ mission in
                NavigationLink(value: mission){
                    VStack{
                        Image(mission.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .padding()
                        
                        VStack{
                            Text(mission.displayName)
                                .font(.headline)
                                .foregroundStyle(.white)
                            
                            Text(mission.formattedLaunchDate)
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.75))
                        }
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(.lightBackground)
                    }
                    .clipShape(.rect(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.lightBackground)
                    )
                }
                .navigationDestination(for: Mission.self) { mission in
                    MissionView(mission: mission, astronauts: astronauts)
                }
            }
        }
        .padding([.horizontal, .bottom])
    }
}

struct LayoutButton: View {
    @Binding var layoutType: LayoutType
    var type: LayoutType
    var label: String
    
    var body: some View {
        Button{
            layoutType = type
        } label: {
            HStack{
                if layoutType == type{
                    Image(systemName: "checkmark")
                }
                
                Text(label)
            }
        }
    }
}

struct ContentView: View {
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    
    @State private var layoutType = LayoutType.List
    
    var body: some View {
        NavigationStack{
            ScrollView{
                if layoutType == LayoutType.Grid {
                    GridLayout(astronauts: astronauts, missions: missions)
                } else {
                    ListLayout(astronauts: astronauts, missions: missions)
                }
            }
            .navigationTitle("Moonshot")
            .background(.darkBackground)
            .preferredColorScheme(.dark)
            .toolbar{
                Menu{
                    LayoutButton(layoutType: $layoutType, type: .Grid, label: "Grid Type")
                    LayoutButton(layoutType: $layoutType, type: .List, label: "List Type")
                } label: {
                    Image(systemName: "list.bullet")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
