//
//  BackgroundBlurView.swift
//  WeatherForecast
//
//  Created by Hongdonghyun on 2020/02/24.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import UIKit

class BackgroundBlurView: UIView {
    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
    lazy var blurEffectView = UIVisualEffectView(effect: blurEffect)
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0
        self.addSubview(blurEffectView)
    }
}
