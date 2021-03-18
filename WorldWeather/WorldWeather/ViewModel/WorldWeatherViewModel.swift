//
//  CityViewModel.swift
//  WorldWeather
//
//  Created by Ashish Ashish on 10/03/21.
//

import Foundation
import PromiseKit
import SwiftyJSON


class WorldWeatherViewModel{
    
    func getCityData(_ url : String) -> Promise<ModelCity> {
        
        return Promise<ModelCity>{ seal ->Void in
            
            getAFResponseJSON(url).done { json in
                
                let key = json["Key"].stringValue
                let city = json["LocalizedName"].stringValue
                let cityModel: ModelCity = ModelCity(key, city)
                
                seal.fulfill(cityModel)
            }
            .catch { error in
                seal.reject(error)
            }
        }
    }
    
    func getCurrentConditions(_ url : String) -> Promise<ModelCurrentCondition>{
        return Promise<ModelCurrentCondition> { seal ->Void in
            
            getAFResponseJSONArray(url).done { [self] currentWeatherJSON in
                
                let weatherText = currentWeatherJSON[0]["WeatherText"].stringValue
                let weatherIcon = currentWeatherJSON[0]["WeatherIcon"].intValue
                let isDayTime = currentWeatherJSON[0]["IsDayTime"].boolValue
                let metricTemp = currentWeatherJSON[0]["Temperature"]["Metric"]["Value"].floatValue
                let imperialTemp = currentWeatherJSON[0]["Temperature"]["Imperial"]["Value"].intValue
                
                let currCondition = ModelCurrentCondition(weatherText, metricTemp, imperialTemp, "")
                currCondition.isDayTime  = isDayTime
                let currentConditionIcon = getIconString(icon: weatherIcon)
                currCondition.weatherIcon = UIImage(named: currentConditionIcon)
                
                seal.fulfill(currCondition)
            
            }
            .catch { error in
                seal.reject(error)
            }
            
        }
    }
    
    func getOneDayConditions(_ url : String) -> Promise<ModelOneDayForecast>{
        return Promise<ModelOneDayForecast> { seal -> Void in
            
            getAFResponseJSON(url).done { json in
                
                let dayForecast = ModelOneDayForecast()
                dayForecast.headlineText = json["Headline"]["Text"].stringValue
                dayForecast.nightTemp = json["DailyForecasts"][0]["Temperature"]["Minimum"]["Value"].intValue
                dayForecast.dayTemp = json["DailyForecasts"][0]["Temperature"]["Maximum"]["Value"].intValue
                dayForecast.dayIcon = json["DailyForecasts"][0]["Day"]["Icon"].intValue
                dayForecast.nightIcon = json["DailyForecasts"][0]["Night"]["Icon"].intValue
                dayForecast.dayIconPhrase = json["DailyForecasts"][0]["Day"]["IconPhrase"].stringValue
                dayForecast.nightIconPhrase = json["DailyForecasts"][0]["Night"]["IconPhrase"].stringValue

                seal.fulfill(dayForecast)
            
            }
            .catch { error in
                seal.reject(error)
            }
            
        }
    }
    
