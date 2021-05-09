//
//  ViewController.swift
//  PaymentNetworkList
//
//  Created by Hassan Gadou on 08/05/2021.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - Properties
    let standardTheme = Theme()

    // MARK: - IBOutlets

    // MARK: - Initializers

    // MARK: - Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpTheme()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Payment Methods"
    }

    // MARK: - Set up
    private func setUpTheme(){
        self.view.backgroundColor = standardTheme.backgroundColor
        self.navigationController?.navigationBar.barStyle = .black
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: standardTheme.titleTextColor]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: standardTheme.titleTextColor]
        navBarAppearance.backgroundColor = standardTheme.tintColor
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationController?.navigationBar.setNeedsLayout()
        navigationController?.navigationBar.layoutIfNeeded()
        navigationController?.navigationBar.barTintColor = standardTheme.tintColor

    }

}
// MARK: - Extensions
