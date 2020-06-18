//
//  ViewController.swift
//  CapitalCities
//
//  Created by Ma Xueyuan on 2020/06/18.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import UIKit
import MapKit
import SafariServices

class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), url: "https://en.wikipedia.org/wiki/London")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), url: "https://en.wikipedia.org/wiki/Oslo")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), url: "https://en.wikipedia.org/wiki/Paris")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), url: "https://en.wikipedia.org/wiki/Rome")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), url: "https://en.wikipedia.org/wiki/Washington,_D.C.")
        
        mapView.addAnnotations([london, oslo, paris, rome, washington])
        mapView.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(changeMapType))
    }
    
    @objc func changeMapType() {
        let ac = UIAlertController(title: "Choose Map Type", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "hybrid", style: .default, handler: { [weak self] (_) in
            self?.mapView.mapType = .hybrid
        }))
        ac.addAction(UIAlertAction(title: "hybridFlyover", style: .default, handler: { [weak self] (_) in
            self?.mapView.mapType = .hybridFlyover
        }))
        ac.addAction(UIAlertAction(title: "mutedStandard", style: .default, handler: { [weak self] (_) in
            self?.mapView.mapType = .mutedStandard
        }))
        ac.addAction(UIAlertAction(title: "satellite", style: .default, handler: { [weak self] (_) in
            self?.mapView.mapType = .satellite
        }))
        ac.addAction(UIAlertAction(title: "satelliteFlyover", style: .default, handler: { [weak self] (_) in
            self?.mapView.mapType = .satelliteFlyover
        }))
        ac.addAction(UIAlertAction(title: "standard", style: .default, handler: { [weak self] (_) in
            self?.mapView.mapType = .standard
        }))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        
        
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
            annotationView.annotation = annotation
            annotationView.pinTintColor = .black
            return annotationView
        } else {
            let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.canShowCallout = true
            let btn = UIButton(type: .detailDisclosure)
            annotationView.rightCalloutAccessoryView = btn
            annotationView.pinTintColor = .black
            return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        guard let placeUrl = URL(string: capital.url) else { return }
        
        let safari = SFSafariViewController(url: placeUrl)
        present(safari, animated: true)
    }
}
