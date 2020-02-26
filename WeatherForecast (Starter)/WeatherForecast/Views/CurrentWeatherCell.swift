//
//  CurrentWeatherCell.swift
//  WeatherForecast
//
//  Created by Hongdonghyun on 2020/02/24.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import UIKit

class CurrentWeatherCell: UITableViewCell {
    static let identifier:String = "CurrentWeatherCell"
    let leadingMargin: CGFloat = 20
    
    private let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let weatherLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    private let minMaxTempLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 100, weight: .thin)
        label.textColor = .white
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        self.backgroundColor = .clear
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let safeArea = self.contentView.safeAreaLayoutGuide
        [tempLabel, minMaxTempLabel, weatherImageView, weatherLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            tempLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor,constant: -20),
            tempLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: leadingMargin),
            
            minMaxTempLabel.bottomAnchor.constraint(equalTo: tempLabel.topAnchor),
            minMaxTempLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: leadingMargin),
            
            weatherImageView.bottomAnchor.constraint(equalTo: minMaxTempLabel.topAnchor),
            weatherImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: leadingMargin),
            weatherImageView.widthAnchor.constraint(equalToConstant: 50),
            weatherImageView.heightAnchor.constraint(equalToConstant: 50),
            
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
        self.minMaxTempLabel.text = "⤓ \(stringDoubleRounded(string: tempMin, indexing: 1))°  ⤒\(stringDoubleRounded(string: tempMax, indexing: 1))°"
        self.tempLabel.text = "\(stringDoubleRounded(string: tempCurrent, indexing: 1))°"
    }
}
