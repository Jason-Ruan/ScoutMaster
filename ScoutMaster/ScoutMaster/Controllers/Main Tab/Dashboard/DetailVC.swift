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
        // Do any additional setup after loading the view.
    }


}
