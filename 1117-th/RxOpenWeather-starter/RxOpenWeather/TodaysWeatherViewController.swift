//
//  TodaysWeatherViewController.swift
//  RxOpenWeather
//
//  Created by Nikolas Burk on 17/11/16.
//  Copyright © 2016 Nikolas Burk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TodaysWeatherViewController: UIViewController {
    
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var forecastButton: UIButton!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var avgTemperatureLabel: UILabel!
    
    let openWeatherAPI = RxOpenWeatherMapAPI()
    
    var disposeBag = DisposeBag()
    
    var forecast: Forecast?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRx()
    }
    
    func setupRx(){
        let cityFieldObservable: Observable<Weather?> = cityTextField
                                                        .rx
                                                        .text
                                                        .asObservable()
                                                        .throttle(0.75, scheduler: MainScheduler() as SchedulerType)
                                                        .distinctUntilChanged({
                                                            return $0 == $1
                                                        })
                                                        .flatMapLatest {
                                                            return self.openWeatherAPI.createWeatherObservable(for: $0 ?? "")
                                                        }
        
        cityFieldObservable
            .map{
                return $0?.description ?? ""
            }
            .bindTo(descriptionLabel.rx.text)
            .addDisposableTo(disposeBag)
    
        cityFieldObservable
            .map{
                return String(describing: $0?.tempMin ?? 0)
            }
            .bindTo(minTemperatureLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        cityFieldObservable
            .map{
                return String(describing: $0?.tempMax ?? 0)
            }
            .bindTo(maxTemperatureLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        cityFieldObservable
            .map{
                return String(describing: $0?.tempAverage ?? 0)
            }
            .bindTo(avgTemperatureLabel.rx.text)
            .addDisposableTo(disposeBag)
    }
 
    @IBAction func forecastButtonPressed(_ sender: Any) {
        openWeatherAPI.getWeatherForecast(location: cityTextField.text ?? "", temperatureUnit: .fahrenheit, dayCount: RxOpenWeatherMapAPI.ForecastPeriod.tenDays.rawValue) { (forecast, error) in
           
            if let error = error{
                print(error)
            }else{
                self.forecast = forecast
                OperationQueue.main.addOperation {
                    self.performSegue(withIdentifier: "ToForecast", sender: self)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ForecastTableViewController
        
        vc.forecast = self.forecast
    }
}

