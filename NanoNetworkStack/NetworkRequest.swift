//
//  NetworkRequest.swift
//  NanoNetworkStack
//
//  Created by Luís Silva on 02/04/2018.
//  Copyright © 2018 Chipp'd. All rights reserved.
//

import Foundation
import Result

public enum HTTPMethod {
    case get, post, put, delete
}

public protocol NetworkRequestProtocol {
    var method: HTTPMethod { get }
    var endpoint: String { get }
    var authenticate: Bool { get }
    var cachePolicy: URLRequest.CachePolicy { get }
    var timeoutInterval: TimeInterval { get }
}

public protocol NetworkRequestJSONProtocol {
    var parameters: [String: Any] { get }
}

public protocol NetworkRequestFormURLEncodedProtocol {
    var parameters: [String: Any] { get }
}

open class NetworkRequest: Operation, NetworkRequestProtocol {
    
    // MARK: - Instance Properties

    private var _executing = false {
        willSet {
            willChangeValue(forKey: "isExecuting")
        }
        didSet {
            didChangeValue(forKey: "isExecuting")
        }
    }
    override open var isExecuting: Bool { return _executing }
    
    private var _finished = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }
        
        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }
    override open var isFinished: Bool { return _finished }
    
    weak var networkService: NetworkService?
    var task: URLSessionDataTask?
    
    // MARK: NetworkRequestProtocol
    
    open var method: HTTPMethod { fatalError("method must be implemented in subclass") }
    open var endpoint: String { fatalError("endpoint must be implemented in subclass") }
    open var authenticate: Bool { return false }
    open var cachePolicy: URLRequest.CachePolicy { return .useProtocolCachePolicy }
    open var timeoutInterval: TimeInterval { return 30 }
    
    // MARK: - Instance Methods
    
    override public init() {
        super.init()
    }
    
    override open func main() {
        guard !isCancelled else {
            finish(true)
            return
        }
        executing(true)
        
        networkService?.performRequest(request: self)
    }
    
    func executing(_ executing: Bool) {
        _executing = executing
    }
    
    func finish(_ finished: Bool) {
        _finished = finished
    }
    
    func finish() {
        executing(false)
        finish(true)
    }
    
    // MARK: -
    
    open func handleSuccess(_ data: Data?) {}
    open func handleFailure(_ error: NetworkError) {}
    
}
