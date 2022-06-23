//
//  WeatherTableViewCell.swift
//  WeatherMap
//
//  Created by Dylan Nguyen on 23/06/2022.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var mainLabel: UILabel!
    @IBOutlet private weak var maxTempLabel: UILabel!
    @IBOutlet private weak var minTempLabel: UILabel!
    @IBOutlet private weak var mainStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainStackView.layer.cornerRadius = 4
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        timeLabel.text = ""
        mainLabel.text = ""
        maxTempLabel.text = ""
        minTempLabel.text = ""
    }
    
    func setupData(data: List) {
        timeLabel.text = convertDateTime(time: data.dtTxt)
        mainLabel.text = data.weather?.first?.main ?? ""
        maxTempLabel.text = "\(String(format: "%.1f", data.main?.tempMax ?? 0))°K"
        minTempLabel.text = "\(String(format: "%.1f", data.main?.tempMin ?? 0))°K"
    }
    
    func convertDateTime(time: String?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: time ?? "") ?? Date()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.string(from: date)
    }
    
}
