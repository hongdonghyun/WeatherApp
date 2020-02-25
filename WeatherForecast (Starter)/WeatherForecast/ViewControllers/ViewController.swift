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
    private let imageView = BackgroundImageView(image: UIImage(named: "sunny")!)
    private let blurView = BackgroundBlurView()
    private let tempArray = Array.init(repeating: "", count: 100)
    
    private var locationManager = CLLocationManager()
    private var currentWeather: CurrentWeather?
    private var lastContentOffset: CGFloat = 0
    private var imageViewCenterConstraint: NSLayoutConstraint!
    private var datas = ["currentCell", "ShortTerm"]
    private var nowDate: String = {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale(identifier: "ko")
        return dateFormatter.string(from: date)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkAuthorizationStatus()
        setup()
        setupUI()
    }
    
}

// MARK: SetupUI
extension ViewController {
    func setup() {
        locationManager.delegate = self
        weatherTableView.dataSource = self
        weatherTableView.delegate = self
        weatherTableView.register(CurrentWeatherCell.self, forCellReuseIdentifier: CurrentWeatherCell.identifier)
        weatherTableView.register(ShortTermWeatherCell.self, forCellReuseIdentifier: ShortTermWeatherCell.identifier)
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.title = nowDate
        view.addSubview(imageView)
        imageView.addSubview(blurView)
        view.addSubview(weatherTableView)
        
        [imageView, blurView, weatherTableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        imageViewCenterConstraint = imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        NSLayoutConstraint.activate([
//            imageView.topAnchor.constraint(equalTo: view.topAnchor),
//            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageViewCenterConstraint,
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.5),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1),
            
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            weatherTableView.topAnchor.constraint(equalTo: view.topAnchor),
            weatherTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            weatherTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension ViewController {
    func checkAuthorizationStatus() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            fallthrough
        case .authorizedAlways:
            startUpdatingLocation()
        case .restricted, .denied: break
        @unknown default: break
        }
    }
    
    func startUpdatingLocation() {
        let status = CLLocationManager.authorizationStatus()
        guard status == .authorizedWhenInUse || status == .authorizedAlways else { return }
        guard CLLocationManager.locationServicesEnabled() else { return }
        locationManager.startUpdatingLocation()
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return view.frame.height
        default:
            return 45
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPosition = scrollView.contentOffset.y
        let blur = blurView.blurEffectView
        
        if 0 <= yPosition && yPosition < (scrollView.frame.maxY / 4) {
            imageViewCenterConstraint.constant = (yPosition / (scrollView.frame.maxY / 4) * 10).rounded(.up)
            blur.alpha = yPosition / (scrollView.frame.maxY / 2).rounded(.up)
            
        } else if 0 > yPosition  {
            blur.alpha = 0
            imageViewCenterConstraint.constant = 0
        }
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        datas.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: CurrentWeatherCell.identifier, for: indexPath)
            cell.textLabel?.text = "현재날씨 Cell"
            return cell
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: ShortTermWeatherCell.identifier, for: indexPath)
            cell.textLabel?.text = "단기예보 Cell"
            return cell
        }
        return cell
    }
    
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            print("인증됨")
            //            RequestHelper.shared.makeParam(location: locationManager.location)
            //            RequestHelper.shared.request(method: .get, endPoint: .currentWeatherEndPoint) {
            //                if let jsonData = try? JSONDecoder().decode(CurrentWeather.self, from: $0) {
            //                    print(jsonData)
            //                }
        //            }
        default:
            print("인증실패")
        }
    }
}
