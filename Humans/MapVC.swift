//
//  MapVC.swift
//  Humans
//
//  Created by Nika on 7/25/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewShape(view: doneBtn)
        backgroundView.clipsToBounds = true
        backgroundView.layer.cornerRadius = 15

       //mapView.showsUserLocation
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
        self.dismiss(animated: true, completion: nil)

    }

}
