//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Giftbot on 2020/02/22.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    private let weatherTableView = WeatherTableView()
    private let imageView = BackgroundImageView(image: UIImage())
    private let blurView = BackgroundBlurView()
    private lazy var rightButton: UIBarButtonItem = {
        let icon = UIImage(systemName: "arrow.clockwise")
        let button = UIBarButtonItem(image: icon, style: .done, target: self, action: #selector(didTaprightBarItem(_:)))
        button.tintColor = .white
        return button
    }()
    
    private var currentWeather: CurrentWeather?
    private var shortTemp: [[String: String]] = []
    private var shortSky: [[String: String]] = []
    
    private var locationManager = CLLocationManager()
    private var imageViewCenterConstraint: NSLayoutConstraint!
    private var timeRelease: String = ""
    private var latestUpdateDate = Date(timeIntervalSinceNow: -10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkAuthorizationStatus()
        setup()
        setupUI()
    }
}

extension ViewController {
    private func startUpdatingLocation() {
        let status = CLLocationManager.authorizationStatus()
        guard status == .authorizedWhenInUse || status == .authorizedAlways else { return }
        guard CLLocationManager.locationServicesEnabled() else { return }
        locationManager.startUpdatingLocation()
    }
    
    func checkAuthorizationStatus() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            startUpdatingLocation()
        case .restricted, .denied: break
        @unknown default: break
        }
    }
    
    private func getAddress(location: CLLocation) {
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: Constants.localeKo)
        geocoder.reverseGeocodeLocation(location, preferredLocale: locale) { placemarks, error in
            guard error == nil else { return print(error!.localizedDescription) }
            guard let place = placemarks?.first else { return }
            let locality = place.locality ?? ""
            let subLocality = place.subLocality ?? ""
            let throughfare = place.thoroughfare ?? ""
            let address = locality + " " + (!subLocality.isEmpty ? subLocality : throughfare)
            
            DispatchQueue.main.async {
                self.navigationItem.title = address
            }
        }
    }
    
    private func getData() {
        RequestHelper.shared.request(method: .get, endPoint: .currentWeatherEndPoint) {
            if let jsonData = try? CurrentWeather.decode(from: $0) {
                self.currentWeather = jsonData
                DispatchQueue.main.async { [weak self] in
                    self?.changedBackgroundImage()
                    self?.weatherTableView.reloadData()
                }
                print("currentWeather reload")
                
            }
        }
        RequestHelper.shared.request(method: .get, endPoint: .shortTermforecast) {
            if let jsonData = try? ShortTermWeatherModel.decode(from: $0) {
                guard let timeRelease = jsonData.weather.forecast3Days.first?.timeRelease else { return }
                self.timeRelease = timeRelease
                if let _sky = jsonData.weather.forecast3Days.first?.fcst3Hour.sky {
                    let skySorted = _sky.filter{ $0.value != "" }.mapValues({ $0 }).sorted {
                        $0.key.getStrInInt() < $1.key.getStrInInt()
                    }
                    skySorted.forEach {
                        if $0.0.contains("code") { self.shortSky.append([$0.0: $0.1]) }
                    }
                }
                if let _temp = jsonData.weather.forecast3Days.first?.fcst3Hour.temperature {
                    let tempSorted = _temp.filter{ $0.value != "" }.mapValues({ $0 }).sorted {
                        $0.key.getStrInInt() < $1.key.getStrInInt()
                    }
                    tempSorted.forEach {
                        self.shortTemp.append([$0.0: $0.1])
                    }
                }
                DispatchQueue.main.async {
                    self.weatherTableView.reloadData()
                    print("shortTermforecast reload")
                }
            }
            
        }
    }
    
}

// MARK: - LocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        manager.stopUpdatingLocation()
        
        // 마지막요청후 2초가 지나야 작업실행
        let currentDate = Date()
        if abs(latestUpdateDate.timeIntervalSince(currentDate)) > 2 {
            getAddress(location: location)
            RequestHelper.shared.makeParam(location: location)
            getData()
            latestUpdateDate = currentDate
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return view.frame.height - view.safeAreaInsets.top
        default:
            return 100
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPosition = scrollView.contentOffset.y
        let blur = blurView.blurEffectView
        
        if 0 <= yPosition && yPosition < (scrollView.frame.maxY / 4) {
            imageViewCenterConstraint.constant = (yPosition / (scrollView.frame.maxY / 4) * 20).rounded(.up)
            blur.alpha = yPosition / (scrollView.frame.maxY / 2).rounded(.up)
            
        } else if 0 > yPosition  {
            blur.alpha = 0
            imageViewCenterConstraint.constant = 0
        }
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        var count = 0
        if currentWeather != nil { count = 1 }
        if !shortTemp.isEmpty { count = 2 }
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            guard let count = currentWeather?.weather.hourly.count else { return 0 }
            return count
            
        default:
            return shortTemp.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard
                let currentWeather = currentWeather,
                let cell = tableView.dequeueReusableCell(withIdentifier: CurrentWeatherCell.identifier, for: indexPath) as? CurrentWeatherCell
                else { return UITableViewCell() }
            
            cell.config(weather: currentWeather)
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ShortTermWeatherCell.identifier, for: indexPath) as? ShortTermWeatherCell
                else { return UITableViewCell() }
            
            cell.config(
                temp: shortTemp[indexPath.row],
                sky: shortSky[indexPath.row],
                time: timeRelease
            )
            return cell
        }
    }
    
    
}

// MARK: ACTIONS
extension ViewController {
    @objc func didTaprightBarItem(_ sender: UIBarButtonItem) { getData() }
}

// MARK: UI's
extension ViewController {
    private func changedBackgroundImage() {
        if let name = self.currentWeather?.weather.hourly.first?.sky.name {
            if name.contains("맑음") {
                self.imageView.image = UIImage(named: WeatherImages.sunny.rawValue)
            } else if name.contains("낙뢰") {
                self.imageView.image = UIImage(named: WeatherImages.lightning.rawValue)
            } else if name.contains("구름") {
                self.imageView.image = UIImage(named: WeatherImages.cloudy.rawValue)
            } else if name.contains("흐") || name.contains("비") {
                self.imageView.image = UIImage(named: WeatherImages.rainy.rawValue)
            }
        }
    }
    
    private func setup() {
        locationManager.delegate = self
        weatherTableView.dataSource = self
        weatherTableView.delegate = self
        weatherTableView.register(CurrentWeatherCell.self, forCellReuseIdentifier: CurrentWeatherCell.identifier)
        weatherTableView.register(ShortTermWeatherCell.self, forCellReuseIdentifier: ShortTermWeatherCell.identifier)
        
    }
    
    private func setupUI() {
        let safeArea = view.safeAreaLayoutGuide
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.rightBarButtonItem = rightButton
        view.addSubview(imageView)
        imageView.addSubview(blurView)
        view.addSubview(weatherTableView)
        
        [imageView, blurView, weatherTableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        imageViewCenterConstraint = imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        NSLayoutConstraint.activate([
            imageViewCenterConstraint,
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.5),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1),
            
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            weatherTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            weatherTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            weatherTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            weatherTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
}

