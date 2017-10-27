//
//  ViewController.swift
//  GoogleMapsForth
//
//  Created by Admin on 27.10.17.
//  Copyright © 2017 NS. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import CoreMotion

class ViewController: UIViewController {
    
    // to find the users location. This will add and instantiate a CLLocationManager property named locationManager.
    let locationManager = CLLocationManager()
    private let motionManager = CMMotionActivityManager() //отследить, когда пользователь едет
    
    let marker = GMSMarker()

    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        //Чтобы приложение могло работать с геолокацией в фоне, необходимо сделать 2 вещи:
        //1
        locationManager.allowsBackgroundLocationUpdates = true
        //2 Добавить в параметр в Background Modes ("Background Modes -> Location updates" in Capabilities). В противном случае будет выброшен exception.
        
        locationManager.pausesLocationUpdatesAutomatically = false //Чтобы не было так: как только пользователь, свернув приложение, будет некоторое время оставаться с точки зрения системы неподвижно, геолокация остановится, а вместе с ним и приложение. Все дело в том, что CLLocationManager по умолчанию использует паузу для геолокации pausesLocationUpdatesAutomatically.
        
        // Request permission to use location service
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        
        
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // A minimum distance a device must move before update event generated
        locationManager.distanceFilter = 500
        
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges() //на значительные перемещения
        
        self.view = mapView
        
        
       
        
    }
    
    
   
    
    
    
    
   
}

// MARK: - CLLocationManagerDelegate
//1
extension ViewController: CLLocationManagerDelegate {
    //  is called when the user grants or revokes location permissions
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        // verify the user has granted you permission while the app is in use
        if status == .authorizedWhenInUse {
            
            // ask the location manager for updates on the user’s location
            //locationManager.startUpdatingLocation()
            
            //myLocationEnabled draws a light blue dot where the user is located
            mapView.isMyLocationEnabled = true
           
        }
    }
    
    // executes when the location manager receives new location data
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        
        let newLocation = locations.last
        mapView.camera = GMSCameraPosition.camera(withTarget: newLocation!.coordinate, zoom: 15.0)
        //myLocationButton, when set to true, adds a button to the map that, when tapped, centers the map on the user’s location
        mapView.settings.myLocationButton = true
        self.view = self.mapView
        
        // Create marker and set location
        marker.position = CLLocationCoordinate2DMake(newLocation!.coordinate.latitude, newLocation!.coordinate.longitude)
        marker.map = self.mapView
        
        /*if let location = locations.first {
            
            // This updates the map’s camera to center around the user’s current location
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            
            /*// Tell locationManager you’re no longer interested in updates; you don’t want to follow a user around as their initial location is enough for you to work with.
            locationManager.stopUpdatingLocation()*/
        }*/
        
    }
}

