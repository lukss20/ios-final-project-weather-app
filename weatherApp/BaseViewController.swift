//
//  BaseViewController.swift
//  luchit22weatherApp
//
//  Created by lukss on 30.01.26.
//

import UIKit
import CoreLocation

class BaseWeatherViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    let apiKey = "0318bbfa9612a23b436d99411604f006"
    
    weak var commonBlurView: UIVisualEffectView?
    weak var commonActivityIndicator: UIActivityIndicatorView?
    weak var commonErrorView: UIView?
    weak var commonErrorLabel: UILabel?

 
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startLocationUpdate() {
        showLoading()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            fetchData(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showError(message: "Location error: \(error.localizedDescription)")
    }
    
    func fetchData(lat: Double, lon: Double) {
    }

    func makeRequest<T: Decodable>(url: String, completion: @escaping (T) -> Void) {
        guard let urlObj = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: urlObj) { [weak self] data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.showError(message: "Error: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    self?.hideLoading()
                    completion(decoded)
                } catch {
                    self?.showError(message: "Data parse error")
                }
            }
        }.resume()
    }
    
    func showLoading() {
        commonBlurView?.isHidden = false
        commonActivityIndicator?.startAnimating()
        commonErrorView?.isHidden = true
    }
    
    func hideLoading() {
        commonBlurView?.isHidden = true
        commonActivityIndicator?.stopAnimating()
        commonErrorView?.isHidden = true
    }
    
    func showError(message: String) {
        commonBlurView?.isHidden = true
        commonActivityIndicator?.stopAnimating()
        commonErrorView?.isHidden = false
        commonErrorLabel?.text = message
    }
    
    func mapIcon(_ icon: String) -> String {
        switch icon {
        case "01d": return "sunny"
        case "01n": return "moon"
        case "02d","02n","03d","03n","04d","04n": return "cloud"
        case "09d","09n","10d","10n": return "raining"
        case "11d","11n": return "storm"
        case "13d","13n": return "snow"
        case "50d","50n": return "fog"
        default: return "sunny"
        }
    }
}
