//
//  LocationManager.swift
//  Daylight
//
//  Created by Ben Farmer on 4/23/21.
//

import CoreLocation
import os.log

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    let logger = Logger(subsystem: subsystem!, category: "LocationManager")
    static var shared = LocationManager()
    let manager = CLLocationManager()
    var updateLocationCompletion: ((CLLocation) -> Void)?

    
    var locationData = LocationData()
    
    func getUserLocation(completion: @escaping ((CLLocation) -> Void)){
        self.updateLocationCompletion = completion
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else{
            return
        }
        
        self.locationData.location = location
        self.locationData.coordinates = location.coordinate
        
        logger.info("Location: \(location)")
       // print("~LocationManager: Location: \(location)")
        updateLocationCompletion?(location)
        manager.stopUpdatingLocation()
    }
    
    func resolveLocationName(with location: CLLocation, completion: @escaping ((String?) -> Void)){
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, preferredLocale: .current){ placemarks, error in
            guard let place = placemarks?.first, error == nil
            else{
                completion(nil)
                return
            }
            var name = ""
            if let locality = place.locality{
                name += locality
            }
            if let adminRegion = place.administrativeArea{
                name += ", \(adminRegion)"
            }
            if let tz = place.timeZone{
                self.locationData.timeZone = tz
            }
            
            self.locationData.locationName = name
            
            self.logger.info("Location Name: \(name)")
            completion(name)
        }
    }
}
