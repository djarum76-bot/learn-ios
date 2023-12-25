//
//  ImageExtension.swift
//  PhotoTaker
//
//  Created by habil . on 25/12/23.
//

import Foundation
import SwiftUI

extension Data{
    func convertDatatoImage() -> Image {
        let inputImage = UIImage(data: self)
        return Image(uiImage: inputImage!)
    }
}
