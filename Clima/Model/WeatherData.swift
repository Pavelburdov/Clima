//
//  WeatherData.swift
//  Clima
//
//  Created by Pavel on 08.09.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit

struct WeatherDate: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
}

struct Weather: Decodable {
    let id: Int
    let description: String
}
