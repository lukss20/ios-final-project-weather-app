//
//  ViewController.swift
//  luchit22weatherApp
//
//  Created by lukss on 30.01.26.
//



import UIKit
import CoreLocation

class ViewController: BaseWeatherViewController {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cloudsLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!

    override func viewDidLoad() {
        self.commonBlurView = blurView
        self.commonActivityIndicator = activityIndicator
        self.commonErrorView = errorView
        self.commonErrorLabel = errorLabel
        
        super.viewDidLoad()
        startLocationUpdate()
    }

    override func fetchData(lat: Double, lon: Double) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&units=metric&appid=\(apiKey)"
        
        makeRequest(url: urlString) { [weak self] (data: WeatherResponse) in
            self?.updateUI(with: data)
        }
    }

    private func updateUI(with data: WeatherResponse) {
        cityLabel.text = data.name
        tempLabel.text = "\(Int(data.main.temp))°C"
        descriptionLabel.text = data.weather.first?.description.capitalized
        cloudsLabel.text = "\(data.clouds.all)%"
        humidityLabel.text = "\(data.main.humidity)%"
        pressureLabel.text = "\(data.main.pressure) hPa"
        windSpeedLabel.text = "\(data.wind.speed) m/s"
        let directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
        let index = Int((data.wind.deg + 23) / 45) & 7
        windDirectionLabel.text = directions[index]
        if let iconCode = data.weather.first?.icon {
            weatherImageView.image = UIImage(named: mapIcon(iconCode))
        }
    }
    
    @IBAction func refreshTapped(_ sender: UIBarButtonItem) {
        startLocationUpdate()
    }
    
    @IBAction func retryTapped(_ sender: UIButton) {
        startLocationUpdate()
    }
    
    @IBAction func shareTapped(_ sender: UIBarButtonItem) {
        let text = "Weather in \(cityLabel.text ?? ""): \(tempLabel.text ?? "")"
        let vc = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(vc, animated: true)
    }
}
