//
//  ExtensionUIColor.swift
//  Notes_TT
//
//  Created by Александр on 24.03.16.
//  Copyright © 2016 Khlebnikov. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func pastelRainbowColor(withNumber number: Int, frequency: Double = 0.32) -> UIColor {
        let center = 200.0
        let amplitude = 75.0
        let r = CGFloat(sin(frequency*Double(number))*amplitude+center)
        let g = CGFloat(sin(frequency*Double(number)+2)*amplitude+center)
        let b = CGFloat(sin(frequency*Double(number)+4)*amplitude+center)
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}