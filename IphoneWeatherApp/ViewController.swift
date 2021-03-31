//
//  ViewController.swift
//  IphoneWeatherApp
//
//  Created by Hellizar on 31.03.21.
//

import UIKit
import CoreLocation

// TableView
// Custom cell: with collectionview
// API: request the data

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet var table: UITableView!

    var models = [Daily]()
    var hourlyModels = [Current]()

    let locationManager = CLLocationManager()

    var currentLocation: CLLocation?
    var current: Current?

    override func viewDidLoad() {
        super.viewDidLoad()

        table.register(HourlyTableViewCell.nib(),
                       forCellReuseIdentifier: HourlyTableViewCell.identifier)
        table.register(WeatherTableViewCell.nib(),
                       forCellReuseIdentifier: WeatherTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        view.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
        table.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
    }

    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func requestWeatherForLocation() {
        guard let currentLocation = currentLocation else {
            return
        }
        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude

        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&units=metric&exclude=minutely&appid=6b874494c7d6dcf106922ff8f8605c98"
        print(url)

        URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in

            guard let data = data, error == nil else {
                print("something went wrong")
                return
            }

            var json: Welcome?
            do {
                json = try JSONDecoder().decode(Welcome.self, from: data)
            } catch {
                fatalError("\(error)")
            }

            guard let result = json else {
                return
            }
            print(result.current.clouds)

            let entries = result.daily
            self.models.append(contentsOf: entries)

            let myCurrent = result.current
            self.current = myCurrent

            self.hourlyModels = result.hourly

            DispatchQueue.main.async { [weak self] in
                self?.table.reloadData()
                self?.table.tableHeaderView = self?.createTableHeader()
            }
        }.resume()
    }

    private func createTableHeader() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0,
                                              width: view.frame.size.width,
                                              height: view.frame.size.width))
        headerView.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)

        let locationLabel = UILabel(frame: CGRect(x: 10, y: 0,
                                                  width: view.frame.size.width-20,
                                                  height: view.frame.size.height/6))

        let summaryLabel = UILabel(frame: CGRect(x: 10, y: 10+locationLabel.frame.size.height,
                                                 width: view.frame.size.width-20,
                                                 height: view.frame.size.height/6))

        let tempLabel = UILabel(frame: CGRect(x: 10,
                                              y:20+locationLabel.frame.size.height+20+summaryLabel.frame.size.height,
                                              width: view.frame.size.width-20,
                                              height: view.frame.size.height/6))

        headerView.addSubview(locationLabel)
        headerView.addSubview(summaryLabel)
        headerView.addSubview(tempLabel)

        guard let currentWeather = self.current else {
            return UIView()
        }
        locationLabel.text = "Current Location"

        tempLabel.text = "\(currentWeather.temp)°"
        tempLabel.font = UIFont(name: "Helvetica-Bold", size: 32)

        //summaryLabel.text =


        summaryLabel.textAlignment = .center
        locationLabel.textAlignment = .center
        tempLabel.textAlignment = .center
        return headerView
    }

    //MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
        }
    }

    //MARK: - TableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell  = table.dequeueReusableCell(withIdentifier: HourlyTableViewCell.identifier, for: indexPath) as? HourlyTableViewCell else { fatalError("couldnt reuse TableViewCell") }
            cell.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
            cell.configure(with: hourlyModels)
            return cell
        }
        guard let cell  = table.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as? WeatherTableViewCell else { fatalError("couldnt reuse TableViewCell") }
        cell.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
        cell.configure(with: models[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}

// MARK: - Welcome
struct Welcome: Codable {
    let lat, lon: Double
    let timezone: String
    let timezoneOffset: Int
    let current: Current
    let hourly: [Current]
    let daily: [Daily]

    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case timezoneOffset = "timezone_offset"
        case current, hourly, daily
    }
}

// MARK: - Current
struct Current: Codable {
    let dt: Int
    let sunrise, sunset: Int?
    let temp, feelsLike: Double
    let pressure, humidity: Int
    let dewPoint, uvi: Double
    let clouds, visibility: Int
    let windSpeed: Double
    let windDeg: Int
    let weather: [Weather]
    let windGust, pop: Double?
    let rain: Rain?

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case uvi, clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather
        case windGust = "wind_gust"
        case pop, rain
    }
}

// MARK: - Rain
struct Rain: Codable {
    let the1H: Double

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main: Main
    let weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

enum Main: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case mist = "Mist"
    case rain = "Rain"
    case snow = "Snow"
    case drizzle = "Drizzle"
}

// MARK: - Daily
struct Daily: Codable {
    let dt, sunrise, sunset: Int
    let temp: Temp
    let feelsLike: FeelsLike
    let pressure, humidity: Int
    let dewPoint, windSpeed: Double
    let windDeg: Int
    let weather: [Weather]
    let clouds: Int
    let pop: Double
    let rain: Double?
    let uvi: Double

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather, clouds, pop, rain, uvi
    }
}

// MARK: - FeelsLike
struct FeelsLike: Codable {
    let day, night, eve, morn: Double
}

// MARK: - Temp
struct Temp: Codable {
    let day, min, max, night: Double
    let eve, morn: Double
}
