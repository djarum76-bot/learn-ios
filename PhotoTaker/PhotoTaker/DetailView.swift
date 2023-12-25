//
//  DetailView.swift
//  PhotoTaker
//
//  Created by habil . on 25/12/23.
//

import MapKit
import SwiftUI

struct DetailView: View {
    @ObservedObject private var viewModel: ViewModel
    
    init(photo: Photo){
        self.viewModel = ViewModel(photo: photo)
    }
    
    var body: some View {
        Form{
            Section{
                viewModel.photo.image.convertDatatoImage()
                    .resizable()
                    .scaledToFit()
                    .clipShape(.rect(cornerRadius: 10))
            }
            
            Map(initialPosition: viewModel.position){
                Marker(viewModel.photo.name, coordinate: viewModel.photo.coordinate)
            }
                .frame(width: 300, height: 300)
                .clipShape(.rect(cornerRadius: 10))
        }
    }
}

//#Preview {
//    DetailView()
//}
