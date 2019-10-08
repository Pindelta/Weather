//
//  ViewController.swift
//  Weather
//
//  Created by Osmani Perez on 9/8/19.
//  Copyright © 2019 Osmani Perez. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {

    // Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let FORECAST_URL = "http://pro.openweathermap.org/data/2.5/forecast/hourly"
    let APP_ID = "b50e2f9aef437aff616951d7e312a4ab"
    
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherIconView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func getWeatherData(url: String, parameters: [String : String]){
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON{
            response in
            if response.result.isSuccess{
                let weatherJSON: JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
            }
            else{
                print("Error \(String(describing: response.result.error))")
                self.locationLabel.text = "Connection Issues"
            }
        }
    }
    
    func updateWeatherData(json: JSON){
        if let tempResult = json["main"]["temp"].double {
            weatherDataModel.temperature = Int((tempResult - 273.15)*(9/5) + 32)
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            updateUIWithWeatherData()
        }
        else{
            locationLabel.text = "Weather Unavailable"
        }
    }
    
    func updateUIWithWeatherData() {
        locationLabel.text = weatherDataModel.city
        temperatureLabel.text = "\(weatherDataModel.temperature)°"
        weatherIconView.image = UIImage(named: weatherDataModel.weatherIconName)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if(location.horizontalAccuracy > 0){
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params: [String : String] = ["lat" : latitude, "lon" : longitude , "appid" : APP_ID]
            
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        locationLabel.text = "Location Unavailable"
    }
    
    func userEnteredCityName(city: String) {
        let params : [String : String] = ["q" : city, "appid" : APP_ID]
        getWeatherData(url: WEATHER_URL, parameters: params)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let destingationVC = segue.destination as! ChangeWeatherViewController
            destingationVC.delegate = self
        }
    }
    
}

