//
//  AConvert.swift
//  Aquarius
//
//  Created by SONG JIN on 2022/9/29.
//

import UIKit
import Foundation

open class AConvert: NSObject {
    //MARK: - UIImage
    public func convert_DataToImage(data: Data) -> UIImage? {
        return UIImage(data: data)
    }
    //MARK: - Data
    public func convert_ImageToJPEGData(image: UIImage) -> Data? {
        return image.jpegData(compressionQuality: 1)
    }
    
    public func convert_ImageToPNGData(image: UIImage) -> Data? {
        return image.pngData()
    }
}
