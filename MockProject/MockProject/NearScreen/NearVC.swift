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
    @IBOutlet weak var collectionView: UICollectionView!
    var venues = [Venue]()
    private let lat = 21.017461
    private let long = 105.780308
    private let radius : CLLocationDistance = 1000
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let initialLocation = CLLocation(latitude: lat, longitude: long)
        zoomMapOn(location: initialLocation)
        let pin = [Venue(title: "adad", locationName: "Dâd", coordinate: CLLocationCoordinate2D(latitude: 21.017212, longitude: 105.778563)),Venue(title: "adad", locationName: "Dâd", coordinate: CLLocationCoordinate2D(latitude: 21.018334, longitude: 105.783799))]
        mapView.addAnnotations(pin)
        getApi()
    }
    
    func getApi() {
        let url = "http://812f8957.ngrok.io/18175d1_mobile_100_fresher/public/api/v0/listNearlyEvents?token=\(User.instance.token ?? "")&radius=\(radius)&latitude=\(lat)&longitue=\(long)"
        getGenericData(urlString: url) { (json : NearStruct) in
            let venueJSONs = json.response.events
            for venueJSON in venueJSONs {
                let venue = Venue.from(json: venueJSON)
                self.venues.append(venue)
            }
            self.mapView.addAnnotations(self.venues)
        }
    }
    
    func zoomMapOn(location : CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: radius, longitudinalMeters: radius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

}

extension NearVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is Venue {
            let identifier = "pin"
            var view = MKPinAnnotationView()
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier){
                dequeuedView.annotation = annotation
                view = dequeuedView as! MKPinAnnotationView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
    
            }
            return view
        }
        return nil
    }
}
