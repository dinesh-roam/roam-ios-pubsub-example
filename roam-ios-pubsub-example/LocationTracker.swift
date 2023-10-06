//
//  LocationTracker.swift
//   Enable
//

import Foundation
import CoreLocation
import Roam

class LocationTracker :NSObject {
    
    public static var shared = LocationTracker()
    
    var userLocation: CLLocation?
    let isUserLoggedIn = true
    var roamUserId:String?
    
    var didUpdateLocationCount = 0
    var didReceiveUserLocationCount = 0
    
    var didUpdateCount: (() -> ())? = nil
    
    public override init(){}

    //MARK: STEP-1
    func initialiseRoamSDK() {
        
        //MARK: STEP-1.1
        Roam.delegate = self
        
        //MARK: STEP-1.2
        Roam.initialize("")
        #error("Please set Roam key")
        
        //MARK: STEP-1.3
        Roam.enableAccuracyEngine(50)
        
    }
    
    //MARK: STEP-2
    func requestUserLocation() {
        Roam.requestLocation()
    }

    
    //MARK: STEP-7
    func startUserTracking() {
        
        //MARK: STEP-7.1
        let locationData = RoamPublish()
        Roam.publishSave(locationData)
        
        //MARK: STEP-7.2
        Roam.updateCurrentLocation(100)
        
        //MARK: STEP-7.3
        // Set location configuration
        let trackingMethod = RoamTrackingCustomMethods()
        
        trackingMethod.allowBackgroundLocationUpdates = true //self.backLocationSegmentAction.selectedSegmentIndex == 1
        trackingMethod.pausesLocationUpdatesAutomatically = false//self.pauseSegmentAction.selectedSegmentIndex == 1
        trackingMethod.showsBackgroundLocationIndicator = true
        trackingMethod.desiredAccuracy = .kCLLocationAccuracyBestForNavigation//self.getDesiredAccuracy()
        trackingMethod.activityType = .fitness//self.getActivity()
        trackingMethod.useVisits = true
        trackingMethod.useSignificant = true
        trackingMethod.useStandardLocationServices = false
        trackingMethod.useRegionMonitoring  = true
        trackingMethod.updateInterval = 5
        Roam.updateLocationWhenStationary(1800)
        // Start the tracking with the above created custom tracking method
        Roam.startTracking(.custom, options: trackingMethod)
 
    }
    
    //MARK: STEP-8
    func stopTracking() {
        //MARK: STEP-8.1
        Roam.stopTracking()
        
        //MARK: STEP-2
        Roam.stopPublishing()
        
        //MARK: STEP-3
        Roam.unsubscribe(.Location)
    }
    
}


extension LocationTracker {
    
    //MARK: STEP-3
    func loginUser(roamUserId: String) {
        
        self.getUser(roamUserId: roamUserId ) { roamDict in
            print(roamDict)
        }
    }
    
    func logoutUser() {
        didUpdateLocationCount = 0
        didReceiveUserLocationCount = 0
        didUpdateCount?()
        Roam.logoutUser()
    }
    
    
    //MARK: STEP-4
    func getUser(roamUserId:String, completion: @escaping ( [String:Any]? ) -> Void) {
        guard self.isUserLoggedIn else { completion(nil); return }
        Roam.getUser(roamUserId) {(RoamUser, Error) in
            guard let userData = RoamUser else {   completion(nil); return}
            
            self.toggleListener(locations: true)
            
            completion( ["userId": userData.userId ] )
        }
    }
 
    //MARK: STEP-5
    func toggleListener(events:Bool = false,locations:Bool = false){
        //Set List
        Roam.toggleEvents(Geofence: true, Trip: true, Location: true, MovingGeofence: true) {(RoamUser, Error) in
            print(RoamUser, Error)
        }
        Roam.toggleListener(Events: events, Locations: locations) {(RoamUser, Error) in
            print(RoamUser, Error)
        }
    }
    
    //MARK: STEP-6
    func subscribeUsers(_ list:[String]) {
        list.forEach { userId in
            Roam.subscribe(.Location, userId)
        }
    }
        
}

//MARK: RoamDelegate
extension LocationTracker: RoamDelegate {
    
    func didReceiveUserLocation(_ location: RoamLocationReceived) {
        // Do something with location of other users' subscribed location
        print("update User location API call....")
        didReceiveUserLocationCount += 1
        didUpdateCount?()
    }
    
    func didUpdateLocation(_ locations: [RoamLocation]) {
        didUpdateLocationCount += 1
        didUpdateCount?()
        self.userLocation = CLLocation(latitude: locations.first?.location.coordinate.latitude ?? 0,
                                       longitude: locations.first?.location.coordinate.longitude ?? 0)
        self.updateLocation()
    }
    
}


extension LocationTracker {
    
    func updateLocation() {
        
        //guard let latitude = self.userLocation?.coordinate.latitude,let longitude = self.userLocation?.coordinate.longitude else {return}
        
        //update location API Call
        print("update location API call....")
        
    }
    
}
