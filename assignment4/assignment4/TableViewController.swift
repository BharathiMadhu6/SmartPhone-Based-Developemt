//
//  TableViewController.swift
//  assignment4
//
//  Created by bharathi madhu on 2/16/21.
//

import UIKit

class TableViewController: UITableViewController {
    
    let cities = ["Banaglore","Seattle","Hyderabad","New York","Miami","Honululu","Maui"]
    
    let temperatures = ["75 F","43 F", "80 F","35 F","73 F","76 F","68 F"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cities.count;
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
        
        cell.lblCity.text = cities[indexPath.row]
        cell.lblTemperature.text = temperatures[indexPath.row]
        
        return cell
    }

}
