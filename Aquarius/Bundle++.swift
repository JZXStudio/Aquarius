//
//  Bundle++.swift
//  Aquarius
//
//  Created by SONG JIN on 2022/8/23.
//

import UIKit
import Foundation

extension Bundle {
    //动态库使用
    public func bundle(name: String) -> Bundle? {
        let path = self.path(forResource: name, ofType: "bundle")
        if let path = path {
            return Bundle(path: path)
        }
        return nil
    }
    //静态库使用
    public func bundle(name: String, frameworkName: String) -> Bundle? {
        let path = self.path(forResource: name, ofType: "bundle", inDirectory: frameworkName+".framework")
        if let path = path {
            return Bundle(path: path)
        }
        return nil
    }
    //静态库使用
    public func bundle(frameworkName: String) -> Bundle? {
        let path = self.path(forResource: frameworkName, ofType: "framework")
        if let path = path {
            return Bundle(path: path)
        }
        return nil
    }
    
    public func image(name: String) -> UIImage? {
        return UIImage(named: name, in: self, compatibleWith: nil)
    }
    /// 获取bundle中的文本内容
    ///
    /// **Sample**
    ///
    /// 从主工程中的NoteResources的bundle包中获取icons.json的文本内容
    ///
    /// ``` swift
    /// ACommon.GetMainResourceBundle(bundleName: "NoteResources").txt("icons")
    /// ```
    ///
    /// **Notice**
    /// 
    /// 支持后缀名为**txt, rtf, html, htm, json**的文本内容，不需要写**后缀名**
    ///
    /// - Parameter name: 文本名称
    /// - Returns: 文本字符串
    public func txt(name: String) -> String? {
        let types: Array<String> = ["txt", "rtf", "html", "htm", "json"]
        var contentData:NSData?
        for currentType in types {
            let pathStr: String = (self.path(forResource: name, ofType: currentType) ?? "") as String
            if pathStr != "" {
                contentData = NSData(contentsOfFile: pathStr as String)
                break
            }
        }
        
        return String(data: contentData! as Data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
    }
    
    public func file(name: String) -> Data? {
        let types: Array<String> = ["mp3", "mp4"]
        var contentData:Data?
        for currentType in types {
            let pathStr: String = (self.path(forResource: name, ofType: currentType) ?? "") as String
            if pathStr != "" {
                contentData = try! Data.init(contentsOf: self.url(forResource: name, withExtension: currentType)!)
                break
            }
        }
        
        return contentData
    }
    
    public func getImageResource(name: String) -> UIImage? {
        return UIImage.init(named: name, in: self, compatibleWith: nil)!
    }
}
