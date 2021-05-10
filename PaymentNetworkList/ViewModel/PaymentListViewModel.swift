//
//  PaymentListViewModel.swift
//  PaymentNetworkList
//
//  Created by Hassan Gadou on 09/05/2021.
//

import Foundation


protocol PaymentListViewModelDelegate: AnyObject {
    func onFetchCompleted()
    func onFetchFailed(with reason: String)
}

final class PaymentListViewModel {

    // MARK: - Properties
    private weak var delegate: PaymentListViewModelDelegate?
    private var paymentNetworks : [PaymentNetwork] = []

    // MARK: - Initializers

    init( delegate: PaymentListViewModelDelegate) {
        self.delegate = delegate
    }

    var totalCount: Int {
        return paymentNetworks.count
    }


    func paymentNetwork(at index: Int) -> PaymentNetwork {
        return paymentNetworks[index]
    }

    
    private func loadPaymentList(completion: @escaping (Result< ListResult , Error >) -> Void){
        let serviceConfig = ServiceConfig.init(URL.baseURL)
        let service:Service = Service(serviceConfig!)
        let operation = ListOperation()

        operation.execute(in: service) { (result) in
            switch result {
                case .success(let list):
                    if let ls = list{
                        completion(.success(ls))
                    }else{
                        completion(.failure(OONetworkError.failedToParseJSON("Not Correct List")))
                    }

                case .failure(let error):
                    completion(.failure(error))
            }

        }

    }



    func fetchPaymentNetworks() {

        loadPaymentList { result in
            switch result {
                // 3
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.delegate?.onFetchFailed(with: error.localizedDescription)
                    }
                // 4
                case .success(let list):
                    DispatchQueue.main.async {
                        // 1

                        let networks = list.networks.applicable.map{
                            PaymentNetwork(from: $0)
                        }

                        self.paymentNetworks.append(contentsOf: networks)
                        self.delegate?.onFetchCompleted()

                    }
            }
        }
    }

}
