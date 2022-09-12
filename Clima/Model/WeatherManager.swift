//
//  WeatherManager.swift
//  Clima
//
//  Created by Pavel on 22.08.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

// создаем протокол у отправителя
protocol WeatherManagerDelegate {
// метод для обновления модели
func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)

// метод для фиксации багов
func didFailWithError(error: Error) 
}


struct WeatherManager {

    let weatherURL =  "https://api.openweathermap.org/data/2.5/weather?appid=aea7447a6cf427ee91424acda7a4a5ea&units=metric"
// создаем делегат который принимает протокол на стороне отправителя
    var delegate: WeatherManagerDelegate?

    func fetchWeather(cityName: String) {
        
        let urlString = "\(weatherURL)&q=\(cityName)"
        //упростим в вызове функции выражение теперь оно будет читаться с внешним параметром with - "со строкой UКД"
        performRequest(with: urlString)
    }

    // добавим метод с тем же названием fetchWeather, CLLocationDegrees  значение широты и долготы в градусах Double
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {

        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        //упростим в вызове функции выражение теперь оно будет читаться с внешним параметром with - "со строкой URL"
        performRequest(with: urlString)
    }
// добавим в метод для получения данных по URL внешний параметр with - для упрощения чтения
    func performRequest(with urlString: String) {
        //        1. Create URL - создаем url адрес
        if let url = URL(string: urlString) {// unwrapping url
        //        2. Create urlSession
            let session = URLSession(configuration: .default) // сетевой запрос похож на браузер
        //        3. Give the session task - даем нашему сеансу задание на подключение
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    // создаем объект погоды из модели
                    if let weather = self.parseJSON(weatherData: safeData) {
//                        let weatherVC = WeatherViewController()
//                        weatherVC.didUpdateWeather(weather)
                        // создаем делегат вызывая метод на стороне отправителя
                        delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
        //        4. Start the task - запуск задачи
            task.resume()
        }
    }
// метод для обработки JSON из WeatherModel (необходимо вывод данных сделать опциональным)
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()

        do { //блок позволяющий нам перехватить ошибку (используется вместе с try и catch)
            let decodeData = try decoder.decode(WeatherDate.self, from: weatherData)
            let id = decodeData.weather[0].id
            let temp = decodeData.main.temp
            let name = decodeData.name
            
// создаем объект погоды из модели
            let weather = WeatherModel(conditionID: id, cityName: name, temperature: temp)

            // возврат объекта
            return weather

        } catch {
            delegate?.didFailWithError(error: error)
            //необходимо вернуть nil если в получении модели произойдет ошибка
            return nil
        }
    }
}

