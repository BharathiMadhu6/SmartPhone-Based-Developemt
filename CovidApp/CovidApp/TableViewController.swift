//
//  TableViewController.swift
//  CovidApp
//
//  Created by bharathi madhu on 3/30/21.
//

import UIKit
import Alamofire
import PromiseKit
import SwiftyJSON

class CovidData {
    var state: String?
    var total: Int?
    var result: Int?
}

class TableViewController: UITableViewController {

    @IBOutlet var tblData: UITableView!
    
    var covidInfo : [CovidData] = [CovidData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getData()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return covidInfo.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
        
        cell.lblState.text = "\(covidInfo[indexPath.row].state ?? "NA")"
        cell.lblTotal.text = "\(covidInfo[indexPath.row].total ?? 0)"
        cell.lblResults.text = "\(covidInfo[indexPath.row].result ?? 0)"
        return cell
    }
    
    func getData() {
        getCovidData()
            .done{ (resultData) in
                self.covidInfo = [CovidData]()
                for value in resultData {
                    self.covidInfo.append(value)
                }
                self.tblData?.reloadData()
            }
            .catch { (error) in
                print("Error fetching covid information")
            }
    }
    
    
    func getCovidData() -> Promise<[CovidData]> {
        
        return Promise<[CovidData]> { seal -> Void in
            AF.request(url).responseJSON{ response in
                if response.error == nil {
                    var arr = [CovidData]()
                    
                    guard let info = response.data else {
                        return seal.fulfill(arr)
                    }
                    
                    guard let values = JSON(info).array else {
                        return seal.fulfill(arr)
                    }
                    
                    for covidInfo in values {
                        let state = covidInfo["state"].stringValue
                        let total = covidInfo["totalTestResults"].intValue
                        let results = covidInfo["positive"].intValue
                        
                        let individual = CovidData()
                        individual.state = state
                        individual.total = total
                        individual.result = results
                        print(individual.state)
                        print(individual.total)
                        print(individual.result)
                        arr.append(individual)
                    }
                    seal.fulfill(arr)
                }
                else {
                    seal.reject(response.error as! Error)
                }
            }
        }
    }

}
