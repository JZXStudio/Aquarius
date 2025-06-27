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
    
    public init(_ date: Date?=nil) {
        count = (date == nil) ? 0 : date!.toSecondsBetween(Date())
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
    }
    public func updateTime(_ block: ((_ timeString: String) -> Void)?=nil) {
        var time: String = ""
        
        AGCD.async(task: { [weak self] in
            if self!.count < 60 {
                time = self!.count < 10 ? "00:00:0\(self!.count)" : "00:00:\(self!.count)"
            } else if self!.count >= 60 && self!.count < 3600 {
                let second: Int = self!.count % 60
                let minute: Int = Int(self!.count / 60)
                
                let secondString: String = second < 10 ? "0\(second)" : "\(second)"
                let minuteString: String = minute < 10 ? "0\(minute)" : "\(minute)"
                
                time = "00:" + minuteString + ":" + secondString
            } else if self!.count >= 3600 {
                let hour: Int = Int(self!.count / 3600)
                let minute: Int = Int((self!.count % 3600) / 60)
                let second: Int = Int((self!.count % 3600) % 60)
                
                let hourString: String = hour < 10 ? "0\(hour)" : "\(hour)"
                let secondString: String = second < 10 ? "0\(second)" : "\(second)"
                let minuteString: String = minute < 10 ? "0\(minute)" : "\(minute)"
                
                time = hourString + ":" + minuteString + ":" + secondString
            }
        }) {
            if block != nil {
                block!(time)
            }
        }
        /*
        if count < 60 {
            time = count < 10 ? "00:00:0\(count)" : "00:00:\(count)"
        } else if count >= 60 && count < 3600 {
            let second: Int = count % 60
            let minute: Int = Int(count / 60)
            
            let secondString: String = second < 10 ? "0\(second)" : "\(second)"
            let minuteString: String = minute < 10 ? "0\(minute)" : "\(minute)"
            
            time = "00:" + minuteString + ":" + secondString
        } else if count >= 3600 {
            let hour: Int = Int(count / 3600)
            let minute: Int = Int((count % 3600) / 60)
            let second: Int = Int((count % 3600) % 60)
            
            let hourString: String = hour < 10 ? "0\(hour)" : "\(hour)"
            let secondString: String = second < 10 ? "0\(second)" : "\(second)"
            let minuteString: String = minute < 10 ? "0\(minute)" : "\(minute)"
            
            time = hourString + ":" + minuteString + ":" + secondString
        }
        return time
         */
    }
}
