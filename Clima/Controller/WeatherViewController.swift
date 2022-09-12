import UIKit
import CoreLocation
class WeatherViewController: UIViewController {


    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    // получаем доступ к WeatherManager
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
//его необходимо использовать перед requestLocation()
        locationManager.delegate = self
        //  метод будет использован для запроса на разрешение вашего местоположения (всегда, при исп приложения)
        locationManager.requestWhenInUseAuthorization()
        //  метод будет использован для запроса на разрешение вашего местоположения однократно через делегат
        locationManager.requestLocation()

        //разрешаем передачу данных в WeatherManager
        weatherManager.delegate = self
        searchTextField.delegate = self

    }

    @IBAction func pressedLocation(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}


//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {

    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true) //прячет клавиатуру
        print(searchTextField.text!)
    }

    //Спрашивает делегата, следует ли обрабатывать нажатие кнопки Return(GO) для текстового поля.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)//прячет клавиатуру
        print(searchTextField.text!)
        return true
    }
    //Спрашивает делегата, стоит ли прекращать редактирование в указанном текстовом поле
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }

    // удаляет текст после ввода
    func textFieldDidEndEditing(_ textField: UITextField) {

        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
    // получаем доступ к методам в WeatherManager
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        // для обновление данных в фоновом или основном потоке
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)

            self.cityLabel.text = weather.cityName
        }
    }

    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.startUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude

            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


