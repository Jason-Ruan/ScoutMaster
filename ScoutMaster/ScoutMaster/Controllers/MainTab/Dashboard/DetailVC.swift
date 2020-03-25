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
        let mv = MGLMapView(frame: view.bounds)
        mv.delegate = self
        mv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mv.styleURL = MGLStyle.lightStyleURL
        if let trail = self.trail {
            //            mv.setCenter(CLLocationCoordinate2D(latitude: trail.latitude, longitude: trail.longitude), zoomLevel: 14, animated: false)
            mv.setCenter(CLLocationCoordinate2D(latitude: 40.668, longitude: -73.9738), zoomLevel: 14, animated: false)
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
    
    lazy var startButton: UIButton = {
        var button = UIButton()
        button.addTarget(self, action: #selector(segueToMap), for: .touchUpInside)
        button.backgroundColor = .init(white: 0.2, alpha: 0.8)
        button.layer.cornerRadius = 15
        button.titleLabel?.text = "Start"
        button.titleLabel?.textColor = .white
        button.setTitle("Start", for: .normal)
        return button
    }()
    
    
    lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.init(systemName: "heart"), for: .normal)
        button.addTarget(self, action: #selector(faveTrail), for: .touchUpInside)

//        self.button = UIButton.ButtonType.system;, targetViewController(forAction: self, sender: #selector())
        
        return button
    }()
    
    lazy var weatherButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setImage(UIImage.init(systemName: "cloud"), for: .normal)
        return button
    }()
    
    
    //MARK: - Private Properties
    var trail: Trail!
    
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
    
//    MARK: Objective C
    @objc func faveTrail() {
        
        guard let user = FirebaseAuthService.manager.currentUser else {
            print("Error- no current user")
            return
        }
        // to be done: set parameters
        let newFaveTrail = FavedHikes(id: trail.id, name: trail.name, type: trail.type, summary: trail.summary, difficulty: trail.difficulty, location: trail.location, url: trail.url, img: trail.imgMedium, length: trail.length, ascent: trail.ascent, descent: trail.descent, high: trail.high, low: trail.low, longitude: trail.longitude, latitude: trail.latitude, creatorId: user.uid, favedId: "")
        
        FirestoreService.manager.createFaveHikes(post: newFaveTrail) { (result) in
            switch result {
            case .failure(let error):
                print(error)
//                parenses in parenses
            case .success(()):
                print("yes")
                self.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }
        }
    }
    
    
    
    //MARK: - Private Functions
    
    @objc private func segueToMap() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                               let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window
                               else { return }
        if let tabBarController = window.rootViewController as? MainTabBarViewController {
               tabBarController.selectedIndex = 1
           }
        dismiss(animated: true, completion: nil)
    }
    
    private func setUpViews() {
        view.addSubview(nameLabel)
        view.addSubview(locationLabel)
        view.addSubview(summaryTextView)
        view.addSubview(mapView)
        view.addSubview(trailDetailsTextView)
        view.addSubview(favoriteButton)
        view.addSubview(weatherButton)
        view.addSubview(startButton)
        
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
        
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            favoriteButton.topAnchor.constraint(equalTo: locationLabel.bottomAnchor),
            favoriteButton.leadingAnchor.constraint(equalTo: locationLabel.leadingAnchor, constant: 30),
            favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            favoriteButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        weatherButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherButton.topAnchor.constraint(equalTo: locationLabel.bottomAnchor),
            weatherButton.leadingAnchor.constraint(equalTo: favoriteButton.trailingAnchor),
            weatherButton.widthAnchor.constraint(equalToConstant: 30),
            weatherButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        startButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            startButton.widthAnchor.constraint(equalToConstant: 90),
            startButton.heightAnchor.constraint(equalToConstant: 50),
            startButton.bottomAnchor.constraint(equalTo: mapView.topAnchor, constant: -5),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)])
        
    }
    
}


//MARK: Mapbox Methods
extension DetailVC: MGLMapViewDelegate {
    
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
            let jsonPath = Bundle.main.path(forResource: "prospectparkloop", ofType: "geojson")
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
            switch annotation.title {
            case "Blue Trail":
                return .systemBlue
            case "Prospect Park Trail Loop":
                return .systemOrange
            default:
                return .white
            }
        }
        return .white
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
}

/*
extension DetailVC: ButtonPressed {
    
    /*
    
    func buttonPressed(tag: Int) {
        print(tag)
        /*
        let indexSelected = IndexPath(row: tag, section: 0)
        let select = thingsTableView.cellForRow(at: indexSelected) as! ThingsCustomTVC
        */
        
        let ticketData = eventData[tag]
        let fireThing = FavedEvents(imageData: ticketData.images.first?.url ?? "", objectName: ticketData.name, objectSecondary: ticketData.dates.start.localDate, objectID: ticketData.id, creatorID: user.uid)
        
        FirestoreService.manager.createfave(faved: fireThing) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(()):
                print("yes")
            select.buttonOutlet.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }
        }
    
    }
 */
}
 */
