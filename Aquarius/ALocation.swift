//
//  ALocation.swift
//  Aquarius
//
//  Created by SONG JIN on 2025/6/3.
//

import Foundation
import CoreLocation

public enum ALocationRequestType {
    case whenInUse
    case always
}

open class ALocation: NSObject {
    private let locationManager: CLLocationManager = CLLocationManager()
    private var requestType: ALocationRequestType = .whenInUse
    public var updateHandler: ((_ locations: [CLLocation]) -> Void)? = nil
    public var failHandler: ((_ error: Error) -> Void)? = nil
    public var reverseGeocodeHandler: ((_ placemark: [CLPlacemark]) -> Void)? = nil
    public var authorized: ((_ status: CLAuthorizationStatus) -> Void)? = nil
    
    deinit {
        updateHandler = nil
        failHandler = nil
        
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
    
    public override init() {
        super.init()
        
        setupLocation(.whenInUse, kCLLocationAccuracyBest, 10)
    }
    
    public init(_ requestType: ALocationRequestType = .whenInUse, _ desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyBest, _ distanceFilter: CLLocationDistance = 10, authorized: ((_ status: CLAuthorizationStatus) -> Void)? = nil) {
        super.init()
        
        if authorized != nil {
            self.authorized = authorized
        }
        
        setupLocation(requestType, desiredAccuracy, distanceFilter)
    }
    
    private func setupLocation(_ requestType: ALocationRequestType, _ desiredAccuracy: CLLocationAccuracy, _ distanceFilter: CLLocationDistance) {
        locationManager.desiredAccuracy = desiredAccuracy
        locationManager.distanceFilter = distanceFilter
        
        self.requestType = requestType
        
        switch requestType {
        case .whenInUse:
            locationManager.requestWhenInUseAuthorization()
            break
        case .always:
            locationManager.requestAlwaysAuthorization()
            break
        }
    }
    
    public func startLocation(_ update: ((_ locations: [CLLocation]) -> Void)?=nil, reverseGeocode: ((_ placemarks: [CLPlacemark]) -> Void)? = nil, fail: ((_ error: Error) -> Void)? = nil) {
        if update != nil {
            updateHandler = update
        }
        
        if reverseGeocode != nil {
            reverseGeocodeHandler = reverseGeocode
        }
        
        if fail != nil {
            failHandler = fail
        }
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    public func stopLocation() {
        updateHandler = nil
        failHandler = nil
        
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
    
    public func reverseGeocodeLocation(_ loc: CLLocation, _ placemark: ((_ placemark: [CLLocation]) -> Void)?=nil, fail: ((_ error: Error) -> Void)? = nil) {
        let geocoder = CLGeocoder()  // 新增地理编码器
        // loc: CLLocation对象
        geocoder.reverseGeocodeLocation(loc) { [weak self] (placemarks, error) in
            if error != nil {
                print("Geocoding error: \(error!.localizedDescription)")
                if self?.failHandler != nil {
                    self?.failHandler!(error!)
                }
            } else if let placemarks = placemarks {
                if self?.reverseGeocodeHandler != nil {
                    self?.reverseGeocodeHandler!(placemarks)
                }
            }
        }
    }
}

extension ALocation: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        manager.stopUpdatingLocation()
        
        if updateHandler != nil {
            updateHandler!(locations)
        }
        
        if reverseGeocodeHandler != nil {
            reverseGeocodeLocation(locations[0])
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if failHandler != nil {
            failHandler!(error)
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                // do what is needed if you have access to location
            if authorized != nil {
                authorized!(status)
            }
            break
            case .denied, .restricted:
                // do what is needed if you have no access to location
            if authorized != nil {
                authorized!(status)
            }
            break
            case .notDetermined:
                switch requestType {
                case .whenInUse:
                    locationManager.requestWhenInUseAuthorization()
                    break
                case .always:
                    locationManager.requestAlwaysAuthorization()
                    break
                }
            break
            default:
            break
                // raise an error - This case should never be called
            }
    }
}
