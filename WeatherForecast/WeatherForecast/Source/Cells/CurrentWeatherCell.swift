//
//  CurrentWeatherCell.swift
//  WeatherForecast
//
//  Created by Hongdonghyun on 2020/02/24.
//  Copyright © 2020 hong3. All rights reserved.
//

import UIKit

class CurrentWeatherCell: UITableViewCell {
    static let identifier: String = "CurrentWeatherCell"
    private enum UI {
        static let margin: CGFloat = 20
        static let imgWidth: CGFloat = 50
    }
    
    private let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let weatherLabel: UILabel = {
        let label = CustomLabel()
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private let minMaxTempLabel: UILabel = {
        let label = CustomLabel()
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private let tempLabel: UILabel = {
        let label = CustomLabel()
        label.font = .systemFont(ofSize: 120, weight: .ultraLight)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.backgroundColor = .clear
    }
    
    private func setupUI() {
        
        let safeArea = self.contentView.safeAreaLayoutGuide
        [tempLabel, minMaxTempLabel, weatherImageView, weatherLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            tempLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor,constant: -UI.margin),
            tempLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: UI.margin),
            
            minMaxTempLabel.bottomAnchor.constraint(equalTo: tempLabel.topAnchor),
            minMaxTempLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: UI.margin),
            
            weatherImageView.bottomAnchor.constraint(equalTo: minMaxTempLabel.topAnchor),
            weatherImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: UI.margin),
            weatherImageView.widthAnchor.constraint(equalToConstant: UI.imgWidth),
            weatherImageView.heightAnchor.constraint(equalToConstant: UI.imgWidth),
            
            weatherLabel.leadingAnchor.constraint(equalTo: weatherImageView.trailingAnchor),
            weatherLabel.bottomAnchor.constraint(equalTo: minMaxTempLabel.topAnchor),
            
        ])
        
    }
    
    func config(weather: CurrentWeather) {
        guard let weather = weather.weather.hourly.first else { return }
        let skyCode = weather.sky.code
        let skyName = weather.sky.name
        let tempCurrent = weather.temperature.tc
        let tempMax = weather.temperature.tmax
        let tempMin = weather.temperature.tmin
        
        self.weatherLabel.text = skyName
        self.weatherImageView.image = UIImage(named: skyCode) ?? UIImage(named: "SKY_O01")
        self.minMaxTempLabel.text = "⤓ \(stringDoubleRounded(string: tempMin, rounded: 1))°  ⤒\(stringDoubleRounded(string: tempMax, rounded: 1))°"
        self.tempLabel.text = "\(stringDoubleRounded(string: tempCurrent, rounded: 1))°"
    }
}
