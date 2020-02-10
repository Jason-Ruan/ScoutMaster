//
//  Dashboard.swift
//  ScoutMaster
//
//  Created by Sam Roman on 1/27/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//

import UIKit
import Mapbox

class DetailVC: UIViewController {
    
    //MARK: - UI Objects
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        if let trail = self.trail {
            label.text = trail.name
            label.font = label.font.withSize(50)
            label.textColor = .white
            label.adjustsFontSizeToFitWidth = true
            label.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.4)
        }
        return label
    }()
    
    lazy var locationLabel: UILabel = {
        let label = UILabel()
        if let trail = self.trail {
            label.text = trail.location
            label.font = label.font.withSize(14)
            label.textColor = .white
            label.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.4)
        }
        return label
    }()
    
    lazy var summaryTextView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        if let trail = self.trail {
            tv.text = trail.summary
            tv.textColor = .white
            tv.font = tv.font?.withSize(20)
            tv.adjustsFontForContentSizeCategory = true
            tv.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.4)
        }
        return tv
    }()
    
    lazy var mapView: MGLMapView = {
        let mv = MGLMapView()
        mv.delegate = self
        mv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mv.styleURL = MGLStyle.darkStyleURL
        if let trail = self.trail {
            //            mv.setCenter(CLLocationCoordinate2D(latitude: trail.latitude, longitude: trail.longitude), zoomLevel: 14, animated: false)
            mv.setCenter(CLLocationCoordinate2D(latitude: 40.8720442, longitude: -73.9256923), zoomLevel: 14, animated: false)
        }
        return mv
    }()
    
    lazy var trailDetailsTextView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        if let trail = self.trail {
            tv.text = """
            Difficulty: \(trail.difficulty)
            Distance: \(trail.length) miles
            Ascent: \(trail.ascent) ft
            Descent: \(trail.descent) ft
            Peak: \(trail.high) ft
            Condition: \(trail.conditionDetails ?? "")
            """
        }
        tv.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.4)
        tv.textColor = .white
        tv.font = tv.font?.withSize(20)
        tv.adjustsFontForContentSizeCategory = true
        return tv
    }()
    
    
    //MARK: - Private Properties
    var trail: Trail?
    
    var coordinates = [CLLocationCoordinate2D]()
    
    var newCoords: [(Double,Double)]! {
        didSet {
            for i in newCoords {
                coordinates.append(CLLocationCoordinate2D(latitude: i.0, longitude: i.1))
            }
        }
    }
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setUpViews()
        drawTrailPolyline()
    }
    
    
    //MARK: - Private Functions
    
    private func setUpViews() {
        view.addSubview(nameLabel)
        view.addSubview(locationLabel)
        view.addSubview(summaryTextView)
        view.addSubview(mapView)
        view.addSubview(trailDetailsTextView)
        
        constrainViews()
    }
    
    private func constrainViews() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            nameLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            nameLabel.widthAnchor.constraint(equalToConstant: view.frame.width),
            nameLabel.heightAnchor.constraint(equalToConstant: 75)
        ])
        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            locationLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            locationLabel.widthAnchor.constraint(equalToConstant: view.frame.width),
            locationLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        summaryTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            summaryTextView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 30),
            summaryTextView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            summaryTextView.widthAnchor.constraint(equalToConstant: view.frame.width),
            summaryTextView.heightAnchor.constraint(equalToConstant: 75)
        ])
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: summaryTextView.bottomAnchor, constant: 50),
            mapView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            mapView.widthAnchor.constraint(equalToConstant: view.frame.width),
            mapView.heightAnchor.constraint(equalToConstant: view.frame.height / 2)
        ])
        
        trailDetailsTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trailDetailsTextView.bottomAnchor.constraint(equalTo: mapView.bottomAnchor),
            trailDetailsTextView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            trailDetailsTextView.widthAnchor.constraint(equalToConstant: view.frame.width),
            trailDetailsTextView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
}


}
