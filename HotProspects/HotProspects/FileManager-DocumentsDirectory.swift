//
//  FileManager-DocumentsDirectory.swift
//  HotProspects
//
//  Created by habil . on 26/12/23.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
