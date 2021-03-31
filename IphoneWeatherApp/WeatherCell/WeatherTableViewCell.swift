//
//  WeatherTableViewCell.swift
//  IphoneWeatherApp
//
//  Created by Hellizar on 31.03.21.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var highTempLabel: UILabel!
    @IBOutlet var lowTempLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    static let identifier = "WeatherTableViewCell"

    static func nib() -> UINib {
        return UINib(nibName: "WeatherTableViewCell", bundle: nil)
    }

    func configure(with model: Daily) {
        self.highTempLabel.textAlignment = .center
        self.lowTempLabel.textAlignment = .center
        self.lowTempLabel.text = "\(Int(model.temp.min))°"
        self.highTempLabel.text = "\(Int(model.temp.max))°"
        self.dayLabel.text = String.init(milliseconds: model.dt)
        self.iconImageView.load(string: model.weather[0].icon)
    }
}
