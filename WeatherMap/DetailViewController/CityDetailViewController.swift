//
//  CityDetailViewController.swift
//  WeatherMap
//
//  Created by DylanNguyen on 23/06/2022.
//

import UIKit

class CityDetailViewController: UIViewController {

    @IBOutlet private weak var statusImageView: UIImageView!
    @IBOutlet private weak var maxTempLabel: UILabel!
    @IBOutlet private weak var minTempLabel: UILabel!
    @IBOutlet private weak var mainTableView: UITableView!
    
    var listData: [List]?
    var currentWeather: WeatherBaseResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        if let currentWeather = currentWeather {
            switch currentWeather.weather?.first?.main?.lowercased() {
            case MainWeather.wind.rawValue:
                statusImageView.image = UIImage(named: "ic_windy")
            case MainWeather.clouds.rawValue:
                statusImageView.image = UIImage(named: "ic_clouds")
            case MainWeather.rain.rawValue:
                statusImageView.image = UIImage(named: "ic_rain")
            case MainWeather.snow.rawValue:
                statusImageView.image = UIImage(named: "ic_snow")
            default:
                statusImageView.image = UIImage(named: "ic_weather")
            }
            
            maxTempLabel.text = "Max Temperature: \(String(format: "%.1f", currentWeather.main?.tempMax ?? 0))°K"
            minTempLabel.text = "Min Temperature: \(String(format: "%.1f", currentWeather.main?.tempMin ?? 0))°K"
        }
        
        mainTableView.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "WeatherTableViewCell")
        mainTableView.delegate = self
        mainTableView.dataSource = self
    }

}
extension CityDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell") as? WeatherTableViewCell else { return UITableViewCell() }
        if let listData = listData {
            cell.setupData(data: listData[indexPath.row] )
        }
        return cell
    }
    
}
