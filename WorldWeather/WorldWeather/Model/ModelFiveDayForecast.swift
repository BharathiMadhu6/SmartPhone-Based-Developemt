//
//  ModelFiveDayForecast.swift
//  WorldWeather
//
//  Created by bharathi madhu on 3/16/21.
//

import Foundation
import UIKit

class ModelFiveDayForecast {
    var date = ""
    var minTemp = 0
    var maxTemp = 0
    var minImg : UIImage?
    var maxImg : UIImage?
    
    init(_ date : String, _ minTemp : Int, _ maxTemp : Int, _ minImg : String, _ maxImg : String) {
        self.date = date
        self.minTemp = minTemp
        self.maxTemp = maxTemp
        self.minImg = UIImage(named: minImg)
        self.maxImg = UIImage(named: maxImg)
    }
    
}
