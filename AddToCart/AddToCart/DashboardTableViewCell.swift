//
//  DashboardTableViewCell.swift
//  AddToCart
//
//  Created by bharathi madhu on 4/21/21.
//

import UIKit

class DashboardTableViewCell: UITableViewCell {

    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var imgProduct: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    
    //    @IBOutlet weak var imgProduct: UIImageView!
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//    }
//
    func configure(picture: UIImage, title: String) {
        imgProduct.image = picture
        lblTitle.text = title
    }
}
