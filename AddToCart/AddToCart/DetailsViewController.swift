//
//  DetailsViewController.swift
//  AddToCart
//
//  Created by bharathi madhu on 4/23/21.
//

import UIKit
import FirebaseDatabase

class DetailsViewController: UIViewController {

    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var detailImage: UIImageView!
    
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var lblDescription: UILabel!
        
    @IBOutlet weak var lblQty: UILabel!
    
    var prodImage = UIImage()
    var prodTitle: String?
    var prodPrice = 0
    var prodDescription: String?
    var prodId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = prodTitle
        lblPrice.text = "$\(prodPrice)"
        detailImage.image = prodImage
        lblDescription.text = prodDescription
        lblQty.text = "1"
    }
    
    @IBAction func stepper(_ sender: UIStepper) {
        let value = Int(sender.value)
        lblQty.text = "\(value)"
    }
    
    @IBAction func addToCart(_ sender: Any) {
        let qty = Int(lblQty.text!)
        let ref = Database.database().reference()
        ref.child("users").child("\(identifier)").child("cart").child("\(prodId)").setValue(["title":prodTitle,"qty":qty, "price":prodPrice])
        
        let alert = UIAlertController(title: "The product is added to your cart", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
