//
//  TableViewController.swift
//  NetworkCallsWithPromises
//
//  Created by bharathi madhu on 3/3/21.
//

import UIKit
import Alamofire
import PromiseKit
import SwiftyJSON

class Comodity {
    var name: String?
    var price: Float?
}

class TableViewController: UITableViewController {
    
        
    @IBOutlet var tblCommodity: UITableView!
    
    var commodities: [Comodity] = [Comodity]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commodities.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
        
        cell.nameLbl.text = "\(commodities[indexPath.row].name ?? "N/A")"
        cell.priceLbl.text = "\(commodities[indexPath.row].price ?? 0)"
        
        return cell
    }
    
    
    
    func getData() {
        getCommodities()
            .done{ (items) in
                self.commodities = [Comodity]()
                for value in items {
                    self.commodities.append(value)
                }
                self.tblCommodity?.reloadData()
                
            }
            .catch { (error) in
                print("Error fetching commodies data")
            }
    }
    
    
    //Promise function
    func getCommodities() -> Promise<[Comodity]> {
        
        return Promise<[Comodity]> { seal -> Void in
            AF.request(apiURL).responseJSON{ response in
                if response.error == nil {
                    var arr = [Comodity]()
                    
                    guard let data = response.data else {
                        return seal.fulfill(arr)
                    }
                    
                    guard let items = JSON(data).array else {
                        return seal.fulfill(arr)
                    }
                    
                    for value in items {
                        let name = value["name"].stringValue
                        let price = value["price"].floatValue
                        
                        let value = Comodity()
                        value.name = name
                        value.price = price
                        arr.append(value)
                    }
                    seal.fulfill(arr)
                }
                else {
                    seal.reject(response.error!)
                }
            }
        }
    }

}


