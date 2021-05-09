//
//  ListURL.swift
//  PaymentNetworkList
//
//  Created by Hassan Gadou on 08/05/2021.
//

import Foundation

extension URL {
    static var ListURL: URL {
        return URL(string: "https://raw.githubusercontent.com/optile/checkout-android/develop/shared-test/lists/listresult.json")!
    }
}
