//
//  HomeVM.swift
//  Daylight
//
//  Created by Ben Farmer on 4/23/21.
//
import CoreLocation
import Solar

extension Home{
    class ViewModel: ObservableObject{
//        var locationManager = LocationManager()
        @Published var locationServiceComplete = false
        @Published var isDaytime = true
        
        func runLocationService(){
            LocationManager.shared.getUserLocation{ [weak self] location in
//                guard let location = LocationManager.shared.locationData.location else{
//                    return
//                }
                print("~HomeVM: location service complete")
                self?.getLocationName()
            }
        }
        
        func getLocationName(){
            LocationManager.shared.resolveLocationName(with: LocationManager.shared.locationData.location){[weak self]locationName in
//                guard self?.locationManager.locationData.locationName != nil else{
//                    print("~HomeVM: location name could not be resolved")
//                    return
//                }
                print("~HomeVM: resolved location name")
                
                let solar = Solar(coordinate: LocationManager.shared.locationData.coordinates)
                self?.isDaytime = solar?.isDaytime ?? true
                print("~HomeVM: Is Daytime - \(self?.isDaytime ?? true)")
                
                self?.locationServiceComplete = true
            }
        }
    }

}

