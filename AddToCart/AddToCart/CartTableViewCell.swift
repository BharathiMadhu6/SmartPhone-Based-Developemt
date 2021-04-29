//
//  CartTableViewCell.swift
//  AddToCart
//
//  Created by bharathi madhu on 4/24/21.
//

import UIKit
import Firebase
import FirebaseDatabase

protocol deleteFunctionality {
    func onClick(index: Int)
}

class CartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cartView: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var imgProduct: UIImageView!
    
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var lblQty: UILabel!
    
    var cellDelegate: deleteFunctionality?
    
    var id: Int?
    
    let dash = CartViewController()
    
    @IBAction func deleteItem(_ sender: Any) {
        cellDelegate?.onClick(index: id!)
    }
}
