//
//  MapVC.swift
//  Humans
//
//  Created by Nika on 7/25/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    
    var databaseRef: FIRDatabaseReference!
    let uId = FIRAuth.auth()?.currentUser?.uid
    var manager: CLLocationManager!
    var country = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewShape(view: doneBtn)
        backgroundView.clipsToBounds = true
        backgroundView.layer.cornerRadius = 15

        mapView.delegate = self
        mapView.mapType = MKMapType.standard
        mapView.showsUserLocation = true
        mapView.isZoomEnabled = true
        
        setUpLocationManager()
        
        if manager.location != nil {
            let homeLocation = CLLocation(latitude: (manager.location?.coordinate.latitude)!, longitude: (manager.location?.coordinate.longitude)!)
            let regionRadius: CLLocationDistance = 100000
            
            centerMapOnLocation(location: homeLocation, r: regionRadius)
            
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        manager.startUpdatingLocation()
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loc = locations.first!
        CLGeocoder().reverseGeocodeLocation(loc, completionHandler: {(placemaks, error)->Void in
            if error != nil {
                print("Reverse geocoder filed with error: \(error!.localizedDescription)")
                return
            }
            
            if (placemaks?.count)! > 0 {
                let pm = placemaks![0]
                self.country = "\(String(describing: pm.locality ?? "")) \(String(describing: pm.administrativeArea ?? "")) \(String(describing: pm.country ?? ""))"
                self.label.text = self.country
            } else {
                print("Problem with the data recives drom geocoder")
            }
        })
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error updating location:" + error.localizedDescription)
    }
   
    func centerMapOnLocation(location: CLLocation, r: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, r , r )
        mapView.setRegion(coordinateRegion, animated: true)
    }

    
    func setUpLocationManager() {
        if (CLLocationManager.locationServicesEnabled()) {
            manager = CLLocationManager()
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.activityType = .other
            manager.requestWhenInUseAuthorization()
        } else {
            print("Location services are not enabled")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func xHit(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)

    }
    @IBAction func viewTaped(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)

    }
    @IBAction func doneHit(_ sender: UIButton) {
        databaseRef = FIRDatabase.database().reference()
        self.databaseRef.child("Users/\(self.uId!)/country").setValue(self.country)
        self.dismiss(animated: true, completion: nil)

    }

}
