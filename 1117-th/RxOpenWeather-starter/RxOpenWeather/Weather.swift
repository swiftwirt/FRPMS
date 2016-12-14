//
//  Weather.swift
//  OpenWeatherMapAPI-starter
//
//  Created by fnord on 12/2/16.
//  Copyright © 2016 Nikolas Burk. All rights reserved.
//

import Foundation
import ObjectMapper 

struct Context: MapContext {
    var unit: TemperatureUnit = .fahrenheit
    var isList: Bool
}

enum TemperatureUnit: String {
    case fahrenheit = "imperial"
    case celsius = "metric"
    case kelvin = "anything"
}

class Weather: Mappable{
    private var dateNum: Int!
    var description: String!
    var tempMax: Double!
    var tempMin: Double!
    var tempAverage: Double!
    var unit: TemperatureUnit!
    var date: NSDate!
    
    init(description: String, tempMax: Double, tempMin: Double, tempAverage: Double, unit: TemperatureUnit, date: NSDate) {
        self.description = description
        self.tempMax = tempMax
        self.tempMin = tempMin
        self.tempAverage = tempAverage
        self.unit = unit
        self.date = date
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        if let context = map.context as! Context?{
            unit = context.unit
            
            if context.isList{
                description <- map["weather.0.description"]
                tempMax <- map["temp.max"]
                tempMin <- map["temp.min"]
                tempAverage = (tempMin + tempMax)/2
                dateNum <- map["dt"]
                date = NSDate(timeIntervalSince1970: TimeInterval(dateNum))
            }else{
                description <- map["weather.0.description"]
                tempMax <- map["main.temp_max"]
                tempMin <- map["main.temp_min"]
                tempAverage <- map["main.temp"]
                date <- map["dt"]
            }
        }else{
            unit = TemperatureUnit.kelvin
        }
    }
}
