//
//  Service.swift
//  PaymentNetworkList
//
//  Created by Hassan Gadou on 08/05/2021.
//

import Foundation
import os

/// Service is a concrete implementation of the ServiceProtocol
public class Service: ServiceProtocol {

    let session = URLSession(configuration: URLSessionConfiguration.default)

    /// Configuration
    public var configuration: ServiceConfig

    /// Session headers
    public var headers: HeadersDict

    /// Initialize a new service with given configuration
    ///
    /// - Parameter configuration: configuration. If `nil` is passed attempt to load configuration from your app's Info.plist
    public required init(_ configuration: ServiceConfig) {
        self.configuration = configuration
        self.headers = self.configuration.headers // fillup with initial headers
    }

    public func execute<T>(_ request: RequestProtocol, completionHandler: @escaping ((Result<T?, Error>) -> Void))  where T : Decodable {

        do{
        let url = try request.urlRequest(in: self)

        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in


            if let error = error {
                completionHandler(.failure(error))
                return
            }

            // We expect HTTP response
            guard let httpResponse = response as? HTTPURLResponse else {
                let error = OONetworkError.invalidHttpResponse("a non-HTTP response")
                completionHandler(.failure(error))
                return
            }
            let parsedResponse = Response(dtResponse: data, response: httpResponse, error: error, request: request)

            switch parsedResponse.type {
                case .success: // success
                    do{
                    let object = try parsedResponse.toJSON() as T
                        completionHandler(.success(object))

                    }catch let error{
                        completionHandler(.failure(OONetworkError.failedToParseJSON(error.localizedDescription)))
                    }
                case .error: // failure
                    completionHandler(.failure(OONetworkError.error(parsedResponse)))
                case .noResponse:  // no response
                    completionHandler(.failure(OONetworkError.noResponse(parsedResponse)))
            }
        })
        task.resume()
    }catch let error {
        let error = OONetworkError.invalidURL(error.localizedDescription)
        completionHandler(.failure(error))
    }

    }





}
