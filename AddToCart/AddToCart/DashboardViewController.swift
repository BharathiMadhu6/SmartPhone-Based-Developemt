//
//  DashboardViewController.swift
//  AddToCart
//
//  Created by bharathi madhu on 4/20/21.
//

import UIKit
import Firebase
import Alamofire
import PromiseKit
import SwiftyJSON
import FirebaseDatabase

class DashboardProduct {
    var productImage: UIImage?
    var title: String = ""
    var price: Int = 0
    var description: String = ""
    var id: Int = 0
}

class DashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
        
    var arr = [CartItem]()
    
    @IBOutlet weak var lblGreeting: UILabel!
    
    var databaseHandle:DatabaseHandle?
    
    let ref = Database.database().reference()
    
    let c = CartViewController()

    @IBOutlet weak var dashboardTableView: UITableView!
    
    var productsList : [DashboardProduct] = [DashboardProduct]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dashboardTableView.delegate = self
        dashboardTableView.dataSource = self
        getData()
        loadCart()
        loadUser()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardTableViewCell", for: indexPath) as! DashboardTableViewCell
                
        cell.configure(picture: productsList[indexPath.row].productImage!, title: productsList[indexPath.row].title)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController
        
        vc?.prodPrice = productsList[indexPath.row].price
        vc?.prodDescription = productsList[indexPath.row].description
        vc?.prodTitle = productsList[indexPath.row].title
        vc?.prodImage = productsList[indexPath.row].productImage!
        vc?.prodId = productsList[indexPath.row].id
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    func loadUser() {
        ref.child("users").observe(.value) { (snapshot) in
            for child in snapshot.children {
                let childSnapshot = child as! DataSnapshot
                let id = childSnapshot.key as String
                let dictionary = childSnapshot.value as? [String:Any]
                if id == identifier {
                    userEmailId = (dictionary?["username"] as? String)!
                    self.lblGreeting.text = "Hey there \(userEmailId)"
                }
            }
        }
    }
    
    
    @IBAction func showCartItems(_ sender: Any) {

        ref.child("users").child("\(identifier)").child("cart").observe(.value, with: { [self] (snapshot) in
            
            if snapshot.childrenCount == 0 {
                let alert = UIAlertController(title: "Your cart is Empty", message: "", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                return
            }
            else {
            let vc = storyboard?.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
            
            vc.arr = self.arr
            
            self.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }
    
    
    func loadCart() {
        let ref = Database.database().reference()

        ref.child("users").child("\(identifier)").child("cart").observe(.value, with: { (snapshot) in
            
        if snapshot.childrenCount > 0 {
            
            self.arr.removeAll()

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
                
                    self.arr.append(item)
                }
            }
            self.c.cartTableView?.reloadData()
        }
        })
    }


    @IBAction func logoutAction(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            KeychainService().keyChain.delete("uid")
            self.navigationController?.popViewController(animated: true)
        }
        catch {
            print(error)
        }
    }
    
    
    func getData() {
        getProducts()
            .done{ (resultData) in
                self.productsList = [DashboardProduct]()
                for value in resultData {
                    self.productsList.append((value))
                }
                self.dashboardTableView?.reloadData()
            }
            .catch{ (error) in
                print("Error fetching products information")
            }
    }
    }


    func getImageString(icon: Int) -> String
    {
        var item : String = "item"

        item = "\(item)"
        item += "\(icon)"
        return item
    }


    func getProducts() -> Promise<[DashboardProduct]> {
    
        return Promise<[DashboardProduct]> { seal -> Void in
            AF.request(url).responseJSON{ response in
                if response.error == nil {
                    var arr = [DashboardProduct]()
                
                    guard let info = response.data else {
                        return seal.fulfill(arr)
                    }
                
                    guard let values = JSON(info).array else {
                        return seal.fulfill(arr)
                    }
                
                    for productInfo in values {
                        let title = productInfo["title"].stringValue
                        let id = productInfo["id"].intValue
                        let price = productInfo["price"].intValue
                        let desc = productInfo["description"].stringValue
                    
                        let imageName = getImageString(icon: id)
                        let product = DashboardProduct()
                        product.title = title
                        product.productImage = UIImage(named: imageName)
                        product.id = id
                        product.price = price
                        product.description = desc
                    
                        arr.append(product)
                    }
                
                    seal.fulfill(arr)
                }
                else {
                    seal.reject(response.error!)
                }
            }
        }
    }

