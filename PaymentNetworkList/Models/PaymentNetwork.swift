//
//  PaymentNetwork.swift
//  PaymentNetworkList
//
//  Created by Hassan Gadou on 09/05/2021.
//

import Foundation
final class PaymentNetwork {
    let applicableNetwork: ApplicableNetwork


    let label: String
    var logo: URL?

    init(from applicableNetwork: ApplicableNetwork) {
        self.applicableNetwork = applicableNetwork


        self.label = applicableNetwork.label


        logo = applicableNetwork.links?["logo"]
    }
}

extension PaymentNetwork: Equatable, Hashable {
    public static func == (lhs: PaymentNetwork, rhs: PaymentNetwork) -> Bool {
        return (lhs.applicableNetwork.code == rhs.applicableNetwork.code)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(applicableNetwork.code)
    }
}
