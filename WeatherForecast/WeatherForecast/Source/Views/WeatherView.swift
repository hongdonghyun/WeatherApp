//
//  WeatherView.swift
//  WeatherForecast
//
//  Created by Hongdonghyun on 2020/02/27.
//  Copyright © 2020 hong3. All rights reserved.
//

import UIKit

class WeatherView: UIView {
    let weatherTableView = WeatherTableView()
    let imageView = BackgroundImageView(image: UIImage())
    lazy var blurView: UIVisualEffectView = {
        let effectView = UIVisualEffectView(frame: self.bounds)
        effectView.effect = UIBlurEffect(style: .dark)
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        effectView.alpha = 0
        return effectView
    }()
    
    let titleView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = CustomLabel()
        return label
    }()
    
    let titleTimeLabel: UILabel = {
        let label = CustomLabel()
        return label
    }()
    
    let refreshButton: UIButton = {
        let button = UIButton()
        button.setTitle("↻", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .title1)
        return button
    }()
    
    var imageViewCenterConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


extension WeatherView {
    private func setupUI() {
        let safeArea = self.safeAreaLayoutGuide
        
        [imageView, titleView, weatherTableView].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [blurView].forEach {
            imageView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [titleLabel, titleTimeLabel, refreshButton].forEach {
            titleView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        imageViewCenterConstraint = imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            titleView.heightAnchor.constraint(equalToConstant: 45),
            
            imageViewCenterConstraint,
            imageView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.5),
            imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1),
            
            blurView.topAnchor.constraint(equalTo: self.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            weatherTableView.topAnchor.constraint(equalTo: titleView.bottomAnchor),
            weatherTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            weatherTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            weatherTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: titleView.topAnchor),
            
            titleTimeLabel.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
            titleTimeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            
            refreshButton.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            refreshButton.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -20)
        ])
    }
}


