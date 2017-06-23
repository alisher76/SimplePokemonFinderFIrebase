//
//  ViewController.swift
//  PokeFinderApp
//
//  Created by Alisher Abdukarimov on 6/23/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let annoIdentifier = "Pokemon"
    var mapCenteredOnce = false
    let locationManager = CLLocationManager()
    var geoFire: GeoFire!
    var geoFireReference: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.delegate = self
        mapView.userTrackingMode = MKUserTrackingMode.follow
        
        geoFireReference = Database.database().reference()
        geoFire = GeoFire(firebaseRef: geoFireReference)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationAuthStatus()
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        }else{
           locationManager.requestWhenInUseAuthorization()
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        if let loc = userLocation.location {
            if !mapCenteredOnce {
                centerMapOnLocation(location: loc)
                mapCenteredOnce = true
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotaionView: MKAnnotationView?
        
        if annotation.isKind(of: MKUserLocation.self) {
            annotaionView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
            annotaionView?.image = UIImage(named: "ash")
        }else if let deqAmmo = mapView.dequeueReusableAnnotationView(withIdentifier: annoIdentifier) {
            annotaionView = deqAmmo
            annotaionView?.annotation = annotation
        }else{
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annoIdentifier)
            av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotaionView = av
        }
        
        if let annotaionView = annotaionView, let anno = annotation as? PokeAnnotation {
            
            annotaionView.canShowCallout = true
            annotaionView.image = UIImage(named: "\(anno.pokemonNumber)")
            let button = UIButton()
            button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            button.setImage(UIImage(named: "map"), for: .normal)
            annotaionView.rightCalloutAccessoryView = button
        }
        
        return annotaionView
    }
    
    func showSightingsOnMap(location: CLLocation) {
        
        let cirlcleQuery = geoFire.query(at: location, withRadius: 2.5)
        _ = cirlcleQuery?.observe(GFEventType.keyEntered, with: { (key, location) in
            if let key = key, let location = location {
                let anno = PokeAnnotation(coordinate: location.coordinate, pokemonNumber: Int(key)!)
                self.mapView.addAnnotation(anno)
            }
        })
    }
    
    func createSigting(forLocation location: CLLocation, withPokemon pokeID: Int) {
        
        geoFire.setLocation(location, forKey: "\(pokeID)")
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        showSightingsOnMap(location: location)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let anno = view.annotation as? PokeAnnotation {
            let place = MKPlacemark(coordinate: anno.coordinate)
            let destination = MKMapItem(placemark: place)
            destination.name = "Pokemon Sighting"
            
            let regionDistance: CLLocationDistance = 1000
            let regionSpan = MKCoordinateRegionMakeWithDistance(anno.coordinate, regionDistance, regionDistance)
            
            let options = [MKLaunchOptionsMapCenterKey : NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey : NSValue(mkCoordinateSpan : regionSpan.span), MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving] as [String : Any]
            
            MKMapItem.openMaps(with: [destination], launchOptions: options)
        }
    }
    
    @IBAction func spotRandomPoekemon(_ sender: Any) {
        
        let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        let rand = arc4random_uniform(151) + 1
        createSigting(forLocation: location, withPokemon: Int(rand))
    }
}

