//
//  CAGradientLayer+Ext.swift
//  PocketWeather
//
//  Created by anthony byrd on 5/12/24.
//

import UIKit

extension CAGradientLayer {
    static func gradientLayer(in frame: CGRect) -> Self {
        let layer = Self()
        layer.colors = colors()
        layer.frame = frame
        
        return layer
    }
    
    private static func colors() -> [CGColor] {
        let beginColor: CGColor = UIColor(named: "gradientBeginColor")!.cgColor
        let endColor: CGColor = UIColor(named: "gradientEndColor")!.cgColor
        
        return [beginColor, endColor]
    }
}
