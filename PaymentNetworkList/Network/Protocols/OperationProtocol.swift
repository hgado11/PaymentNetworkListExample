//
//  OperationProtocol.swift
//  PaymentNetworkList
//
//  Created by Hassan Gadou on 09/05/2021.
//

import Foundation
/// Operation Protocol
protocol OperationProtocol {
    associatedtype T

    /// Request
    var request: RequestProtocol? { get set }

    /// Execute an operation into specified service
    ///
    /// - Parameters:
    ///   - service: service to use
    ///   - retry: retry attempts
    /// - Returns: Promise
    func execute(in service: ServiceProtocol) 

}
