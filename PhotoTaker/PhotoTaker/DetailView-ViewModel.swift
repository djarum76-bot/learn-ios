//
//  DetailView-ViewModel.swift
//  PhotoTaker
//
//  Created by habil . on 25/12/23.
//

import Foundation

extension DetailView{
    @MainActor class ViewModel: ObservableObject{
        var photo: Photo
        
        init(photo: Photo) {
            self.photo = photo
        }
    }
}
