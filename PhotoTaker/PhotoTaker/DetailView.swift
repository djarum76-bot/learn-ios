//
//  DetailView.swift
//  PhotoTaker
//
//  Created by habil . on 25/12/23.
//

import SwiftUI

struct DetailView: View {
    @ObservedObject private var viewModel: ViewModel
    
    init(photo: Photo){
        self.viewModel = ViewModel(photo: photo)
    }
    
    var body: some View {
        viewModel.photo.image.convertDatatoImage()
            .resizable()
            .scaledToFit()
    }
}

//#Preview {
//    DetailView()
//}
