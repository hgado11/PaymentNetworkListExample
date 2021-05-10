//
//  PaymentTableViewCell.swift
//  PaymentNetworkList
//
//  Created by Hassan Gadou on 09/05/2021.
//

import UIKit

class PaymentTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configPaymentCell(_ method:PaymentNetwork, theme:Theme, isLasIndex:Bool ){

        titleLabel.text = method.label
        titleLabel.textColor = theme.textColor
        if let logoURL = method.logo{
            logoImage.downloaded(from: logoURL)
        }
        if (isLasIndex){
            self.addBorder(edges: [.left,.right,.top,.bottom], color: theme.tableBorder, thickness: 2)
        }else{
            self.addBorder(edges: [.left,.right,.top], color: theme.tableBorder, thickness: 2)
        }

    }

    func addBorder(edges: UIRectEdge , color: UIColor , thickness: CGFloat ) {

        func createBorder() -> UIView {
            let borderView = UIView(frame: CGRect.zero)
            borderView.translatesAutoresizingMaskIntoConstraints = false
            borderView.backgroundColor = color
            return borderView
        }

        if (edges.contains(.all) || edges.contains(.top)){

                let topBorder = createBorder()
                containerView.addSubview(topBorder)
                NSLayoutConstraint.activate([
                    topBorder.topAnchor.constraint(equalTo: containerView.topAnchor),
                    topBorder.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                    topBorder.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                    topBorder.heightAnchor.constraint(equalToConstant: thickness)
                ])
        }
        if (edges.contains(.all) || edges.contains(.bottom)){
                let bottomBorder = createBorder()
                containerView.addSubview(bottomBorder)
                NSLayoutConstraint.activate([
                    bottomBorder.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                    bottomBorder.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                    bottomBorder.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                    bottomBorder.heightAnchor.constraint(equalToConstant: thickness)
                ])
        }
        if (edges.contains(.all) || edges.contains(.left)){
                let leftBorder = createBorder()
                containerView.addSubview(leftBorder)
                NSLayoutConstraint.activate([
                    leftBorder.topAnchor.constraint(equalTo: containerView.topAnchor),
                    leftBorder.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                    leftBorder.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                    leftBorder.widthAnchor.constraint(equalToConstant: thickness)
                ])
        }
        if (edges.contains(.all) || edges.contains(.right)){
                let rightBorder = createBorder()
                containerView.addSubview(rightBorder)
                NSLayoutConstraint.activate([
                    rightBorder.topAnchor.constraint(equalTo: containerView.topAnchor),
                    rightBorder.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                    rightBorder.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                    rightBorder.widthAnchor.constraint(equalToConstant: thickness)
                ])
        }


    }
    //MARK:- class functions
    class func identifier() ->String {
        return "PaymentTableViewCell"
    }
    class func nib() ->UINib {
        let nib = UINib(nibName: "PaymentTableViewCell", bundle: nil)
        return nib
    }
}
