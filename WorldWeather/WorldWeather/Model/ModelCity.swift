//
//  ModelCity.swift
//  WorldWeather
//
//  Created by Ashish Ashish on 10/03/21.
//

import Foundation


class ModelCity{
    
    var cityKey : String = ""
    var cityName : String = ""
    
    init(_ cityKey : String, _ cityName: String) {
        self.cityKey = cityKey
        self.cityName = cityName
    }
}
