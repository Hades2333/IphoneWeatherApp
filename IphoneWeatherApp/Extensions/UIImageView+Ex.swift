//
//  UIImageView+Ex.swift
//  IphoneWeatherApp
//
//  Created by Hellizar on 31.03.21.
//

import UIKit

extension UIImageView {
    func load(string: String) {
        guard let url = URL(string: "https://openweathermap.org/img/wn/\(string).png") else {
            self.image = UIImage(named: "clear")
            return
        }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
