//
//  Route.swift
//  Study
//
//  Created by habil . on 30/12/23.
//

import Foundation
import SwiftUI

@MainActor class RouteManager: ObservableObject {
    @Published var path = NavigationPath()
}
