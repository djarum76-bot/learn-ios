//
//  DetailView-ViewModel.swift
//  PhotoTaker
//
//  Created by habil . on 25/12/23.
//

import _MapKit_SwiftUI
import Foundation
import MapKit

extension DetailView{
    @MainActor class ViewModel: ObservableObject{
        var photo: Photo
        
        var position: MapCameraPosition
        
        init(photo: Photo) {
            self.photo = photo
            self.position = MapCameraPosition.region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: photo.latitude, longitude: photo.longitude),
                    span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
                )
            )
        }
    }
}
