//
//  NearVC.swift
//  MockProject
//
//  Created by AnhDCT on 9/19/19.
//  Copyright © 2019 AnhDCT. All rights reserved.
//

import UIKit
import MapKit


class NearVC: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var viewCollection: UIView!
    
    var locationManager = CLLocationManager()
    var venues = [Venue]()
    var events = [Event]()
    private var lat = 21.017461
    private var long = 105.780308
    private let radius : CLLocationDistance = 1000
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let initialLocation = CLLocation(latitude: lat, longitude: long)
        zoomMapOn(location: initialLocation)
        getApi()
        NotificationCenter.default.addObserver(self, selector: #selector(selectAnnotation), name: NSNotification.Name("annotation"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkLocationService()
    }
    
    @objc func selectAnnotation(notification: NSNotification) {
        let id = notification.userInfo?["pin"] as! Int
        mapView.annotations.forEach { (annotation) in
            if annotation is MKUserLocation {
                return
            }
            let location = annotation as! Venue
            if location.id == id {
                mapView.selectAnnotation(annotation, animated: true)
            }
        }
    }
    
    func getApi() {
        let url = "http://812f8957.ngrok.io/18175d1_mobile_100_fresher/public/api/v0/listNearlyEvents?token=\(User.instance.token ?? "")&radius=\(radius)&latitude=\(lat)&longitue=\(long)"
        getGenericData(urlString: url) { (json : NearStruct) in
            DispatchQueue.main.async {
                self.events = json.response.events
                for venueJSON in self.events {
                    let venue = Venue.from(json: venueJSON)
                    self.venues.append(venue)
                }
                self.mapView.addAnnotations(self.venues)
                self.addCollectionView()
            }
        }
    }
    
    func zoomMapOn(location : CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: radius, longitudinalMeters: radius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func addCollectionView(){
        let nearCollectionViewVC = NearCollectionViewVC(events: events)
        addChild(nearCollectionViewVC)
        viewCollection.addSubview(nearCollectionViewVC.view)
        nearCollectionViewVC.view.constraintToAllSides(of: viewCollection)
        didMove(toParent: self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension NearVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let location = annotation as! Venue
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        switch location.status {
        case 0:
            annotationView.pinTintColor = .white
        case 1:
            annotationView.pinTintColor = .red
        default:
            annotationView.pinTintColor = .yellow
        }        
        annotationView.canShowCallout = true
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is MKUserLocation {
            return
        }
        view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        let location = view.annotation as! Venue
        for i in 0..<events.count {
            if events[i].id == location.id  {
                NotificationCenter.default.post(name: NSNotification.Name("Location"), object: self, userInfo: ["indexPath" : i])
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.transform = CGAffineTransform(scaleX: 1, y: 1)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let me = CLLocation(latitude: lat, longitude: long)
        let latCenter = mapView.centerCoordinate.latitude
        let longCenter = mapView.centerCoordinate.longitude
        let center = CLLocation(latitude: latCenter, longitude: longCenter)
        if me.distance(from: center) > 1000 {
            lat = latCenter
            long = longCenter
            venues.removeAll()
            events.removeAll()
            mapView.removeAnnotations(mapView.annotations)
            mapView.setRegion(MKCoordinateRegion(center: center.coordinate, latitudinalMeters: radius, longitudinalMeters: radius), animated: true)
            getApi()
        }
    }
}

extension NearVC: CLLocationManagerDelegate {
    func checkLocationService(){
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
//        } else {
//                    if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
//                        mapView.showsUserLocation = true
//                    } else {
//                        let arlert = UIAlertController(title: "", message: "Xin hãy cấp quyền sử dụng location để có thể trải nghiệm chức năng này", preferredStyle: .alert)
//                        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//                        let setting = UIAlertAction(title: "Setting", style: .default) { (a) in
//                                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
//                        }
//                        arlert.addAction(cancel)
//                        arlert.addAction(setting)
//                        present(arlert, animated: true, completion: nil)
//
//                    }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.mapView.showsUserLocation = true
    }
}

