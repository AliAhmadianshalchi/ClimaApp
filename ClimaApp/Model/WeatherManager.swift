//
//  WeatherManager.swift
//  ClimaApp
//
//  Created by Ali Ahmadian shalchi on 04/07/2020.
//  Copyright © 2020 Ali Ahmadian shalchi. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func updatedWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func failedWithError(error: Error)
}

struct WeatherManager {
    
     let weatherURL = "https://api.openweathermap.org/data/2.5/forecast?appid=2f0297ae6a44f55cc6fb3af51170ad79&units=metric"
//      "https://api.openweathermap.org/data/2.5/forecast?appid=2f0297ae6a44f55cc6fb3af51170ad79&units=metric"
//      "https://api.openweathermap.org/data/2.5/weather?appid=2f0297ae6a44f55cc6fb3af51170ad79&units=metric"
       var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        requestData(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        requestData(with: urlString)
    }
    
    func requestData(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, respone , error) in
                if error != nil {
                    self.delegate?.failedWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.updatedWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder =  JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.list[0].weather[0].id
            let temp = decodedData.list[0].main.temp
            let name = decodedData.city.name
            
            let weather = WeatherModel(conditionCode: id, cityName: name, temperature: temp)
            return weather
        } catch { 
            delegate?.failedWithError(error: error)
            return nil
        }
    }
}
