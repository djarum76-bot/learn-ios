//
//  ProspectsView.swift
//  HotProspects
//
//  Created by habil . on 26/12/23.
//

import CodeScanner
import SwiftUI
import UserNotifications

struct ProspectsView: View {
    enum FilterType { case none, contacted, uncontacted }
    enum SortingType { case none, name, recent }
    let filter: FilterType
    @EnvironmentObject private var prospects: Prospects
    @State private var isShowingScanner = false
    @State private var isShowingConfirmation = false
    @State private var sorting: SortingType = .none
    
    var title: String{
        switch filter {
        case .none:
            "Everyone"
        case .contacted:
            "Contacted people"
        case .uncontacted:
            "Uncontacted people"
        }
    }
    
    var filteredProspects: [Prospect] {
        switch filter {
        case .none:
            switch sorting {
            case .none:
                prospects.people
            case .name:
                prospects.people.sorted { $0.name < $1.name }
            case .recent:
                prospects.people.sorted { $0.createdAt > $1.createdAt }
            }
        case .contacted:
            switch sorting {
            case .none:
                prospects.people.filter { $0.isContacted }
            case .name:
                prospects.people.filter { $0.isContacted }.sorted { $0.name < $1.name }
            case .recent:
                prospects.people.filter { $0.isContacted }.sorted { $0.createdAt > $1.createdAt }
            }
        case .uncontacted:
            switch sorting {
            case .none:
                prospects.people.filter { !$0.isContacted }
            case .name:
                prospects.people.filter { !$0.isContacted }.sorted { $0.name < $1.name }
            case .recent:
                prospects.people.filter { !$0.isContacted }.sorted { $0.createdAt > $1.createdAt }
            }
        }
    }
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(filteredProspects) { prospect in
                    HStack{
                        if filter == .none && prospect.isContacted {
                            Image(systemName: "person.crop.circle")
                                .font(.title)
                        }
                        
                        VStack(alignment: .leading){
                            Text(prospect.name)
                                .font(.headline)
                            Text(prospect.emailAddress)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .swipeActions{
                        Button{
                            prospects.toggle(prospect)
                        } label: {
                            Label(
                                "Mark \(prospect.isContacted ? "Uncontacted" : "Contacted")",
                                systemImage: "person.crop.circle.\(prospect.isContacted ? "badge.xmark" : "fill.badge.checkmark")"
                            )
                        }
                        .tint(prospect.isContacted ? .blue : .green)
                        
                        if !prospect.isContacted {
                            Button{
                                addNotification(for: prospect)
                            } label: {
                                Label("Remind Me", systemImage: "bell")
                            }
                            .tint(.orange)
                        }
                    }
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingScanner = true
                    } label: {
                        Label("Scan", systemImage: "qrcode.viewfinder")
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        isShowingConfirmation = true
                    } label: {
                        Label("Sort", systemImage: "list.dash")
                    }
                }
            }
            .sheet(isPresented: $isShowingScanner){
                CodeScannerView(codeTypes: [.qr], simulatedData: "Asta\nasta@gmail.com", completion: handleScan)
            }
            .confirmationDialog(
                "Sort Contact",
                isPresented: $isShowingConfirmation
            ) {
                Button("Name") { sorting = .name }
                
                Button("Most Recent") { sorting = .recent }
                
                Button("None", role: .destructive) { sorting = .none }
            } message: {
                Text("Sort contact by :")
            }
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>){
        isShowingScanner = false
        
        switch result {
        case .success(let success):
            let details = success.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]
            
            prospects.add(person)
        case .failure(let failure):
            print("Error : \(failure.localizedDescription)")
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 9
//            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("Failed notification")
                    }
                }
            }
        }
    }
}

#Preview {
    ProspectsView(filter: .none)
        .environmentObject(Prospects())
}
