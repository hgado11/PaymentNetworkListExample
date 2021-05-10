//
//  ViewModelTests.swift
//  PaymentNetworkListTests
//
//  Created by Hassan Gadou on 10/05/2021.
//

import XCTest
@testable import PaymentNetworkList
class ViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetResultFromViewModel() throws {
        let vm = PaymentListViewModel(delegate: self)
        vm.fetchPaymentNetworks()
    }



}

extension ViewModelTests:PaymentListViewModelDelegate{

    func onFetchCompleted(){
        XCTAssertTrue(0 == 0)
    }
    func onFetchFailed(with reason: String){
        XCTFail("failed with errored: \(reason)")
    }

}
