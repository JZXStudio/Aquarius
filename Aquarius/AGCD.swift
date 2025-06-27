//
//  AGCD.swift
//  Aquarius
//
//  Created by SONG JIN on 2024/5/22.
//

import Foundation

open class AGCD: NSObject {
    private static let lock: NSLock = NSLock()
    /// 串行执行线程。执行完更新主线程
    /// - Parameters:
    ///   - task: 线程执行的方法
    ///   - sleepSecond: 线程方法与主线程方法中间是否要加时间间隔（默认为0）
    ///   - finish: 主线程执行的方法
    public static func async(task: @escaping(() -> Void), sleepSecond: UInt32=0, finish: (() -> Void)? = nil) {
        let group = DispatchGroup()
        DispatchQueue.global().async(group: group) {
            lock.lock()
            task()
            
            if sleepSecond != 0 {
                sleep(sleepSecond)
            }
            lock.unlock()
            if finish != nil {
                group.notify(queue: DispatchQueue.main) {
                    finish!()
                }
            }
        }
    }
    /// 主线程执行
    /// - Parameter finish: 主线程执行的方法
    public static func main(finish: (() -> Void)? = nil) {
        DispatchGroup().notify(queue: DispatchQueue.main) {
            if finish != nil {
                finish!()
            }
        }
    }
    /// 串行执行线程。执行完更新主线程
    /// - Parameters:
    ///   - task: 线程执行的方法
    ///   - sleepSecond: 线程方法与主线程方法中间是否要加时间间隔（默认为0）
    ///   - finish: 主线程执行的方法
    public func async(task: @escaping(() -> Void), sleepSecond: UInt32=0, finish: (() -> Void)? = nil) {
        let group = DispatchGroup()
        DispatchQueue.global().async(group: group) {
            task()
            
            if sleepSecond != 0 {
                sleep(sleepSecond)
            }
            
            if finish != nil {
                group.notify(queue: DispatchQueue.main) {
                    finish!()
                }
            }
        }
    }
    /// 主线程执行
    /// - Parameter finish: 主线程执行的方法
    public func finish(finish: @escaping(() -> Void)) {
        DispatchGroup().notify(queue: DispatchQueue.main) {
            finish()
        }
    }
}
