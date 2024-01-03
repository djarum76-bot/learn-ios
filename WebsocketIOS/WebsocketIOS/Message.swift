//
//  Message.swift
//  WebsocketIOS
//
//  Created by habil . on 03/01/24.
//

import Foundation

struct Message: Hashable {
    var username: String
    var text: String
    var id: UUID
}
