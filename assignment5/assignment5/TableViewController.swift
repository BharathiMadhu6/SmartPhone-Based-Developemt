//
//  TableViewController.swift
//  assignment5
//
//  Created by bharathi madhu on 2/23/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class TableViewController: UITableViewController {
    
    var headlines = Array<String>()
    
    
    @IBOutlet var tblNews: UITableView!
    
    override func viewDidLoad() {
        getNews()
        super.viewDidLoad()
    }
    
    
    func getNews(){
        AF.request(apiURL).responseJSON { response in
            if(response.error == nil) {
                let news: JSON = JSON(response.data!)

                for(_, news) in news["articles"] {
                    let titleContent = news["title"].string ?? "N/A"
                    self.headlines.append(titleContent)
                }
                
                self.tblNews.reloadData()
            }
            else {
                print("Having trouble loading data")
            }
        }
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headlines.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
        cell.lblHeadline.text = headlines[indexPath.row]

        return cell
    }

}


