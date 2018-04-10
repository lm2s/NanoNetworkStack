//
//  NetworkError.swift
//  NanoNetworkStack
//
//  Created by Luís Silva on 03/04/2018.
//  Copyright © 2018 Chipp'd. All rights reserved.
//

import Foundation

public enum NetworkError: Error {
    case unknown, invalidResponse
    case failedRequest(data: Data?, statusCode: Int)
}
