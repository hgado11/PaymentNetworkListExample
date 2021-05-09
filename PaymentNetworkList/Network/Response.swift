//
//  Response.swift
//  PaymentNetworkList
//
//  Created by Hassan Gadou on 08/05/2021.
//

import Foundation
public class Response: ResponseProtocol {

    /// Type of response
    ///
    /// - success: success
    /// - error: error
    public enum Result {
        case success(_: Int)
        case error(_: Int)
        case noResponse

        private static let successCodes: Range<Int> = 200..<299

        public static func from(response: HTTPURLResponse?) -> Result {
            guard let r = response else {
                return .noResponse
            }
            return (Result.successCodes.contains(r.statusCode) ? .success(r.statusCode) : .error(r.statusCode))
        }

        public var code: Int? {
            switch self {
                case .success(let code):     return code
                case .error(let code):        return code
                case .noResponse:            return nil
            }
        }
    }

    /// Type of result
    public let type: Response.Result

    /// Status code of the response
    public var httpStatusCode: Int? {
        return self.type.code
    }

    /// HTTPURLResponse
    public let httpResponse: HTTPURLResponse?

    /// Raw data of the response
    public var data: Data?

    /// Request executed
    public let request: RequestProtocol

    /// Metrics of the request/response to make benchmarks
    public var metrics: URLSessionTaskMetrics?

    /// Initialize a new response from URLResponse
    ///
    /// - Parameters:
    ///   - response: response
    ///   - request: request

    public init (dtResponse data: Data?, response: HTTPURLResponse?, error: Error?, request: RequestProtocol){
        self.type = Result.from(response: response)
        self.httpResponse = response
        self.data = data
        self.request = request
    }

    public func toJSON<T:Decodable>()throws -> T {

        guard let data = data else {
            let error = OONetworkError.noResponse(self)
            throw error
        }

        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data) 
    }

    public func toString(_ encoding: String.Encoding? = nil) -> String? {
        guard let d = self.data else { return nil }
        return String(data: d, encoding: encoding ?? .utf8)
    }


}
