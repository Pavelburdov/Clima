//
//  WeatherModel.swift
//  Clima
//
//  Created by Pavel on 09.09.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
struct WeatherModel {
    let conditionID: Int
    let cityName: String
    let temperature: Double


    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }

    var conditionName: String {
        switch conditionID {
            case 200...232:
                return "cloud.bolt.rain"
            case 300...321:
                return "cloud.drizzle"
            case 500...531:
                return "cloud.rain"
            case 600...622:
                return "cloud.snow"
            case 701...781:
                return "cloud.fog"
            case 800:
                return "sun.max"
            case 801...804:
                return "smoke.fill"
            default:
                return "cloud"
        }
    }
}

