//
//  UIImage++.swift
//  Aquarius
//
//  Created by SONG JIN on 2022/9/15.
//

import UIKit
import Foundation

extension UIImage {
    //提供的 UIImage 进行裁剪，使其成为一个完美的正方形
    public var squared: UIImage? {
        let originalWidth  = size.width
        let originalHeight = size.height
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
        var edge: CGFloat = 0.0
            
        if (originalWidth > originalHeight) {
            // landscape
            edge = originalHeight
            x = (originalWidth - edge) / 2.0
            y = 0.0
        } else if (originalHeight > originalWidth) {
            // portrait
            edge = originalWidth
            x = 0.0
            y = (originalHeight - originalWidth) / 2.0
        } else {
            // square
            edge = originalWidth
        }
            
        let cropSquare = CGRect(x: x, y: y, width: edge, height: edge)
        guard let imageRef = cgImage?.cropping(to: cropSquare) else { return nil }
            
        return UIImage(cgImage: imageRef, scale: scale, orientation: imageOrientation)
    }
    
    @discardableResult
    public func imageWithColor(tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)

        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0);
        context.setBlendMode(.normal)

        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height) as CGRect
        context.clip(to: rect, mask: self.cgImage!)
        tintColor.setFill()
        context.fill(rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return newImage
    }
    
    public func imageWithTintColor(_ color: UIColor, blendMode: CGBlendMode = .normal) -> UIImage? {
        
        guard self.size.height > 0 && self.size.width > 0 else {
            return nil
        }
        
        let rect = CGRect(origin: .zero, size: self.size)
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(blendMode)
        context.clip(to: rect, mask: self.cgImage!)
        color.setFill()
        context.fill(rect)
        
        let coloredImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return coloredImage
      
    }
    
    public func imageWithImage(scaledToSize newSize:CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        self.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    public func toJPEGData() -> Data? {
        return jpegData(compressionQuality: 1)
    }
    
    public func toPNGData() -> Data? {
        return pngData()
    }
    //保存图片到本地
    //let path: String = NSHomeDirectory().appending("/Documents/").appending("\(String.random()).png") as String
    public func savePNGData(path: String) {
        try? self.pngData()?.write(to: URL(fileURLWithPath: path))
    }
    
    public func savePNGDataInThread(path: String, success: @escaping(() -> Void)) {
        DispatchQueue.global().async { [weak self] in
            self?.savePNGData(path: path)
        }
        
        DispatchGroup().notify(queue: DispatchQueue.main) {
            success()
        }
    }
    
    public func saveJPEGData(path: String, quality: CGFloat = 1.0) {
        try? self.jpegData(compressionQuality: quality)?.write(to: URL(fileURLWithPath: path))
    }
    //确保 UIImage 图片不超过给定的尺寸大小
    public func resized(maxSize: CGFloat) -> UIImage? {
        let scale: CGFloat
        if size.width > size.height {
            scale = maxSize / size.width
        } else {
            scale = maxSize / size.height
        }
            
        let newWidth = size.width * scale
        let newHeight = size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    //压缩图片，参数是kb
    public func compressImage(maxLength: Int) -> Data {
        let tempMaxLength: Int = maxLength
        var compression: CGFloat = 1
        guard var data = self.jpegData(compressionQuality: compression), data.count > tempMaxLength else {
            return self.jpegData(compressionQuality: compression)!
        }
        
        var max: CGFloat = 1
        var min: CGFloat = 0
        for _ in 0..<6 {
            compression = (max + min) / 2
            data = self.jpegData(compressionQuality: compression)!
            if CGFloat(data.count) < CGFloat(tempMaxLength) * 0.9 {
                min = compression
            } else if data.count > tempMaxLength {
                max = compression
            } else {
                break
            }
        }
        var resultImage: UIImage = UIImage(data: data)!
        if data.count < tempMaxLength { return data }
        
        var lastDataLength: Int = 0
        while data.count > tempMaxLength && data.count != lastDataLength {
            lastDataLength = data.count
            let ratio: CGFloat = CGFloat(tempMaxLength) / CGFloat(data.count)
            let size: CGSize = CGSize(width: Int(resultImage.size.width * sqrt(ratio)),
                                      height: Int(resultImage.size.height * sqrt(ratio)))
            UIGraphicsBeginImageContext(size)
            resultImage.draw(in: CGRect(x: 0,
                                        y: 0,
                                        width: size.width,
                                        height: size.height))
            resultImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            data = resultImage.jpegData(compressionQuality: compression)!
        }
        return data
    }
    
    public func imageWithAlpha(_ alpha: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    /*
     重设图片大小
     */
    public func reSizeImage(reSize:CGSize) -> UIImage {
        //UIGraphicsBeginImageContext(reSize);
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale)
        self.draw(in: CGRect(x:0,y:0,width:reSize.width,height:reSize.height))
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return reSizeImage
    }
    /*
     根据宽度自动计算高度，并重设图片大小
     */
    public func reSizeImage(width: CGFloat) -> UIImage {
        //UIGraphicsBeginImageContext(reSize);
        let prop: CGFloat = self.size.width / self.size.height
        let height: CGFloat = width / prop
        
        return reSizeImage(reSize: CGSizeMake(width, height))
    }
    /*
     根据高度自动计算宽度，并重设图片大小
     */
    public func reSizeImage(height: CGFloat) -> UIImage {
        //UIGraphicsBeginImageContext(reSize);
        let prop: CGFloat = self.size.width / self.size.height
        let width: CGFloat = prop * height
        
        return reSizeImage(reSize: CGSizeMake(width, height))
    }
    /*
     等比率缩放
     */
    public func scaleImage(scaleSize:CGFloat) -> UIImage {
        let reSize = CGSize(width:self.size.width * scaleSize,height:self.size.height * scaleSize)
        return reSizeImage(reSize: reSize)
    }
    
    @discardableResult public
    func sizeWidth() -> CGFloat {
        return size.width
    }
    
    @discardableResult public
    func sizeHeight() -> CGFloat {
        return size.height
    }
}
