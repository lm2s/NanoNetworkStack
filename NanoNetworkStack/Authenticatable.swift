//
//  Authenticatable.swift
//  NanoNetworkStack
//
//  Created by Luís Silva on 04/04/2018.
//  Copyright © 2018 Chipp'd. All rights reserved.
//

import Foundation

public protocol Authenticatable {
    func authenticate(request: inout URLRequest)
}
