//
//  RxOpenWeatherMapAPI.swift
//  RxOpenWeather
//
//  Created by Nikolas Burk on 17/11/16.
//  Copyright © 2016 Nikolas Burk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RxOpenWeatherMapAPI {
    
    // MARK: Public API
    
    func createWeatherObservable(for city: String, temperatureUnit: TemperatureUnit = .fahrenheit) -> Observable<Weather?> {
        
        //If the url fails to build, return nil
        guard let url = buildURLForCurrentWeather(for: city, temperatureUnit: temperatureUnit) else {
            print("invalid url")
            return Observable<Weather?>.just(nil)
        }
        
        print(#function, url)
        
        let request = URLRequest(url: url)
        let jsonObservable: Observable<Any> = URLSession.shared.rx.json(request: request)
        
        let maybeWeatherObservable = jsonObservable.map { (json: Any) -> Weather? in
            guard let weatherInfo = json as? [String: Any] else {
                print("could not parse weather info")
                return nil
            }
            return self.jsonToOptionalWeather(weatherInfo: weatherInfo, tempUnit: temperatureUnit)
        }
        
        return maybeWeatherObservable
            .observeOn(MainScheduler.instance)
            .catchErrorJustReturn(nil)
    }
    
    func getWeatherForecast(location: String, temperatureUnit: TemperatureUnit = .fahrenheit, dayCount: Int=5, callback: @escaping (Forecast?, Error?) -> ()) {
        
        let url = buildURLForWeatherForcast(for: ForecastPeriod(rawValue: dayCount) ?? .oneDay , city: location, temperatureUnit: temperatureUnit)
        
        makeAPICall(url: url) { (jsonString, error) in
            if let jsonString = jsonString {
                callback(Forecast(JSONString: jsonString)!, nil)
            }else{
                print(error?.localizedDescription ?? "An Error occured")
                callback(nil, error)
            }
        }
    }
    
    
    // MARK: Build URLS
    
    fileprivate func buildURLForCurrentWeather(for city: String, temperatureUnit: TemperatureUnit) -> URL? {
        let path = RxOpenWeatherMapAPI.Endpoint.weather.rawValue
        let queryString = buildGeneralURLArguments(for: city, temperatureUnit: temperatureUnit)
        let urlString = baseURL + "/" + path + "?" + queryString
        
        return URL(string: urlString)
    }
    
    fileprivate func buildGeneralURLArguments(for city: String, temperatureUnit: TemperatureUnit) -> String {
        let urlEscapedCity = city.urlEscapedString
        let q = RxOpenWeatherMapAPI.GeneralParameters.q.rawValue + "=" + urlEscapedCity
        let appId = RxOpenWeatherMapAPI.GeneralParameters.appId.rawValue + "=" + apiKey
        
        var urlArguments = [q, appId]
        
        if temperatureUnit != .kelvin {
            let units = RxOpenWeatherMapAPI.GeneralParameters.units.rawValue + "=" + temperatureUnit.rawValue
            urlArguments.append(units)
        }
        
        return concatURLArguments(arguments: urlArguments) // q + "&" + units + "&" + appId
    }
    
    fileprivate func buildURLForWeatherForcast(for forecastPeriod: RxOpenWeatherMapAPI.ForecastPeriod, city: String, temperatureUnit: TemperatureUnit) -> URL {
        let path = RxOpenWeatherMapAPI.Endpoint.forecast.rawValue
        
        var queryString = buildGeneralURLArguments(for: city, temperatureUnit: temperatureUnit)
        queryString += "&" + RxOpenWeatherMapAPI.ForecastParameters.cnt.rawValue + "=" + String(forecastPeriod.rawValue)
        
        let urlString = baseURL + "/" + path + "?" + queryString
        
        return URL(string: urlString)!
    }
    
    fileprivate func concatURLArguments(arguments: [String]) -> String {
        return arguments.joined(separator: "&")
    }
    
    // MARK: Parsing
    
    fileprivate func jsonToOptionalWeather(weatherInfo: [String: Any], tempUnit: TemperatureUnit) -> Weather? {
        return (String(describing: weatherInfo["cod"]!) == "200") ? Weather(JSON: weatherInfo, context: Context(unit: tempUnit, isList: false)) : nil
    }
    
    fileprivate func makeAPICall(url: URL, completion: @escaping (String?, Error?) -> ()){
        
        let session: URLSession = URLSession.shared
        
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            if let data = data {
                let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                
                completion(jsonString as String?, nil)
            }
            else {
                print("no data received: \(error)")
                completion(nil, error)
            }
            
        })
        task.resume()
    }

    
    // MARK: Types & Constants
    
    let apiKey = "9c964db2654c0150f1e991a61f8eaef0"
    
    fileprivate let baseURL = "http://api.openweathermap.org/data/2.5"
    
    fileprivate enum GeneralParameters: String {
        case appId
        case q
        case units
    }
    
    fileprivate enum ForecastParameters: String {
        case cnt
    }
    fileprivate enum Endpoint: String {
        case weather = "weather"
        case forecast = "forecast/daily"
    }
    
    public static let maxForecastDays = 16
    enum ForecastPeriod: Int {
        case oneDay = 1
        case twoDays
        case threeDays
        case fourDays
        case fiveDays
        case sixDays
        case sevenDays
        case eightDays
        case nineDays
        case tenDays
        case elevenDays
        case twelveDays
        case thirteenDays
        case fourteenDays
        case fifteenDays
        case sixteenDays
    }
    
}

private extension String {
    var urlEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}
