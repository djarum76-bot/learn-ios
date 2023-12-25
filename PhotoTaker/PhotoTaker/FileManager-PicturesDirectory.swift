//
//  FileManager-DocumentsDirectory.swift
//  PhotoTaker
//
//  Created by habil . on 25/12/23.
//

import Foundation

extension FileManager{
    static var picturesDirectory: URL {
        let paths = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask)
        return paths[0]
    }
}
