//
//  ResortsView.swift
//  SnowSeeker
//
//  Created by habil . on 28/12/23.
//

import SwiftUI

struct ResortsView: View {
    enum SortingType { case none, name, country }
    
    @StateObject private var favorites = Favorites()
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    
    @State private var searhText = ""
    var filteredSortedResort: [Resort]{
        if searhText.isEmpty {
            switch sortingType {
            case .none:
                return resorts
            case .name:
                return resorts.sorted { $0.name < $1.name }
            case .country:
                return resorts.sorted { $0.country < $1.country }
            }
        } else {
            switch sortingType {
            case .none:
                return resorts.filter { $0.name.localizedCaseInsensitiveContains(searhText) }
            case .name:
                return resorts.filter { $0.name.localizedCaseInsensitiveContains(searhText) }.sorted { $0.name < $1.name }
            case .country:
                return resorts.filter { $0.name.localizedCaseInsensitiveContains(searhText) }.sorted { $0.country < $1.country }
            }
        }
    }
    
    @State private var isShowingConfirmationDialog = false
    @State private var sortingType = SortingType.none
    
    var body: some View {
        List(filteredSortedResort) { resort in
            NavigationLink {
                ResortView(resort: resort)
                    .environmentObject(favorites)
            } label: {
                HStack {
                    Image(resort.country)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 25)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.black, lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                        )
                    
                    VStack(alignment: .leading) {
                        Text(resort.name)
                            .font(.headline)
                        
                        Text("\(resort.runs) runs")
                            .foregroundStyle(.secondary)
                    }
                    
                    if favorites.contains(resort) {
                        Spacer()
                        Image(systemName: "heart.fill")
                            .accessibilityLabel("This is a favorite resort")
                            .foregroundStyle(.red)
                    }
                }
            }
        }
        .navigationTitle("Resorts")
        .searchable(text: $searhText, prompt: "Look for a resort")
        .toolbar {
            Button{
                isShowingConfirmationDialog.toggle()
            } label: {
                Image(systemName: "list.bullet.indent")
            }
        }
        .confirmationDialog("Sorting the resort by", isPresented: $isShowingConfirmationDialog) {
            Button("None") { sortingType = SortingType.none }
            Button("Name") { sortingType = SortingType.name }
            Button("Country") { sortingType = SortingType.country }
        } message: {
            Text("Sorting the resort by")
        }

    }
}

#Preview {
    NavigationStack{
        ResortsView()
    }
}
