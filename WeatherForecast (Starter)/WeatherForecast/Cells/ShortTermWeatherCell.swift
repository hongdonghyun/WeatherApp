//
//  ShortTermWeatherCell.swift
//  WeatherForecast
//
//  Created by Hongdonghyun on 2020/02/24.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import UIKit

class ShortTermWeatherCell: UITableViewCell {
    static let identifier = "ShortTermCell"
    
    private enum UI {
        static let margin: CGFloat = 10
        static let multiple: CGFloat = 0.5
        static let imgWidth: CGFloat = 40
    }
    
    let termDateLabel: UILabel = {
        let label = CustomLabel()
        return label
    }()
    
    let termTimeLabel: UILabel = {
        let label = CustomLabel()
        return label
    }()
    
    let weatherImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "SKY_O01")
        return imageView
    }()
    
    let underLine: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    let degreeLabel: UILabel = {
        let label = CustomLabel()
        label.font = .systemFont(ofSize: 30, weight: .thin)
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
        
        [termDateLabel, termTimeLabel, weatherImage, underLine, degreeLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            termDateLabel.topAnchor.constraint(equalTo: safeArea.topAnchor),
            termDateLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: UI.margin),
            termDateLabel.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: UI.multiple),
            
            termTimeLabel.topAnchor.constraint(equalTo: termDateLabel.bottomAnchor),
            termTimeLabel.centerXAnchor.constraint(equalTo: termDateLabel.centerXAnchor),
            termTimeLabel.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: UI.multiple),
            
            weatherImage.leadingAnchor.constraint(equalTo: termTimeLabel.trailingAnchor),
            weatherImage.centerYAnchor.constraint(equalTo: termDateLabel.bottomAnchor),
            weatherImage.widthAnchor.constraint(equalToConstant: UI.imgWidth),
            weatherImage.heightAnchor.constraint(equalToConstant: UI.imgWidth),
            
            underLine.topAnchor.constraint(equalTo: weatherImage.bottomAnchor, constant: UI.margin),
            underLine.centerXAnchor.constraint(equalTo: weatherImage.centerXAnchor),
            underLine.widthAnchor.constraint(equalTo: weatherImage.widthAnchor),
            underLine.heightAnchor.constraint(equalToConstant: 1),
            
            degreeLabel.centerYAnchor.constraint(equalTo: weatherImage.centerYAnchor),
            degreeLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -UI.margin),
        ])
    }
    
    func config(temp: [String: String], sky: [String: String], time: String) {
        guard
            let tempKey = temp.keys.first,
            let skyKey = sky.keys.first,
            let tempValue = temp[tempKey],
            let skyValue = sky[skyKey],
            !tempKey.isEmpty,
            !skyKey.isEmpty
            else { return }
        
        let addTime = Int(tempKey.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())!
        let strDate = strDateAddingInterval(dateString: time, interval: addTime).split(separator: "/")
        
        weatherImage.image = UIImage(named: skyValue.replacingOccurrences(of: "_S", with: "_O"))!
        degreeLabel.text = "\(stringDoubleRounded(string: tempValue, rounded: 0))°"
        termDateLabel.text = "\(strDate[0])"
        termTimeLabel.text = "\(strDate[1])"
        
    }
    
}
