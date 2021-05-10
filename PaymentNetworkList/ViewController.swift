//
//  ViewController.swift
//  PaymentNetworkList
//
//  Created by Hassan Gadou on 08/05/2021.
//

import UIKit

class ViewController: UIViewController,AlertDisplayer {
    // MARK: - Properties
    let standardTheme = Theme()
    var viewModel:PaymentListViewModel?

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            setUpTableView()
        }
    }

    // MARK: - Initializers

    // MARK: - Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpTheme()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Payment Methods"
        viewModel = PaymentListViewModel(delegate: self)
        viewModel?.fetchPaymentNetworks()
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
    private func setUpTableView(){
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.rowHeight = 64
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        tableView.register(PaymentTableViewCell.nib(), forCellReuseIdentifier: PaymentTableViewCell.identifier())
        tableView.delegate = self
        tableView.dataSource = self
    }

}
// MARK: - Extensions
extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.totalCount ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PaymentTableViewCell.identifier(), for: indexPath) as? PaymentTableViewCell else {
            fatalError()
        }
        if let method = viewModel?.paymentNetwork(at: indexPath.row), let total = viewModel?.totalCount{
            cell.configPaymentCell(method, theme: standardTheme, isLasIndex: (indexPath.row == total - 1))
        }
        return cell
    }

    


}

extension ViewController:PaymentListViewModelDelegate{
    func onFetchCompleted() {
        self.tableView.reloadData()
    }

    func onFetchFailed(with reason: String) {
        displayAlert(with: "ERROR", message: reason)
    }


}
