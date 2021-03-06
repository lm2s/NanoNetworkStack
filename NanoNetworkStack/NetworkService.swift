//
//  NetworkService.swift
//  NanoNetworkStack
//
//  Created by Luís Silva on 03/04/2018.
//  Copyright © 2018 Chipp'd. All rights reserved.
//

import Foundation
import Result

open class NetworkService {
    private var successCodes: CountableRange<Int> = 200..<299
    private var failureCodes: CountableRange<Int> = 400..<499
    
    private let networkQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "NanoNetworkStack.APIClient.OperationQueue"
        return queue
    }()
    
    private var urlSession = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue())
    open var baseUrl: URL { fatalError("baseUrl must be implemented in subclass") }
    
    public init() {
        
    }
    
    public func execute(request: NetworkRequest) {
        request.networkService = self
        
        networkQueue.addOperation(request)
    }
    
    internal func performRequest(request: NetworkRequest) {
        let requestUrl = baseUrl.appendingPathComponent(request.endpoint)
        var urlRequest: URLRequest = URLRequest(url: requestUrl, cachePolicy: request.cachePolicy, timeoutInterval: request.timeoutInterval)
        
        if let jsonRequest = request as? NetworkRequestJSONProtocol {
            let json = try! JSONSerialization.data(withJSONObject: jsonRequest.parameters, options: [])
            urlRequest.httpBody = json
            
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        } else if let formUrlEncodedProtocol = request as? NetworkRequestFormURLEncodedProtocol {
            
        }
        
        if let auth = request.networkService as? Authenticatable, request.authenticate {
            auth.authenticate(request: &urlRequest)
        }
        
        request.task = urlSession.dataTask(with: urlRequest) { (data, response, error) in
            defer { request.finish(true) }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                request.handleFailure(.invalidResponse)
                return
            }

            if self.successCodes.contains(httpResponse.statusCode) {
                request.handleSuccess(data)
            } else {
                request.handleFailure(.failedRequest(data: data, statusCode: httpResponse.statusCode))
            }
            
        }
        request.task?.resume()
    }
}


