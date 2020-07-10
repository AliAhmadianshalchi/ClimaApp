//
//  WeatherData.swift
//  ClimaApp
//
//  Created by Ali Ahmadian shalchi on 04/07/2020.
//  Copyright © 2020 Ali Ahmadian shalchi. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let list: [List]
    let city: City
}

struct City: Codable {
    let name: String
}

struct List: Codable {
    let dt: Int
    let main: Main
    let weather: [Weather]
    let dt_txt: String
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}


