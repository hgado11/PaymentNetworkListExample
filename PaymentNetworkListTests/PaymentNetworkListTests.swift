//
//  PaymentNetworkListTests.swift
//  PaymentNetworkListTests
//
//  Created by Hassan Gadou on 08/05/2021.
//

import XCTest
@testable import PaymentNetworkList

class PaymentNetworkListTests: XCTestCase {
    let serviceConfig = ServiceConfig.init(URL.baseURL)

    let operation = ListOperation()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //test the normal scenario
    func testListOperationsNormal() throws {
        let service = Service(serviceConfig!)
        operation.execute(in: service) { (result) in

            switch result{
                case .success(let list):
                    XCTAssertNotNil(list)
                case .failure(let error):
                    XCTFail("failed with errored: \(error)")
            }
        }
    }
    func testListOperationsWrongEndPoint() throws -> ListResult? {
        let expe = expectation(description: "Create wrong session")
        let service = Service(serviceConfig!)
        operation.request =  Request(method: .get, endpoint: "", params: [:])
        var opResult: Result<ListResult?, Error>?
        operation.execute(in: service) { (result) in
            opResult = result
            expe.fulfill()
        }

        switch opResult {
            case .success(let list): return list
            case .failure(let error): throw error
            case .none : throw OONetworkError.missingEndpoint

        }
    }


}
