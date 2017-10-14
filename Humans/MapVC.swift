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
    
    var databaseRef: FIRDatabaseReference!
    let uId = FIRAuth.auth()?.currentUser?.uid
    var manager: CLLocationManager!
    var country = ""
    var locationAproved: Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationAproved = UserDefaults.standard.bool(forKey: isLocationAproved_Key)
        viewShape(view: doneBtn)

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
                if self.locationAproved {
                self.label.text = self.country
                } else {
                 self.label.text = "Location sharing disabled"
                }
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

    func presentConfirmationAlert() {
        let alert = UIAlertController(title: "Please Confirm!", message: "We only share your city (and state, if applicable) and country with your posts", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (void) in
         print("user has canceled location sharing")
        }
        
        let confirm = UIAlertAction(title: "Confirm", style: .default) { (void) in
            self.editDataInBackend(true)
            self.doneBtnVisualEfectDataEded()
            self.label.text = self.country
            self.locationAproved = true
            UserDefaults.standard.set(true, forKey: isLocationAproved_Key)
            
            let location:[String: String] = ["location": self.country]
            //MARK: -> post a notification
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userscountry"), object: nil, userInfo: location)
        }
        
        let decline = UIAlertAction(title: "Decline", style: .destructive) { (void) in
            self.editDataInBackend(false)
            self.label.text = "Location sharing disabled"
            self.locationAproved = false
             UserDefaults.standard.set(false, forKey: isLocationAproved_Key)
            
            let location:[String: String] = ["location": ""]
            //MARK: -> post a notification
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userscountry"), object: nil, userInfo: location)
            
        }
        
        alert.addAction(confirm)
        alert.addAction(decline)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func editDataInBackend(_ permistion: Bool) {
        databaseRef = FIRDatabase.database().reference()
        if permistion {
            self.databaseRef.child("Users/\(self.uId!)/country").setValue(self.country)
        } else {
            self.databaseRef.child("Users/\(self.uId!)/country").setValue(nil)
           
        }
    }
    
    func doneBtnVisualEfectDataEded() {
        self.doneBtn.setTitleColor(pinkColor, for: .normal)
        self.doneBtn.setTitle("...", for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000), execute: {
            // self.doneBtn.titleLabel?.textColor = pinkColor
            self.doneBtn.setTitle("...Done", for: .normal)
            playSystemSound(id: 1055)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2000), execute: {
            self.doneBtn.setTitleColor(grayColor, for: .normal)
            self.doneBtn.setTitle("Location Settings", for: .normal)
        })
    }
    
    @IBAction func viewTaped(_ sender: UITapGestureRecognizer) {
       // self.dismiss(animated: true, completion: nil)

    }
    @IBAction func doneHit(_ sender: UIButton) {
        presentConfirmationAlert()
      //  self.dismiss(animated: true, completion: nil)
    }
}
