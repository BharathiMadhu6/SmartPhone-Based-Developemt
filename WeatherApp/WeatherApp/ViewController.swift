//
//  ViewController.swift
//  WeatherApp
//
//  Created by bharathi madhu on 3/8/21.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftSpinner
import SwiftyJSON
import PromiseKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var lblLongitude: UILabel!
    @IBOutlet weak var lblLatitude: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    
    let locationManager = CLLocationManager()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }


    @IBAction func getLatitudeLongitude(_ sender: Any) {
        
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ _manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last{
            let lat = currentLocation.coordinate.latitude
            let lng = currentLocation.coordinate.longitude
            
            lblLatitude.text = "Latitude : \(lat)"
            lblLongitude.text = "Longitude : \(lng)"
            
            let url = getLocationURL(lat, lng)
            print(url)
            
            getLocationDetails(url)
                .done({ (key, city) in
                    print(key)
                    print(city)
                    self.lblCity.text = "City : \(city)"
                })
                .catch { error in
                    print("Error in fetching data \(error.localizedDescription)")
                }
        }
    }
    
    
    func getLocationURL(_ lat : CLLocationDegrees, _ lng : CLLocationDegrees) -> String {
        var url = locationURL
        url.append("?apikey=\(apiKey)&q=\(lat),\(lng)")
        
        return url
    }
    
    
    func getLocationDetails(_ url : String) -> Promise<(String, String)> {
        
        return Promise<(String, String)> { seal -> Void in
            AF.request(url).responseJSON { response in
                
                if(response.error != nil) {
                    seal.reject(response.error!)
                }
                
                let locationJSON : JSON = JSON(response.data)
                let key = locationJSON["Key"].stringValue
                let city = locationJSON["LocalizedName"].stringValue
                
                seal.fulfill((key, city))
            }
        }
    }
}

