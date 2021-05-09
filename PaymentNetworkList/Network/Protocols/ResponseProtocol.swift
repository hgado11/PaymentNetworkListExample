//
//  ResponseProtocol.swift
//  PaymentNetworkList
//
//  Created by Hassan Gadou on 08/05/2021.
//

import Foundation
public protocol ResponseProtocol {

    /// Type of response (success or failure)
    var type: Response.Result { get }

    /// Encapsulates the metrics for a session task.
    /// It contains the taskInterval and redirectCount, as well as metrics for each request / response
    /// transaction made during the execution of the task.
    var metrics: URLSessionTaskMetrics? { get }

    /// Request
    var request: RequestProtocol { get }

    /// Return the http url response
    var httpResponse: HTTPURLResponse? { get }

    /// Return HTTP status code of the response
    var httpStatusCode: Int? { get }

    /// Return the raw Data instance response of the request
    var data: Data? { get }

    /// Attempt to decode Data received from server and return a JSON object.
    /// If it fails it will return an empty JSON object.
    /// Value is stored internally so subsequent calls return cached value.
    ///
    /// - Returns: Model
    func toJSON<T:Decodable>() throws -> T

    /// Attempt to decode Data received from server and return a String object.
    /// If it fails it return `nil`.
    /// Call is not cached but evaluated at each call.
    /// If no encoding is specified, `utf8` is used instead.
    ///
    /// - Parameter encoding: encoding of the data
    /// - Returns: String or `nil` if failed
    func toString(_ encoding: String.Encoding?) -> String?

}
