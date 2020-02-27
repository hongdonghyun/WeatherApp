//
//  CustomLabel.swift
//  WeatherForecast
//
//  Created by Hongdonghyun on 2020/02/27.
//  Copyright © 2020 hong3. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAttr()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAttr() {
        self.textColor = .white
    }
}
