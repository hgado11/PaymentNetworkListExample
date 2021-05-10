//
//  OperationProtocol.swift
//  PaymentNetworkList
//
//  Created by Hassan Gadou on 09/05/2021.
//

import Foundation
protocol OperationProtocol {
    associatedtype T

    /// Request
    var request: RequestProtocol? { get set }

    /// Execute an operation into specified service

    /// - Parameters:
    ///   - service: service to use
    ///   - completionHandler: return result with Associated T
    func execute(in service: ServiceProtocol, completionHandler: @escaping ((Result<T?, Error>) -> Void))
}
