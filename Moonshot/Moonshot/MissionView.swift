//
//  MissionView.swift
//  Moonshot
//
//  Created by habil . on 20/12/23.
//

import SwiftUI

struct CustomDivider: View{
    var body: some View{
        Rectangle()
            .frame(height: 2)
            .foregroundStyle(.lightBackground)
            .padding(.vertical)
    }
}

struct CrewMemberList: View{
    struct CrewMember{
        let role: String
        let astronaut: Astronaut
    }
    
    let mission: Mission
    let crew: [CrewMember]
    
    var body: some View{
        ScrollView(.horizontal, showsIndicators: false){
            HStack{
                ForEach(crew, id: \.role){ crewMember in
                    NavigationLink{
                        AstronautView(astronaut: crewMember.astronaut)
                    } label: {
                        HStack{
                            Image(crewMember.astronaut.id)
                                .resizable()
                                .frame(width: 104, height: 72)
                                .clipShape(.capsule)
                                .overlay(Capsule().stroke(.white, lineWidth: 1))
                            
                            VStack(alignment: .leading){
                                Text(crewMember.astronaut.name)
                                    .foregroundStyle(.white)
                                    .font(.headline)
                                
                                Text(crewMember.role)
                                    .foregroundStyle(.white.opacity(0.75))
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
    
    init(mission: Mission, astronauts: [String: Astronaut]){
        self.mission = mission
        self.crew = mission.crew.map{ member in
            if let astronaut = astronauts[member.name] {
                return CrewMember(role: member.role, astronaut: astronaut)
            } else {
                fatalError("Missing \(member.name)")
            }
        }
    }
}

struct MissionView: View {
    let mission: Mission
    let astronauts: [String: Astronaut]
    
    var body: some View {
        ScrollView{
            VStack{
                VStack{
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .containerRelativeFrame(.horizontal){ width, axis in
                            width * 0.6
                        }
                    
                    Text(mission.formattedLaunchDate)
                        .font(.title.bold())
                        .padding(.vertical, 2)
                        .foregroundStyle(.white.opacity(0.75))
                }
                
                VStack(alignment: .leading){
                    CustomDivider()
                    
                    Text("Mission Highlights")
                        .font(.title.bold())
                        .padding(.bottom, 5)
                    
                    Text(mission.description)
                    
                    CustomDivider()
                    
                    Text("Crew")
                        .font(.title.bold())
                        .padding(.bottom, 5)
                }
                .padding(.horizontal)
                
                CrewMemberList(mission: mission, astronauts: astronauts)
            }
            .padding(.bottom)
        }
        .navigationTitle(mission.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .background(.darkBackground)
    }
}

#Preview {
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    
    return MissionView(mission: missions[0], astronauts: astronauts)
        .preferredColorScheme(.dark)
}
