//
//  ForecastViewController.swift
//  luchit22weatherApp
//
//  Created by lukss on 30.01.26.
//

import UIKit
import CoreLocation

class ForecastViewController: BaseWeatherViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    var groupedByDate: [String: [ForecastItem]] = [:]
    var sortedDates: [String] = []

    override func viewDidLoad() {
        self.commonBlurView = blurView
        self.commonActivityIndicator = activityIndicator
        self.commonErrorView = errorView
        self.commonErrorLabel = errorLabel
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        startLocationUpdate()
    }

    override func fetchData(lat: Double, lon: Double) {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&units=metric&appid=\(apiKey)"
        
        makeRequest(url: urlString) { [weak self] (data: ForecastResponse) in
            self?.processForecast(data.list)
        }
    }

    private func processForecast(_ list: [ForecastItem]) {
        groupedByDate = Dictionary(grouping: list) { item in
            let date = Date(timeIntervalSince1970: item.dt)
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE, dd MMM"
            return formatter.string(from: date)
        }
        sortedDates = groupedByDate.keys.sorted(by: <)
        tableView.reloadData()
    }
    
    @IBAction func refreshTapped(_ sender: UIBarButtonItem) {
        startLocationUpdate()
    }
    
    @IBAction func retryTapped(_ sender: UIButton) {
        startLocationUpdate()
    }
}

extension ForecastViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedDates.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = sortedDates[section]
        return groupedByDate[key]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sortedDates[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath)
        let key = sortedDates[indexPath.section]
        
        if let item = groupedByDate[key]?[indexPath.row] {
            let date = Date(timeIntervalSince1970: item.dt)
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            let timeString = formatter.string(from: date)
            let descString = item.weather.first?.description.capitalized ?? ""
            cell.textLabel?.numberOfLines = 2
            cell.textLabel?.text = "\(timeString)\n\(descString)"
            cell.detailTextLabel?.text = "\(Int(item.main.temp))°C"
            cell.detailTextLabel?.textColor = .blue
            cell.detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            if let iconCode = item.weather.first?.icon {
                cell.imageView?.image = UIImage(named: mapIcon(iconCode))
            }
        }
        return cell
    }
}
