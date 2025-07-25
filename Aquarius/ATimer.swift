//
//  ATimer.swift
//  Aquarius
//
//  Created by SONG JIN on 2025/6/24.
//

import Foundation

open class ATimer {
    var timer: Timer?
    private var count: Int
    public var hour: Int = 0
    public var minute: Int = 0
    public var second: Int = 0
    
    public init(_ date: Date?=nil) {
        count = (date == nil) ? 0 : date!.toSecondsBetween(Date())
        calculateTime()
    }
    /// 开始计时
    /// - Parameters:
    ///   - interval: 间隔，默认1秒
    ///   - repeats: 是否循环
    ///   - block: 回调函数
    public func start(_ interval: TimeInterval=1.0, _ repeats: Bool=true, block: ((_ timer: Timer) -> Void)?=nil) {
        timer = Timer.scheduledTimer(
            withTimeInterval: interval,
            repeats: repeats,
            block: { [weak self] result in
                self?.count++
                
                if block != nil {
                    block!(result)
                }
            }
        )
    }
    /// 停止计时
    public func stop() {
        timer?.invalidate()
        
        count = 0
        hour = 0
        minute = 0
        second = 0
    }
    /// 更新时间（回调函数输出样式00:00:00）
    /// - Parameter block: 回调函数
    public func updateTime(_ block: ((_ timeString: String) -> Void)?=nil) {
        var time: String = ""
        
        AGCD.async(task: { [weak self] in
            if self!.count < 60 {
                time = self!.count < 10 ? "00:00:0\(self!.count)" : "00:00:\(self!.count)"
                self?.hour = 0
                self?.minute = 0
                self?.second = self!.count
            } else if self!.count >= 60 && self!.count < 3600 {
                self?.second = self!.count % 60
                self?.minute = Int(self!.count / 60)
                self?.hour = 0
                
                let secondString: String = self!.second < 10 ? "0\(self!.second)" : "\(self!.second)"
                let minuteString: String = self!.minute < 10 ? "0\(self!.minute)" : "\(self!.minute)"
                
                time = "00:" + minuteString + ":" + secondString
            } else if self!.count >= 3600 {
                self?.hour = Int(self!.count / 3600)
                self?.minute = Int((self!.count % 3600) / 60)
                self?.second = Int((self!.count % 3600) % 60)
                
                let hourString: String = self!.hour < 10 ? "0\(self!.hour)" : "\(self!.hour)"
                let secondString: String = self!.second < 10 ? "0\(self!.second)" : "\(self!.second)"
                let minuteString: String = self!.minute < 10 ? "0\(self!.minute)" : "\(self!.minute)"
                
                time = hourString + ":" + minuteString + ":" + secondString
            }
        }) {
            if block != nil {
                block!(time)
            }
        }
    }
    
    private func calculateTime() {
        if count < 60 {
            hour = 0
            minute = 0
            second = count
        } else if count >= 60 && count < 3600 {
            second = count % 60
            minute = Int(count / 60)
            hour = 0
        } else if count >= 3600 {
            hour = Int(count / 3600)
            minute = Int((count % 3600) / 60)
            second = Int((count % 3600) % 60)
        }
    }
}
