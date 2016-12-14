//
//  Forecast.swift
//  OpenWeatherMapAPI-starter
//
//  Created by fnord on 12/4/16.
//  Copyright © 2016 Nikolas Burk. All rights reserved.
//

import Foundation
import ObjectMapper

class Forecast: Mappable{
    var forecast = [Weather]()
   
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        do{
            self.forecast = try Mapper<Weather>(context: Context(unit: .fahrenheit, isList: true)).mapArray(JSONArray: map.value("list"))!
        }catch is MapError{
            print("There was a map error")
        }catch{
            print("Some other error")
        }
    }
}
