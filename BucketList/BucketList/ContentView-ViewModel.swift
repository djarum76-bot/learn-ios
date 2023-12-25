//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by habil . on 25/12/23.
//

import _MapKit_SwiftUI
import LocalAuthentication
import MapKit
import Foundation

extension ContentView{
    @MainActor class ViewModel: ObservableObject{
        @Published var position = MapCameraPosition.region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 50, longitude: 0),
                span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25)
            )
        )
        @Published private(set) var latitude: CLLocationDegrees?
        @Published private(set) var longitude: CLLocationDegrees?
        @Published private(set) var locations: [Location]
        @Published var selectedPlace: Location?
        @Published var isUnlocked = false
        @Published var showingAlert = false
        @Published var alertMessage = ""
        
        let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPlaces")
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
            } catch {
                print("Unable to save data.")
            }
        }
        
        func onMapCameraChange(context: _MapKit_SwiftUI.MapCameraUpdateContext){
            latitude = context.region.center.latitude
            longitude = context.region.center.longitude
        }
        
        func addLocation(){
            let newLatitude = latitude ?? position.region?.center.latitude ?? 0
            let newLongitude = longitude ?? position.region?.center.longitude ?? 0
            
            let newLocation = Location(id: UUID(), name: "New Location", description: "", latitude: newLatitude, longitude: newLongitude)
            
            locations.append(newLocation)
            
            save()
        }
        
        func update(location: Location){
            guard let selectedPlace = selectedPlace else { return }
            
            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
                save()
            }
        }
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock your places."
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    if success {
                        Task{ @MainActor in
                            self.isUnlocked = true
                        }
                    } else {
                        Task { @MainActor in
                            self.alertMessage = authenticationError?.localizedDescription ?? error?.localizedDescription ?? "There is an error"
                            self.showingAlert = true
                        }
                    }
                }
            } else {
                alertMessage = error?.localizedDescription ?? "No biometric found"
                showingAlert = true
            }
        }
    }
}
