//
//  Mappable.swift
//  NanoNetworkStack
//
//  Created by Luís Silva on 04/04/2018.
//  Copyright © 2018 Chipp'd. All rights reserved.
//

import Foundation

public protocol Mappable: Decodable {
    init?(data: Data)
}

public extension Mappable {
    init?(data: Data) {
        do {
            self = try JSONDecoder().decode(Self.self, from: data)
        } catch(let e) { print(e); return nil }
    }
}
