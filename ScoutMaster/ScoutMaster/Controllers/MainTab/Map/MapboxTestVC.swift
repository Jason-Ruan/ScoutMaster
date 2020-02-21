//
//  MapboxTestVC.swift
//  ScoutMaster
//
//  Created by Jason Ruan on 1/31/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//

import UIKit
import Mapbox

class MapboxTestVC: UIViewController, UIScrollViewDelegate, UIToolbarDelegate {
    
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
    
    lazy var locationSymbolImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "location.fill"))
        iv.image = iv.image?.withTintColor(.white, renderingMode: .alwaysTemplate)
        return iv
    }()
    
    lazy var locationLabel: UILabel = {
        let label = UILabel()
        if let trail = self.trail {
            label.text = trail.location
            label.font = label.font.withSize(12)
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
        let mv = MGLMapView(frame: view.bounds)
        mv.delegate = self
        mv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mv.styleURL = MGLStyle.darkStyleURL
        if let trail = self.trail {
            mv.setCenter(CLLocationCoordinate2D(latitude: 40.8720442, longitude: -73.9256923), zoomLevel: 14, animated: false)
        }
        return mv
    }()
    
    lazy var trailDetailsTextView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        if let trail = self.trail {
            var trailDifficulty: String = ""
            
            switch trail.difficulty {
            case "green":
                trailDifficulty = "Easy"
            case "greenBlue":
                trailDifficulty = "Easy/Intermediate"
            case "blue":
                trailDifficulty = "Intermediate"
            case "blueBlack":
                trailDifficulty = "Intermediate/Difficult"
            case "black":
                trailDifficulty = "Difficult"
            case "blackBlack":
                trailDifficulty = "Extremely Difficult"
            default:
                trailDifficulty = "Unknown"
            }
            
            tv.text = """
            Difficulty: \(trailDifficulty)
            Distance: \(trail.length) miles
            Ascent: \(trail.ascent) ft
            Descent: \(trail.descent) ft
            Peak: \(trail.high) ft
            Condition: \(trail.conditionDetails ?? "")
            """
        }
        tv.backgroundColor = .clear
        tv.textColor = .white
        tv.font = tv.font?.withSize(16)
        tv.adjustsFontForContentSizeCategory = true
        tv.isScrollEnabled = false
        tv.sizeToFit()
        return tv
    }()
    
    lazy var toolBar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.delegate = self
        
        let favoriteButton = UIBarButtonItem(image: UIImage.init(systemName: "heart"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(toggleFavoriteStatus))
        let weatherButton = UIBarButtonItem(image: UIImage.init(systemName: "cloud"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(loadWeather))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexibleSpace, favoriteButton, weatherButton,flexibleSpace], animated: true)
        toolbar.barStyle = UIBarStyle(rawValue: -1)!
        
        return toolbar
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
    
    var scrollView: UIScrollView!
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setUpViews()
        drawTrailPolyline()
    }
    
    
    //MARK: - Objective-C Methods
    @objc func loadWeather() {
        guard let trail = self.trail else {return}
        DispatchQueue.main.async {
            DarkSky.getWeather(lat: trail.latitude, long: trail.longitude) { (result) in
                switch result {
                case .success(let sevenDayForecast):
                    print("got weather")
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    @objc func toggleFavoriteStatus() {
        print("favorited")
    }
    
    
    //MARK: - Private Functions
    
    private func setUpViews() {
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.delegate = self
        scrollView.backgroundColor = .black
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 1.5)
        
        scrollView.addSubview(mapView)
        scrollView.addSubview(trailDetailsTextView)
        scrollView.addSubview(toolBar)
        
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(locationSymbolImageView)
        scrollView.addSubview(locationLabel)
        
        scrollView.addSubview(summaryTextView)
        
        view.addSubview(scrollView)
        
        constrainViews()
    }
    
    private func constrainViews() {
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mapView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            mapView.widthAnchor.constraint(equalToConstant: scrollView.frame.width),
            mapView.heightAnchor.constraint(equalToConstant: scrollView.frame.height / 2.5)
        ])
        
        trailDetailsTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trailDetailsTextView.topAnchor.constraint(equalTo: mapView.topAnchor),
            trailDetailsTextView.leadingAnchor.constraint(equalTo: mapView.leadingAnchor)
        ])
        
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toolBar.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 30),
            toolBar.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            toolBar.widthAnchor.constraint(equalToConstant: scrollView.frame.width),
            toolBar.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: toolBar.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 15),
            nameLabel.widthAnchor.constraint(equalToConstant: scrollView.frame.width - 15),
            nameLabel.heightAnchor.constraint(equalToConstant: 75)
        ])
        
        locationSymbolImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            locationSymbolImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            locationSymbolImageView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            locationSymbolImageView.widthAnchor.constraint(equalToConstant: 15),
            locationSymbolImageView.heightAnchor.constraint(equalToConstant: 15)
        ])
        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: locationSymbolImageView.trailingAnchor),
            locationLabel.widthAnchor.constraint(equalToConstant: scrollView.frame.width - 15),
            locationLabel.heightAnchor.constraint(equalToConstant: 15)
        ])
        
        summaryTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            summaryTextView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 30),
            summaryTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            summaryTextView.widthAnchor.constraint(equalToConstant: view.frame.width),
            summaryTextView.heightAnchor.constraint(equalToConstant: 75)
        ])
        
        
        
        
        
    }
    
}


