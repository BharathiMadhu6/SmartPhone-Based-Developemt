//
//  CartViewController.swift
//  AddToCart
//
//  Created by bharathi madhu on 4/24/21.
//

import UIKit
import Alamofire
import Firebase
import FirebaseDatabase
import PromiseKit
import SwiftyJSON

class CartItem {
    var productImage: UIImage?
    var title: String?
    var qty: Int?
    var price: Int?
    var id: Int?
}

let dash = DashboardViewController()

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, deleteFunctionality{
    
    var cartItems: [CartItem] = [CartItem]()
    
    var arr = [CartItem]()

    @IBOutlet weak var cartTableView: UITableView!
    
    @IBOutlet weak var lblStatus: UILabel!
            
    @IBOutlet weak var lblTotal: UILabel!
    
    @IBOutlet weak var lblSubTotal: UILabel!
    
    @IBOutlet weak var lblTax: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        cartItems = arr
        lblStatus.text = ""
        loadCart()
        loadTotal()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
        
        cell.lblTitle.text = self.cartItems[indexPath.row].title
        cell.imgProduct.image = self.cartItems[indexPath.row].productImage
        cell.lblQty.text = "Qty: \(self.cartItems[indexPath.row].qty!)"
        cell.lblPrice.text = "$\(self.cartItems[indexPath.row].price ?? 0)"
        cell.cellDelegate = self
        cell.id = self.cartItems[indexPath.row].id
        return cell
    }
    
    
    func loadTotal() {
        var subTotal = 0.0
        
        for value in cartItems {
            let current = Double(value.price! * value.qty!)
            subTotal = subTotal + current
        }
        let tax = 0.1 * Double(subTotal)
        let total = subTotal + tax
        lblTotal.text = "$\(total.rounded())"
        lblSubTotal.text = "\(subTotal.rounded())"
        lblTax.text = "\(tax.rounded())"
    }
    
    
    func loadCart() {
        let ref = Database.database().reference()

        ref.child("users").child("\(identifier)").child("cart").observe(.value, with: { (snapshot) in
            
        if snapshot.childrenCount > 0 {
            
            self.cartItems.removeAll()

            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let id = childSnapshot.key as? String,
                   let dictionary = childSnapshot.value as? [String:Any],
                   let title = dictionary["title"] as? String,
                   let qty = dictionary["qty"] as? Int,
                   let price = dictionary["price"] as? Int{
                    let item = CartItem()
                    item.title = title
                    item.qty = qty
                    item.productImage = UIImage(named: "item\(id)")
                    item.price = price
                    item.id = Int(id)
                
                    self.cartItems.append(item)
                }
            }
            self.cartTableView?.reloadData()
            self.loadTotal()
        }
        else {
            self.cartItems.removeAll()
            self.lblStatus.text = "Your have no items in your cart"
            self.loadTotal()
            self.cartTableView?.reloadData()
        }
        })
    }
    
    
    func deleteProduct(index: Int) {
        let ref = Database.database().reference()
        ref.child("users").child("\(identifier)").child("cart").child("\(index)").setValue(nil)
        self.loadCart()
    }
    
    
    func onClick(index: Int) {
        deleteProduct(index: index)
        let alert = UIAlertController(title: "Product is removed from your cart", message: "", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            self.cartTableView?.reloadData()
        }))
        self.present(alert, animated: true)
    }
}





