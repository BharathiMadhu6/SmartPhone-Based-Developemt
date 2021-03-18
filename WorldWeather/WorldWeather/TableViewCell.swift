//
//  TableViewCell.swift
//  WorldWeather
//
//  Created by bharathi madhu on 3/16/21.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var lblData: UILabel!
    
    @IBOutlet weak var lblMinImage: UIImageView!
    
    @IBOutlet weak var lblMinTemp: UILabel!
    
    @IBOutlet weak var lblMaxImage: UIImageView!
    
    @IBOutlet weak var lblMaxTemp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
