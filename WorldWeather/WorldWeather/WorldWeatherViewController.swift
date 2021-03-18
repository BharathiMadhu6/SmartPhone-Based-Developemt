//
//  ViewController.swift
//  WorldWeather
//
//  Created by Ashish Ashish on 08/03/21.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftSpinner
import SwiftyJSON
import PromiseKit


class WorldWeatherViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var imgCurrentWeather: UIImageView!
    
    @IBOutlet weak var tblForecast: UITableView!
    
    @IBOutlet weak var lblCity: UILabel!
    
    @IBOutlet weak var lblCondition: UILabel!
    
    @IBOutlet weak var lblTemperature: UILabel!
    
    @IBOutlet weak var lblHighLow: UILabel!
    
    let locationManager = CLLocationManager()
    
    let viewModel = WorldWeatherViewModel()
    
    var weatherData: [ModelFiveDayForecast] = [ModelFiveDayForecast]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeText()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func initializeText(){
        self.title = strHelloWorld
        lblCity.text = strCity
        lblCondition.text = strCondition
        lblTemperature.text = strTemperature
        lblHighLow.text = strHighLow
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
        
        cell.lblData.text = "\(weatherData[indexPath.row].date)"
        cell.lblMinTemp.text = "\(weatherData[indexPath.row].minTemp)°"
        cell.lblMaxTemp.text = "\(weatherData[indexPath.row].maxTemp)°"
        cell.lblMaxImage.image = weatherData[indexPath.row].maxImg
        cell.lblMinImage.image = weatherData[indexPath.row].minImg
        return cell
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let currLocation = locations.last{
            
            let lat = currLocation.coordinate.latitude
            let lng = currLocation.coordinate.longitude
            
            updateWeatherData(lat, lng)
        }
    }
    
        
    func updateWeatherData(_ lat : CLLocationDegrees, _ lng : CLLocationDegrees){
        
        let cityDataURL = getLocationURL(lat, lng)
        
        viewModel.getCityData(cityDataURL).done { city in
            self.lblCity.text = city.cityName
            
            let key = city.cityKey
            
            let currentConditionURL = getCurrentConditionURL(key)
            let oneDayForecastURL = getOneDayURL(key)
            let fiveDayForecastURL = getFiveDayURL(key)
            
            
            self.viewModel.getCurrentConditions(currentConditionURL).done { currCondition in
                self.lblCondition.text = currCondition.weatherText
                self.lblTemperature.text =  "\(currCondition.imperialTemp)°"
                self.imgCurrentWeather.image = currCondition.weatherIcon
            }.catch { error in
                print("Error in getting current conditions \(error.localizedDescription)")
            }
            
            
            self.viewModel.getOneDayConditions(oneDayForecastURL).done { oneDay in
                self.lblHighLow.text = "H: \(oneDay.dayTemp)° L: \(oneDay.nightTemp)°"
                
            }.catch { error in
                print("Error in getting one day forecast conditions \(error.localizedDescription)")
            }
        
            
            self.viewModel.getFiveDayConditions(fiveDayForecastURL).done { fiveDay in
                self.weatherData.append(contentsOf: fiveDay)
                self.tblForecast?.reloadData()
                
            }.catch { error in
                print("Error in getting five day forecast \(error.localizedDescription)")
            }
        }
        .catch { error in
            print("Error in getting City Data \(error.localizedDescription)")
        }
    }
}


