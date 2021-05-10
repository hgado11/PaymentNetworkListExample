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
        let promise = expectation(description: "request completed")
        let service = Service(serviceConfig!)
        operation.execute(in: service) { (result) in

            switch result{
                case .success(let list):
                    if let listR = list{
                        XCTAssertEqual(listR.networks.applicable.count, 17)
                    }else{
                        XCTFail(OONetworkError.failedToParseJSON("").localizedDescription)
                    }
                case .failure(let error):
                    XCTFail(error.localizedDescription)
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 1)
    }


    func testListOperationsWrongEndPoint() throws  {
        let expe = expectation(description: "Create wrong session")
        let service = Service(serviceConfig!)
        operation.request =  Request(method: .get, endpoint: "", params: [:])
        var opResult: Result<ListResult?, Error>?
        operation.execute(in: service) { (result) in
            opResult = result
            expe.fulfill()
        }
        wait(for: [expe], timeout: 1)
        switch opResult {
            case .success(let list): return XCTAssertNotNil(list)
            case .failure(let error): XCTAssertNotNil(error)
            case .none : throw OONetworkError.missingEndpoint

        }


    }

    


}