//MARK: Mapbox Methods
extension MapboxTestVC: MGLMapViewDelegate {
    
    func getCoordinates(data: Data){
        do {
            var coords = [(Double,Double)]()
            let rawCoords = (try LocationData.getCoordinatesFromData(data: data))!
            for i in rawCoords {
                coords.append((i[1],i[0]))
            }
            newCoords = coords
        }
        catch {
            print("error, could not decode geoJSON")
        }
    }
    
    
    
    func drawTrailPolyline() {
        // Parsing GeoJSON can be CPU intensive, do it on a background thread
        DispatchQueue.global(qos: .background).async(execute: {
            // Get the path for example.geojson in the app's bundle
            let jsonPath = Bundle.main.path(forResource: "blue-trail", ofType: "geojson")
            let url = URL(fileURLWithPath: jsonPath!)
            
            do {
                // Convert the file contents to a shape collection feature object
                let data = try Data(contentsOf: url)
                self.getCoordinates(data: data)
                guard let shapeCollectionFeature = try MGLShape(data: data, encoding: String.Encoding.utf8.rawValue) as? MGLShapeCollectionFeature else {
                    fatalError("Could not cast to specified MGLShapeCollectionFeature")
                }
                
                if let polyline = shapeCollectionFeature.shapes.first as? MGLPolylineFeature {
                    // Optionally set the title of the polyline, which can be used for:
                    //  - Callout view
                    //  - Object identification
                    polyline.title = polyline.attributes["name"] as? String
                    // Add the annotation on the main thread
                    DispatchQueue.main.async(execute: {
                        // Unowned reference to self to prevent retain cycle
                        [unowned self] in
                        self.mapView.addAnnotation(polyline)
                    })
                }
                
            } catch {
                print("GeoJSON parsing failed")
            }})
    }
    
    //MARK: - MV Delegates
    func mapView(_ mapView: MGLMapView, alphaForShapeAnnotation annotation: MGLShape) -> CGFloat {
        return 0.8
    }
    
    func mapView(_ mapView: MGLMapView, lineWidthForPolylineAnnotation annotation: MGLPolyline) -> CGFloat {
        // Set the line width for polyline annotations
        return 4.0
    }
    
    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        
        // Give our polyline a unique color by checking for its `title` property
        if annotation is MGLPolyline {
            if let trail = trail {
                switch trail.difficulty {
                case "green":
                    return #colorLiteral(red: 0, green: 1, blue: 0, alpha: 1)
                case "greenBlue":
                    return #colorLiteral(red: 0.1686150432, green: 0.8940697312, blue: 0.9647199512, alpha: 1)
                case "blue":
                    return #colorLiteral(red: 0.1324204504, green: 0.1454157829, blue: 1, alpha: 1)
                case "blueBlack":
                    return #colorLiteral(red: 0.2521547079, green: 0.2470324337, blue: 0.5169785023, alpha: 1)
                case "black":
                    return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                default:
                    return .white
                }
            }
        }
        return .white
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
}
