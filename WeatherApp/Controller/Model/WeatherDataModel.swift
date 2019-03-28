//
//  WeatherDataModel.swift
//
//
//  Created by Os! on 04/01/1440 AH.
//

import UIKit

class WeatherDataModel: UIViewController {
    
    var temprture = 0 // because we don't want it with decimal we want a integer number
    var condition = 0
    var cityName = ""
    var nameOfConditionImage = ""
    

    func updateWeatherIcon(condition : Int) -> String {
        
    switch (condition) {
    
    
    case 0...300 :
        return "tstorm1" // return the name of the image
        
    case 301...500 :
        return "light_rain"
        
    case 501...600 :
        return "shower3"
        
    case 601...700 :
        return "snow4"
        
    case 701...771 :
        return "fog"
        
    case 772...799 :
        return "tstorm3"
        
    case 800 :
        return "sunny"
        
    case 801...804 :
        return "cloudy"
        
    case 900...903, 905...1000  :
        return "tstorm3"
        
    case 903 :
        return "snow"
        
    case 904 :
        return "sunny"
        
    default :
        return "dunno"

        }
    }
}
