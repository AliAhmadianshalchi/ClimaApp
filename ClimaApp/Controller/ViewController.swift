//
//  ViewController.swift
//  ClimaApp
//
//  Created by Ali Ahmadian shalchi on 04/07/2020.
//  Copyright © 2020 Ali Ahmadian shalchi. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    
    @IBOutlet weak var forcastTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var degreesLable: UILabel!
    @IBOutlet weak var weaatherConditionImage: UIImageView!
    
    let cellId = "cellId"
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    var weathers: [WeatherModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        searchTextField.delegate = self
        
        forcastTableView.delegate = self
        forcastTableView.dataSource = self
        
    }

    
  
}

extension ViewController: UITextFieldDelegate {
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        
        searchTextField.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "type a name"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        
        searchTextField.text = ""
        
    }
    
}

extension ViewController: WeatherManagerDelegate {
    
    func updatedWeather(_ weatherManager: WeatherManager, weather: [WeatherModel]) {
        DispatchQueue.main.async {
            
            self.degreesLable.text = weather[0].degreeString
            self.weaatherConditionImage.image = UIImage(systemName: weather[0].conditionName)
            self.cityNameLabel.text = weather[0].cityName
            
        }
        
    }
    
    func failedWithError(error: Error) {
        print(error)
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        
        locationManager.requestLocation()
        
    }
}

extension ViewController: UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return weathers.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? ForcastTableViewCell else { return UITableViewCell() }
        
        cell.dateLabel.text = weathers[indexPath.row].date
        cell.degreeLabel.text = weathers[indexPath.row].degreeString
        cell.weatherImage.image = UIImage(systemName: weathers[indexPath.row].conditionName)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Forcast for the next days:"
    }
    
    
}



