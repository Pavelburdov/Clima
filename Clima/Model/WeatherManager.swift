//
//  WeatherManager.swift
//  Clima
//
//  Created by Pavel on 22.08.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {

    let weatherURL =  "https://api.openweathermap.org/data/2.5/weather?appid=aea7447a6cf427ee91424acda7a4a5ea&units=metric"

    func fetchWeather(cityName: String) {
        
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
    }

    func performRequest(urlString: String) {
        //        1. Create URL - создаем url адрес
        if let url = URL(string: urlString) {// unwrapping url
        //        2. Create urlSession
            let session = URLSession(configuration: .default) // сетевой запрос похож на браузер
        //        3. Give the session task - даем нашему сеансу задание на подключение
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    parseJSON(weatherData: safeData)
//                    let dataString = String(data: safeData, encoding: .utf8)
//                    print(dataString)
                }
            }
        //        4. Start the task - запуск задачи
            task.resume()
        }
    }
    //    func handle(data: Data?, urlResponse: URLResponse?, error: Error?) {
    //        if error != nil {
    //            print(error!)
    //            return
    //        }
    //        if let safeData = data {
    //            let dataString = String(data: safeData, encoding: .utf8)
    //            print(dataString)
    //        }
    //    }

    func parseJSON(weatherData: Data) {

    }
}
