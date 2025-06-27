//
//  AColor.swift
//  Aquarius
//
//  Created by SONG JIN on 2024/9/13.
//

import UIKit
import Foundation

open class AColor: NSObject {
    public static let shared = AColor()
    //MARK: - Color
    public static var color: UIColor {
        get {
            return UIColor()
        }
    }
    
    public static var blackColor: UIColor {
        get {
            return .black
        }
    }
    
    public static var blackCGColor: CGColor {
        get {
            let color: UIColor = .black
            return color.cgColor
        }
    }
    
    public static var whiteColor: UIColor {
        get {
            return .white
        }
    }
    
    public static var whiteCGColor: CGColor {
        get {
            let color: UIColor = .white
            return color.cgColor
        }
    }
    
    public static var darkGrayColor: UIColor {
        get {
            return .darkGray
        }
    }
    
    public static var darkGrayCGColor: CGColor {
        get {
            let color: UIColor = .darkGray
            return color.cgColor
        }
    }
    
    public static var lightGrayColor: UIColor {
        get {
            return .lightGray
        }
    }
    
    public static var lightGrayCGColor: CGColor {
        get {
            let color: UIColor = .lightGray
            return color.cgColor
        }
    }
    
    public static var grayColor: UIColor {
        get {
            return .gray
        }
    }
    
    public static var grayCGColor: CGColor {
        get {
            let color: UIColor = .gray
            return color.cgColor
        }
    }
    
    public static var redColor: UIColor {
        get {
            return .red
        }
    }
    
    public static var redCGColor: CGColor {
        get {
            let color: UIColor = .red
            return color.cgColor
        }
    }
    
    public static var greenColor: UIColor {
        get {
            return .green
        }
    }
    
    public static var greenCGColor: CGColor {
        get {
            let color: UIColor = .green
            return color.cgColor
        }
    }
    
    public static var blueColor: UIColor {
        get {
            return .blue
        }
    }
    
    public static var blueCGColor: CGColor {
        get {
            let color: UIColor = .blue
            return color.cgColor
        }
    }
    
    public static var cyanColor: UIColor {
        get {
            return .cyan
        }
    }
    
    public static var cyanCGColor: CGColor {
        get {
            let color: UIColor = .cyan
            return color.cgColor
        }
    }
    
    public static var yellowColor: UIColor {
        get {
            return .yellow
        }
    }
    
    public static var yellowCGColor: CGColor {
        get {
            let color: UIColor = .yellow
            return color.cgColor
        }
    }
    
    public static var magentaColor: UIColor {
        get {
            return .magenta
        }
    }
    
    public static var magentaCGColor: CGColor {
        get {
            let color: UIColor = .magenta
            return color.cgColor
        }
    }
    
    public static var orangeColor: UIColor {
        get {
            return .orange
        }
    }
    
    public static var orangeCGColor: CGColor {
        get {
            let color: UIColor = .orange
            return color.cgColor
        }
    }
    
    public static var purpleColor: UIColor {
        get {
            return .purple
        }
    }
    
    public static var purpleCGColor: CGColor {
        get {
            let color: UIColor = .purple
            return color.cgColor
        }
    }
    
    public static var brownColor: UIColor {
        get {
            return .brown
        }
    }
    
    public static var brownCGColor: CGColor {
        get {
            let color: UIColor = .brown
            return color.cgColor
        }
    }
    
    public static var clearColor: UIColor {
        get {
            return .clear
        }
    }
    
    public static var clearCGColor: CGColor {
        get {
            let color: UIColor = .clear
            return color.cgColor
        }
    }
}
