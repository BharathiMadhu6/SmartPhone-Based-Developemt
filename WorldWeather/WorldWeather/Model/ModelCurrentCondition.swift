//
//  ModelCurrentCondition.swift
//  WorldWeather
//
//  Created by Ashish Ashish on 10/03/21.
//

import Foundation
import UIKit

class ModelCurrentCondition{
    
    var weatherText : String = ""
    var weatherIcon : UIImage?
    var isDayTime : Bool = true
    var metricTemp : Float = 0.0
    var imperialTemp : Int = 0
    
    init(_ weatherText : String, _ metricTemp : Float, _ imperialTemp : Int, _ weatherIcon : String) {
        self.weatherText = weatherText
        self.metricTemp = metricTemp
        self.imperialTemp  = imperialTemp
        self.weatherIcon = UIImage(named: weatherIcon)
    }
}
