//
//  ListOperation.swift
//  PaymentNetworkList
//
//  Created by Hassan Gadou on 09/05/2021.
//

import Foundation

class ListOperation:OperationProtocol  {

    public var request: RequestProtocol?
    public init() {
        self.request = Request(method: .get, endpoint: "/optile/checkout-android/develop/shared-test/lists/listresult.json", params: [:])
    }

    public func execute(in service: ServiceProtocol, completionHandler: @escaping ((Result<ListResult?, Error>) -> Void))  {
        guard let rq = self.request else { // missing request
            completionHandler(.failure(OONetworkError.missingEndpoint))
            return
        }

        service.execute(rq) { (result) in
            completionHandler(result)
        }

    }
}
