//
//  WeatherTableView.swift
//  WeatherForecast
//
//  Created by Hongdonghyun on 2020/02/24.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import UIKit

class WeatherTableView: UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.backgroundColor = .clear
        self.separatorStyle = .none
        self.allowsSelection = false
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        
    }
    
}
