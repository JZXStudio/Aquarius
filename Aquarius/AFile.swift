//
//  AFile.swift
//  Aquarius
//
//  Created by SONG JIN on 2024/9/13.
//

import Foundation

open class AFile: NSObject {
    public static let shared = AFile()
    
    internal let fileManager: FileManager = FileManager.default
    
    public var documents: String {
        NSHomeDirectory().appending("/Documents/")
    }
    public var home: String {
        NSHomeDirectory()
    }
    public var caches: String {
        NSHomeDirectory()+"/Library/Caches"
    }
    public var library: String {
        NSHomeDirectory()+"/Library"
    }
    public var tmp: String {
        NSHomeDirectory()+"/tmp"
    }
    public func pathFromDocuments(path: String) -> String {
        return documents.appending("\(path)")
    }
    public func pathFromHome(path: String) -> String {
        return home.appending("\(path)")
    }
    public func pathFromCaches(path: String) -> String {
        return caches.appending("\(path)")
    }
    public func pathFromLibrary(path: String) -> String {
        return library.appending("\(path)")
    }
    public func pathFromTmp(path: String) -> String {
        return tmp.appending("\(path)")
    }
    //创建文件夹
    public func createFolder(folderName: String) {
        let filePath = "\(folderName)"
        let exist = fileManager.fileExists(atPath: filePath)
        // 不存在的路径才会创建
        if (!exist) {
            //withIntermediateDirectories为ture表示路径中间如果有不存在的文件夹都会创建
            try! fileManager.createDirectory(atPath: filePath,withIntermediateDirectories: true, attributes: nil)
        }
    }
    //删除文件夹
    public func removeFolder(folderName: String) {
        let filePath = "\(folderName)"
        let exist = fileManager.fileExists(atPath: filePath)
        // 查看文件夹是否存在，如果存在就直接读取，不存在就直接反空
        if (exist) {
            try! fileManager.removeItem(atPath: filePath)
        }else{
            // 不存在就不做什么操作了
        }
    }
    //删除文件
    public func removeFile(filePath: String) {
        //移除文件
        try! fileManager.removeItem(atPath: filePath)
    }
    //查找文件夹下的所有文件（直查找单层）
    public func searchFiles(folderName: String) -> [String] {
        let filePath = "\(folderName)"
        return try! fileManager.contentsOfDirectory(atPath: filePath);
    }
    //查找文件夹下的所有文件（包括符号链接。带路径等信息）
    public func deepSearchcomplexFiles(folderName: String) -> [String]? {
        let filePath = "\(folderName)"
        let exist = fileManager.fileExists(atPath: filePath)
        // 查看文件夹是否存在，如果存在就直接读取，不存在就直接反空
        if (exist) {
            return fileManager.subpaths(atPath: folderName as String)
        } else {
            return []
        }
    }
    //查找文件夹下的所有文件（不包括符号链接，不带路径等信息）
    public func deepSearchSimpleFiles(folderName: String) -> [Any] {
        let filePath = "\(folderName)"
        let exist = fileManager.fileExists(atPath: filePath)
        // 查看文件夹是否存在，如果存在就直接读取，不存在就直接反空
        if (exist) {
            let contentsOfPathArray = fileManager.enumerator(atPath: filePath)
            return contentsOfPathArray!.allObjects
        } else {
            return []
        }
    }
    //判断文件或文件夹是否存在。（path为文件夹或者文件的全路径名称）
    public func isExist(path: String) -> Bool {
        let filePath = "\(path)"
        let exist = fileManager.fileExists(atPath: filePath)
        // 查看文件夹是否存在，如果存在就直接读取，不存在就直接反空
        if (exist) {
            return true
        } else {
            return false
        }
    }
    //获取文件或文件夹大小
    public func getSize(path: String) -> Float {
        if path.count == 0 {
            return 0.0
          }
          if !fileManager.fileExists(atPath: path){
              return 0.0
          }
          var fileSize:Float = 0.0
          do {
             let files = try fileManager.contentsOfDirectory(atPath: path)
             for file in files {
                 let newPath = path + "/\(file)"
                 fileSize = fileSize + fileSizeAtPath(filePath: newPath)
              }
          } catch {
              fileSize = fileSize + fileSizeAtPath(filePath: path)
          }
        
          return fileSize
    }
    
    /**  计算单个文件或文件夹的大小 */
    private func fileSizeAtPath(filePath:String) -> Float {
      var fileSize:Float = 0.0
      if fileManager.fileExists(atPath: filePath) {
          do {
              let attributes = try fileManager.attributesOfItem(atPath: filePath)
              if attributes.count != 0 {
                 fileSize = attributes[FileAttributeKey.size]! as! Float
              }
          } catch {
      
          }
       }
       return fileSize;
    }
}
