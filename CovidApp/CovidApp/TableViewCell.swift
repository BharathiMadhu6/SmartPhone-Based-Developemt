//
//  TableViewCell.swift
//  CovidApp
//
//  Created by bharathi madhu on 3/30/21.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    @IBOutlet weak var lblState: UILabel!
    
    @IBOutlet weak var lblTotal: UILabel!
    
    @IBOutlet weak var lblResults: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
