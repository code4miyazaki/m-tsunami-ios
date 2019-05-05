//
//  MapViewController.swift
//  06-earthquake
//
//  Created by Yosei Ito on 2019/04/06.
//  Copyright © 2019 LmLab.net. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController,MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var csvLines = [String]()
    
    let lm = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lm.requestWhenInUseAuthorization()
        lm.startUpdatingLocation()
        guard let path = Bundle.main.path(forResource:"buildings_locations", ofType:"csv") else {
            print("csvファイルがないよ")
            return
        }
        let csvString = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
        csvLines = csvString.components(separatedBy: .newlines)
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        var r = mapView.region
        if let cood = lm.location?.coordinate {
            r.center = cood
        }
        r.span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        mapView.setRegion(r, animated: true)

        for line in csvLines {
            if line == "" { continue }
            let row = line.components(separatedBy: ",")
            let pa = MKPointAnnotation()
            let lat = Double(row[6]) ?? 0
            let lng = Double(row[7]) ?? 0
            pa.coordinate = CLLocationCoordinate2DMake(
                lat,lng)
            pa.title = row[1]
            pa.subtitle = "標高" + row[3] + "m " + row[4] + " " + row[5] + "階"
            mapView.addAnnotation(pa)
            print(row[0]+": "+row[1])
        }
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        var av = mapView.dequeueReusableAnnotationView(withIdentifier: "id") as? MKMarkerAnnotationView
        if av == nil {
            av = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "id")
            av!.glyphImage = UIImage(named: "building")
            av!.markerTintColor = UIColor.gray
        } else {
            av!.annotation = annotation
        }
        return av
    }
}
