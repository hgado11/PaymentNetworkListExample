//
//  RequestBody.swift
//  PaymentNetworkList
//
//  Created by Hassan Gadou on 08/05/2021.
//

import Foundation

/// Possible networking error
///
/// - dataIsNotEncodable: data cannot be encoded in format you have specified
/// - stringFailedToDecode: failed to decode data with given encoding
public enum OONetworkError: Error {
    case dataIsNotEncodable(_: Any)
    case stringFailedToDecode(_: Data, encoding: String.Encoding)
    case invalidURL(_: String)
    case error(_: ResponseProtocol)
    case noResponse(_: ResponseProtocol)
    case missingEndpoint
    case invalidHttpResponse(_: String)
    case failedToParseJSON(_: String)
}
/// Define the parameter's dictionary
public typealias ParametersDict = [String : Any?]

/// Define the header's dictionary
public typealias HeadersDict = [String: String]

/// Define what kind of HTTP method must be used to carry out the `Request`
///
/// - get: get (no body is allowed inside)
/// - post: post
/// - put: put
/// - delete: delete
/// - patch: patch
public enum RequestMethod: String {
    case get    = "GET"
    case post    = "POST"
    case put    = "PUT"
    case delete    = "DELETE"
    case patch    = "PATCH"
}

/// This define how the body should be encoded
///
/// - none: no transformation is applied, data is sent raw as received in `body` param of the request.
/// - json: attempt to serialize a `Dictionary` or a an `Array` as `json`. Other types are not supported and throw an exception.
/// - urlEncoded: it expect a `Dictionary` as input and encode it as url encoded string into the body.
/// - custom->: custom serializer. `Any` is accepted, `Data` is expected as output.
public struct RequestBody {

    /// Data to carry out into the body of the request
    let data: Any

    /// Type of encoding to use
    let encoding: Encoding

    /// Encoding type
    ///
    /// - raw: no encoding, data is sent as received
    /// - json: json encoding
    /// - urlEncoded: url encoded string
    /// - custom: custom serialized data
    public enum Encoding {
        case rawData
        case rawString(_: String.Encoding?)
        case json
        case urlEncoded(_: String.Encoding?)
        case custom(_: CustomEncoder)

        /// Encoder function typealias
        public typealias CustomEncoder = ((Any) -> (Data))
    }

    /// Private initializa a new body
    ///
    /// - Parameters:
    ///   - data: data
    ///   - encoding: encoding type
    private init(_ data: Any, as encoding: Encoding = .json) {
        self.data = data
        self.encoding = encoding
    }

    /// Create a new body which will be encoded as JSON
    ///
    /// - Parameter data: any serializable to JSON object
    /// - Returns: RequestBody
    public static func json(_ data: Any) -> RequestBody {
        return RequestBody(data, as: .json)
    }

    /// Create a new body which will be encoded as url encoded string
    ///
    /// - Parameters:
    ///   - data: a string of encodable data as url
    ///   - encoding: encoding type to transform the string into data
    /// - Returns: RequestBody
    public static func urlEncoded(_ data: ParametersDict, encoding: String.Encoding? = .utf8) -> RequestBody {
        return RequestBody(data, as: .urlEncoded(encoding))
    }

    /// Create a new body which will be sent in raw form
    ///
    /// - Parameter data: data to send
    /// - Returns: RequestBody
    public static func raw(data: Data) -> RequestBody {
        return RequestBody(data, as: .rawData)
    }

    /// Create a new body which will be sent as plain string encoded as you set
    ///
    /// - Parameter data: data to send
    /// - Returns: RequestBody
    public static func raw(string: String, encoding: String.Encoding? = .utf8) -> RequestBody {
        return RequestBody(string, as: .rawString(encoding))
    }

    /// Create a new body which will be encoded with a custom function.
    ///
    /// - Parameters:
    ///   - data: data to encode
    ///   - encoder: encoder function
    /// - Returns: RequestBody
    public static func custom(_ data: Data, encoder: @escaping Encoding.CustomEncoder) -> RequestBody {
        return RequestBody(data, as: .custom(encoder))
    }

    /// Encoded data to carry out with the request
    ///
    /// - Returns: Data
    public func encodedData() throws -> Data {
        switch self.encoding {
            case .rawData:
                return self.data as! Data
            case .rawString(let encoding):
                guard let string = (self.data as! String).data(using: encoding ?? .utf8) else {
                    throw OONetworkError.dataIsNotEncodable(self.data)
                }
                return string
            case .json:
                return try JSONSerialization.data(withJSONObject: self.data, options: [])
            case .urlEncoded(let encoding):
                let encodedString = try (self.data as! ParametersDict).urlEncodedString()
                guard let data = encodedString.data(using: encoding ?? .utf8) else {
                    throw OONetworkError.dataIsNotEncodable(encodedString)
                }
                return data
            case .custom(let encodingFunc):    return encodingFunc(self.data)
        }
    }

    /// Return the representation of the body as `String`
    ///
    /// - Parameter encoding: encoding use to read body's data. If not specified `utf8` is used.
    /// - Returns: String
    /// - Throws: throw an exception if string cannot be decoded as string
    public func encodedString(_ encoding: String.Encoding = .utf8) throws -> String {
        let encodedData = try self.encodedData()
        guard let stringRepresentation = String(data: encodedData, encoding: encoding) else {
            throw OONetworkError.stringFailedToDecode(encodedData, encoding: encoding)
        }
        return stringRepresentation
    }
}

// MARK: - Dictionary Extension
public extension Dictionary where Key == String, Value == Any? {

    /// Encode a dictionary as url encoded string
    ///
    /// - Parameter base: base url
    /// - Returns: encoded string
    /// - Throws: throw `.dataIsNotEncodable` if data cannot be encoded
    func urlEncodedString(base: String = "") throws -> String {
        guard self.count > 0 else { return "" } // nothing to encode
        let items: [URLQueryItem] = self.compactMap { (key,value) in
            guard let v = value else { return nil } // skip item if no value is set
            return URLQueryItem(name: key, value: String(describing: v))
        }
        var urlComponents = URLComponents(string: base)!
        urlComponents.queryItems = items
        guard let encodedString = urlComponents.url else {
            throw OONetworkError.dataIsNotEncodable(self)
        }
        return encodedString.absoluteString
    }

}
