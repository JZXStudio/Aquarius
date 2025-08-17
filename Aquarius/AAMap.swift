//
//  AMap.swift
//  Aquarius
//
//  Created by SONG JIN on 2025/7/8.
//
import MapKit
import Foundation

public struct AAMap {
    /// 打开高德地图
    /// - Parameters:
    ///   - latitude: 纬度
    ///   - longitude: 经度
    ///   - name: 显示名称
    public static func openMap(latitude: Double, longitude: Double, name: String) {
        let aMapURLString: String = "iosamap://viewMap?sourceApplication=\(A.app.appName)&poiname=\(name)&lat=\(latitude)&lon=\(longitude)&dev=0".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        if let aMapURL:URL = URL(string: aMapURLString), UIApplication.shared.canOpenURL(aMapURL) {
            UIApplication.shared.open(aMapURL)
        } else {
            let webURLString: String = "http://uri.amap.com/marker?position=\(latitude),\(longitude)"
            if let webURL: URL = URL(string: webURLString) {
                UIApplication.shared.open(webURL)
            }
        }
    }
    /// 高德经纬度转百度经纬度
    /// - Parameter coordinate: 高德经纬度
    /// - Returns: 百度经纬度
    public static func convertAMapToBaiduMap(coordinate: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: coordinate.latitude + 0.006, longitude: coordinate.longitude + 0.0065)
    }
    /// 百度经纬度转高的经纬度
    /// - Parameter coordinate: 百度经纬度
    /// - Returns: 高德经纬度
    public static func convertBaiduMapToAMap(coordinate: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: coordinate.latitude - 0.006, longitude: coordinate.longitude - 0.0065)
    }
}

public struct AAppleMap {
    /// 打开苹果地图
    /// - Parameters:
    ///   - latitude: 纬度
    ///   - longitude: 经度
    ///   - name: 显示名称
    public static func openMap(latitude: Double, longitude: Double, name: String) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name
        mapItem.openInMaps(launchOptions: nil)
    }
}

public struct ABaiduMap {
    /// 打开百度地图
    /// - Parameters:
    ///   - latitude: 纬度
    ///   - longitude: 经度
    ///   - name: 显示名称
    public static func openMap(latitude: Double, longitude: Double, name: String) {
        let baiduMapURLString = "baidumap://map/direction?origin={{我的位置}}&destination=latlng:\(latitude),\(longitude)|name:\(name)&mode=driving&src=\(name)&coord_type=gcj02"//.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        if let baiduMapURL: URL = URL(string: baiduMapURLString), UIApplication.shared.canOpenURL(baiduMapURL) {
            UIApplication.shared.open(baiduMapURL)
        } else {
            let webURLString: String = "http://api.map.baidu.com/marker?location=\(latitude),\(longitude)"
            if let webURL: URL = URL(string: webURLString) {
                UIApplication.shared.open(webURL)
            }
        }
    }
}

public struct AQQMap {
    /// 打开QQ地图
    /// - Parameters:
    ///   - latitude: 纬度
    ///   - longitude: 经度
    ///   - name: 显示名称
    public static func openMap(latitude: Double, longitude: Double, name: String) {
        let qqMapURLString: String = "qqmap://map/routeplan?type=drive&from=我的位置&fromcoord=&to=\(name)&tocoord=\(latitude),\(longitude)&policy=1&referer=\(A.app.appName)"
        if let qqMapURL: URL = URL(string: qqMapURLString), UIApplication.shared.canOpenURL(qqMapURL) {
            UIApplication.shared.open(qqMapURL)
        } else {
            let webURLString: String = "http://api.map.baidu.com/marker?location=\(latitude),\(longitude)"
            if let webURL: URL = URL(string: webURLString) {
                UIApplication.shared.open(webURL)
            }
        }
    }
}
