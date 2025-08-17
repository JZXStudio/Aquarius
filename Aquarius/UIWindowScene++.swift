//
//  UIWindowScene++.swift
//  Aquarius
//
//  Created by SONG JIN on 2024/12/30.
//
import UIKit
import Foundation

extension UIWindowScene {
    public func setInterfaceOrientation(_ orientation: UIInterfaceOrientation) {
        let orientationMask: UIInterfaceOrientationMask
        switch orientation {
        case .portrait:
            orientationMask = .portrait
        case .landscapeLeft:
            orientationMask = .landscapeLeft
        case .landscapeRight:
            orientationMask = .landscapeRight
        default:
            orientationMask = .allButUpsideDown
        }
            
        if #available(iOS 16.0, *) {
            let geometryPreferences = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: orientationMask)
            self.requestGeometryUpdate(geometryPreferences) { error in
                //print("Error requesting geometry update: \(error.localizedDescription)")
            }
        } else {
            UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
            UINavigationController.attemptRotationToDeviceOrientation()
        }
    }
}
