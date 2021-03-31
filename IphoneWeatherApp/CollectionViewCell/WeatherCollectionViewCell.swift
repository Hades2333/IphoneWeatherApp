//
//  WeatherCollectionViewCell.swift
//  IphoneWeatherApp
//
//  Created by Hellizar on 31.03.21.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {

    static let identifier = "WeatherCollectionViewCell"

    static func nib() -> UINib {
        return UINib(nibName: "WeatherCollectionViewCell", bundle: nil)
    }

    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var tempLabel: UILabel!

    func configure(with model: Current) {
        self.tempLabel.text = "\(model.temp)"
        self.iconImageView.contentMode = .scaleAspectFit
        self.iconImageView.load(string: model.weather[0].icon)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
