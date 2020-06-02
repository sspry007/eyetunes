//
//  UIFont+Extension.swift
//  eyetunes
//
//  Created by Steven Spry on 6/1/20.
//  Copyright © 2020 Steven Spry. All rights reserved.
//

import UIKit

extension UIFont {
    static func albumFont() -> UIFont {
        return UIFont(name: "Avenir-Heavy", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .heavy)
    }
    
    static func artistFont() -> UIFont {
        return UIFont(name: "Avenir-Medium", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .medium)
    }
    
    static func buttonTitleFont() -> UIFont {
        return UIFont(name: "Avenir-Medium", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .medium)
    }

    static func normalFont() -> UIFont {
        return UIFont(name: "Avenir-Book", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .regular)
    }

    static func mouseTypeFont() -> UIFont {
        return UIFont(name: "Avenir-LightOblique", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .light)
    }
}