    func getDayNameBy(stringDate: String) -> String
    {
        let df  = DateFormatter()
            df.dateFormat = "YYYY-MM-dd"
        let date = df.date(from: stringDate)!
            df.dateFormat = "EEEE"
        return df.string(from: date);
    }
    
    
    func getIconString(icon: Int) -> String
    {
        var dayNightIcon : String = ""
        if(icon < 9) {
            dayNightIcon = "0"
            dayNightIcon += "\(icon)"
            dayNightIcon += "-s"
        }
        else {
            dayNightIcon = "0"
            dayNightIcon = "\(icon)"
            dayNightIcon += "-s"
        }
        return dayNightIcon
    }
    
    
    func getFiveDayConditions(_ url : String) -> Promise<[ModelFiveDayForecast]> {
               return Promise<[ModelFiveDayForecast]> { seal -> Void in
                   
                getAFResponseJSON(url).done { [self] json in
                    var arr : [ModelFiveDayForecast] = [ModelFiveDayForecast]()
                                       
                    let weather = JSON(json)["DailyForecasts"]
                    
                    let fiveDayForecast0 = ModelFiveDayForecast("A",0,0,"A","A")
                    let fiveDayForecast1 = ModelFiveDayForecast("A",0,0,"A","A")
                    let fiveDayForecast2 = ModelFiveDayForecast("A",0,0,"A","A")
                    let fiveDayForecast3 = ModelFiveDayForecast("A",0,0,"A","A")
                    let fiveDayForecast4 = ModelFiveDayForecast("A",0,0,"A","A")
                    
                    let dayOfTheWeek0 = weather[0]["Date"].stringValue.prefix(10)
                    let day0 = self.getDayNameBy(stringDate: String(dayOfTheWeek0))
                    fiveDayForecast0.date = day0
                    fiveDayForecast0.minTemp = weather[0]["Temperature"]["Minimum"]["Value"].intValue
                    fiveDayForecast0.maxTemp = weather[0]["Temperature"]["Maximum"]["Value"].intValue
                    let dIcon0 = weather[0]["Day"]["Icon"].intValue
                    let nIcon0 = weather[0]["Night"]["Icon"].intValue
                    let iconDay0 = getIconString(icon: Int(dIcon0))
                    let iconNight0 = getIconString(icon: Int(nIcon0))
                    fiveDayForecast0.minImg = UIImage(named: iconNight0)
                    fiveDayForecast0.maxImg = UIImage(named: iconDay0)
                    arr.append(fiveDayForecast0)

                    let dayOfTheWeek1 = weather[1]["Date"].stringValue.prefix(10)
                    let day1 = self.getDayNameBy(stringDate: String(dayOfTheWeek1))
                        fiveDayForecast1.date = day1
                        fiveDayForecast1.minTemp = weather[1]["Temperature"]["Minimum"]["Value"].intValue
                        fiveDayForecast1.maxTemp = weather[1]["Temperature"]["Maximum"]["Value"].intValue
                    let dIcon1 = weather[1]["Day"]["Icon"].intValue
                    let nIcon1 = weather[1]["Night"]["Icon"].intValue
                    let iconDay1 = getIconString(icon: Int(dIcon1))
                    let iconNight1 = getIconString(icon: Int(nIcon1))
                    fiveDayForecast1.minImg = UIImage(named: iconNight1)
                    fiveDayForecast1.maxImg = UIImage(named: iconDay1)
                        arr.append(fiveDayForecast1)

                    let dayOfTheWeek2 = weather[2]["Date"].stringValue.prefix(10)
                    let day2 = self.getDayNameBy(stringDate: String(dayOfTheWeek2))
                        fiveDayForecast2.date = day2
                        fiveDayForecast2.minTemp = weather[2]["Temperature"]["Minimum"]["Value"].intValue
                        fiveDayForecast2.maxTemp = weather[2]["Temperature"]["Maximum"]["Value"].intValue
                    let dIcon2 = weather[2]["Day"]["Icon"].intValue
                    let nIcon2 = weather[2]["Night"]["Icon"].intValue
                    let iconDay2 = getIconString(icon: Int(dIcon2))
                    let iconNight2 = getIconString(icon: Int(nIcon2))
                    fiveDayForecast2.minImg = UIImage(named: iconNight2)
                    fiveDayForecast2.maxImg = UIImage(named: iconDay2)
                        arr.append(fiveDayForecast2)


                    let dayOfTheWeek3 = weather[3]["Date"].stringValue.prefix(10)
                    let day3 = self.getDayNameBy(stringDate: String(dayOfTheWeek3))
                        fiveDayForecast3.date = day3
                        fiveDayForecast3.minTemp = weather[3]["Temperature"]["Minimum"]["Value"].intValue
                        fiveDayForecast3.maxTemp = weather[3]["Temperature"]["Maximum"]["Value"].intValue
                    let dIcon3 = weather[3]["Day"]["Icon"].intValue
                    let nIcon3 = weather[3]["Night"]["Icon"].intValue
                    let iconDay3 = getIconString(icon: Int(dIcon3))
                    let iconNight3 = getIconString(icon: Int(nIcon3))
                    fiveDayForecast3.minImg = UIImage(named: iconNight3)
                    fiveDayForecast3.maxImg = UIImage(named: iconDay3)
                        arr.append(fiveDayForecast3)


                    let dayOfTheWeek4 = weather[4]["Date"].stringValue.prefix(10)
                    let day4 = self.getDayNameBy(stringDate: String(dayOfTheWeek4))
                        fiveDayForecast4.date = day4
                        fiveDayForecast4.minTemp = weather[4]["Temperature"]["Minimum"]["Value"].intValue
                        fiveDayForecast4.maxTemp = weather[4]["Temperature"]["Maximum"]["Value"].intValue
                    let dIcon4 = weather[4]["Day"]["Icon"].intValue
                    let nIcon4 = weather[4]["Night"]["Icon"].intValue
                    let iconDay4 = getIconString(icon: Int(dIcon4))
                    let iconNight4 = getIconString(icon: Int(nIcon4))
                    fiveDayForecast4.minImg = UIImage(named: iconNight4)
                    fiveDayForecast4.maxImg = UIImage(named: iconDay4)
                        arr.append(fiveDayForecast4)

                       seal.fulfill(arr)
                   }
                   .catch { error in
                       seal.reject(error)
                   }
               }
        }

}
