//
//  MapboxTestVC.swift
//  ScoutMaster
//
//  Created by Jason Ruan on 1/31/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//

import UIKit
import Mapbox
import MapboxAnnotationExtension

class MapboxTestVC: UIViewController {
    
    //MARK: - UI Objects
    lazy var mapView: MGLMapView = {
        let mapView = MGLMapView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 100))
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: 40.74699, longitude: -73.98742), zoomLevel: 12, animated: false)
        mapView.delegate = self
        return mapView
    }()
    
    lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        return toolbar
    }()
    
    
    //MARK: - Properties
    
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(mapView)
        view.addSubview(toolbar)
        setUpToolbar()
    }
    
    
    //MARK: - Private Functions
    private func setUpToolbar() {
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toolbar.topAnchor.constraint(equalTo: mapView.bottomAnchor),
            toolbar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            toolbar.widthAnchor.constraint(equalToConstant: view.frame.width),
            toolbar.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        let toggleStyleButton = UIBarButtonItem(title: "Switch Style", style: .plain, target: self, action: #selector(toggleMapStyle))
        
        let liveTrackingButton = UIBarButtonItem(title: "Live Track", style: .plain, target: self, action: #selector(toggleUserTracking))
        
        toolbar.items = [toggleStyleButton]
    }
    
    //MARK: - Objc Functions
    @objc func toggleMapStyle() {
        let actionSheet = UIAlertController(title: "Choose map style", message: nil, preferredStyle: .actionSheet)
        
        let lightStyle = UIAlertAction(title: "Light", style: .default) { (action) in
            self.mapView.styleURL = MGLStyle.lightStyleURL
        }
        
        let darkStyle = UIAlertAction(title: "Dark", style: .default) { (action) in
            self.mapView.styleURL = MGLStyle.darkStyleURL
        }
        
        let satelliteStyle = UIAlertAction(title: "Satellite", style: .default) { (action) in
            self.mapView.styleURL = MGLStyle.satelliteStyleURL
        }
        
        let outdoorsStyle = UIAlertAction(title: "Outdoors", style: .default) { (action) in
            self.mapView.styleURL = MGLStyle.outdoorsStyleURL
        }
        
        let streetStyle = UIAlertAction(title: "Street", style: .default) { (action) in
            self.mapView.styleURL = MGLStyle.streetsStyleURL
        }
        
        actionSheet.addAction(lightStyle)
        actionSheet.addAction(darkStyle)
        actionSheet.addAction(satelliteStyle)
        actionSheet.addAction(outdoorsStyle)
        actionSheet.addAction(streetStyle)
        
        present(actionSheet, animated: true, completion: nil)
        
    }
    
    @objc func toggleUserTracking() {
        
    }
    
    
}

extension MapboxTestVC: MGLMapViewDelegate {
    //MARK: - Map Overlay
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        let lineAnnotationController = MGLLineAnnotationController(mapView: self.mapView)
        
        let lineCoordinates = [
            CLLocationCoordinate2D(latitude: 40.75, longitude: -73.98),
            CLLocationCoordinate2D(latitude: 40.74699, longitude: -73.98742),
            CLLocationCoordinate2D(latitude: 40.73, longitude: -73.99),
            CLLocationCoordinate2D(latitude: 40.72, longitude: -74)
        ]
        
        let line = MGLLineStyleAnnotation(coordinates: lineCoordinates, count: UInt(lineCoordinates.count))
        line.lineColor = .purple
        line.lineWidth = 5
        lineAnnotationController.addStyleAnnotation(line)
    }
}
