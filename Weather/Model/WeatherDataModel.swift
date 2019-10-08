//
//  WeatherDataModel.swift
//  Weather
//
//  Created by Osmani Perez on 9/17/19.
//  Copyright © 2019 Osmani Perez. All rights reserved.
//

import UIKit

class WeatherDataModel {
    var temperature = 0
    var condition = 0
    var city = ""
    var weatherIconName = ""
    
    func updateWeatherIcon(condition: Int) -> String {
        switch condition {
            
        case 0...300:
            return "tstorm"
            
        case 301...500:
            return "light_rain"
            
        case 501...599:
            return "showers"
            
        case 600...700:
            return "snow"
            
        case 701...771:
            return "fog"
            
        case 781:
            return "tornado"
            
        case 800:
            return "sunny"
            
        case 801...804:
            return "cloudy"
            
        case 900...903, 905...1000:
            return "tstorm"
            
        case 903:
            return "snow"
            
        case 904:
            return "sunny"
            
        default:
            return "???"
        }
    }
}
