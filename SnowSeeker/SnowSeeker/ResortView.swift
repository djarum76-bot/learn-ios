//
//  ResortView.swift
//  SnowSeeker
//
//  Created by habil . on 28/12/23.
//

import SwiftUI

struct ResortView: View {
    @EnvironmentObject private var favorites: Favorites
    @Environment(\.horizontalSizeClass) var sizeClass
    @Environment(\.dynamicTypeSize) var typeSize
    let resort: Resort
    
    @State private var selectedFacility: Facility?
    @State private var showingFacility = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .bottomTrailing) {
                    Image(decorative: resort.id)
                        .resizable()
                        .scaledToFit()
                    
                    Text(resort.imageCredit)
                        .font(.headline)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 10)
                        .background(.ultraThinMaterial)
                        .clipShape(.capsule)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 10)
                }
                
                HStack{
                    if sizeClass == .compact && typeSize > .large {
                        VStack(spacing: 10){ ResortDetailsView(resort: resort) }
                        VStack(spacing: 10){ SkiDetailsView(resort: resort) }
                    } else {
                        ResortDetailsView(resort: resort)
                        SkiDetailsView(resort: resort)
                    }
                }
                .padding(.vertical)
                .background(.primary.opacity(0.1))
                .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                
                Group {
                    Text(resort.description)
                        .padding(.vertical)
                    
                    Text("Facilities")
                        .font(.headline)
                    
                    HStack{
                        ForEach(resort.facilityTypes) { facility in
                            Button {
                                selectedFacility = facility
                                showingFacility = true
                            } label: {
                                facility.icon
                                    .font(.title)
                            }
                        }
                    }
                    
                    Button(favorites.contains(resort) ? "Remove from Favorites" : "Add to Favorites",
                           role: favorites.contains(resort) ? .destructive : .cancel
                    ) {
                        if favorites.contains(resort) {
                            favorites.remove(resort)
                        } else {
                            favorites.add(resort)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("\(resort.name), \(resort.country)")
        .navigationBarTitleDisplayMode(.inline)
        .alert(selectedFacility?.name ?? "More information", isPresented: $showingFacility, presenting: selectedFacility) { _ in
        } message : { facility in
            Text(facility.description)
        }
    }
}

#Preview {
    ResortView(resort: Resort.example)
        .environmentObject(Favorites())
}
