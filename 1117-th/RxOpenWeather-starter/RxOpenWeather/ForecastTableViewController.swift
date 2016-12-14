//
//  ForecastTableViewController.swift
//  RxOpenWeather
//
//  Created by Nikolas Burk on 17/11/16.
//  Copyright © 2016 Nikolas Burk. All rights reserved.
//

import UIKit

class ForecastTableViewController: UITableViewController {
  
    var forecast: Forecast! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return forecast.forecast.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! WeatherCell
        
        let weather = forecast.forecast[indexPath.row]
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        let tempRange: String = String(weather.tempMin) + " - " + String(weather.tempMax)
        
        cell.setLabels(date: formatter.string(from: weather.date as Date), tempRange: tempRange, description: weather.description)
        
        return cell
    }
}
