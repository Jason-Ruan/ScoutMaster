//
//  Dashboard.swift
//  ScoutMaster
//
//  Created by Sam Roman on 1/27/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//

import UIKit
import Mapbox
import SafariServices

class DetailVC: UIViewController, UIScrollViewDelegate {
    
    //MARK: - UI Objects
    lazy var mapView: MGLMapView = {
        let mv = MGLMapView(frame: view.bounds)
        mv.delegate = self
        mv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mv.styleURL = MGLStyle.darkStyleURL
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
            Condition: \(trail.conditionDetails ?? "N/A")
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
    
    lazy var favoriteButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: UIImage.SymbolWeight.bold)
        button.setImage(UIImage(systemName: "heart", withConfiguration: imageConfig), for: .normal)
        button.addTarget(self, action: #selector(faveTrail), for: .touchUpInside)
        return button
    }()
    
    lazy var webLinkButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: UIImage.SymbolWeight.bold)
        button.setImage(UIImage.init(systemName: "safari", withConfiguration: imageConfig), for: .normal)
        button.addTarget(self, action: #selector(openTrailLink), for: .touchUpInside)
        return button
    }()
    
    lazy var buttonStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillProportionally
        sv.alignment = .center
        sv.spacing = 10
        
        sv.addArrangedSubview(self.favoriteButton)
        let favLabel = UILabel()
        favLabel.text = "Favorite"
        favLabel.textColor = .systemBlue
        sv.addArrangedSubview(favLabel)
        
        sv.addArrangedSubview(self.webLinkButton)
        let webLabel = UILabel()
        webLabel.text = "Website"
        webLabel.textColor = .systemBlue
        sv.addArrangedSubview(webLabel)
        
        return sv
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
    
    lazy var weatherCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 5
        
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 2), collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(WeatherCell.self, forCellWithReuseIdentifier: "weatherCell")
        
        cv.backgroundColor = .clear
        
        return cv
    }()
    
    lazy var forecastSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl()
        sc.insertSegment(withTitle: "Daily", at: 0, animated: true)
        sc.insertSegment(withTitle: "Hourly", at: 1, animated: true)
        sc.selectedSegmentIndex = 0
        sc.backgroundColor = .lightGray
        sc.addTarget(self, action: #selector(tappedForecastSegmentControl), for: .valueChanged)
        return sc
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
    
    var scrollView: UIScrollView!
    
    private var forecastDetails: WeatherForecast? {
        didSet {
            selectedForecast = .daily
        }
    }
    
    private var selectedForecast: ForecastType? {
        didSet {
            weatherCollectionView.reloadData()
        }
    }
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setUpViews()
        drawTrailPolyline()
        loadWeather()
    }
    
    //    MARK: - Objective-C Methods
    @objc func faveTrail() {
        
        guard let user = FirebaseAuthService.manager.currentUser else {
            print("Error- no current user")
            return
        }
        // to be done: set parameters
        let newFaveTrail = FavedHikes(id: trail.id, name: trail.name, type: trail.type, summary: trail.summary, difficulty: trail.difficulty, location: trail.location, url: trail.url, img: trail.imgMedium, length: trail.length, ascent: trail.ascent, descent: trail.descent, high: trail.high, low: trail.low, longitude: trail.longitude, latitude: trail.latitude, creatorId: user.uid)
        
        FirestoreService.manager.createFaveHikes(post: newFaveTrail) { (result) in
            switch result {
                case .failure(let error):
                    print(error)
                case .success(()):
                    print("yes")
                    self.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }
        }
    }
    
    @objc func openTrailLink() {
        guard let trail = self.trail, let trailURL = URL(string: trail.url) else {return}
        let safariWebView = SFSafariViewController(url: trailURL)
        present(safariWebView, animated: true, completion: nil)
    }
    
    @objc private func segueToMap() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window
            else { return }
        if let tabBarController = window.rootViewController as? MainTabBarViewController {
            tabBarController.selectedIndex = 1
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func tappedForecastSegmentControl() {
        switch self.forecastSegmentedControl.selectedSegmentIndex {
            case 0:
                selectedForecast = .daily
            case 1:
                selectedForecast = .hourly
            default:
                selectedForecast = .daily
        }
    }
    
    
    //MARK: - Private Functions
    
    private func setUpViews() {
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.delegate = self
        scrollView.backgroundColor = .black
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 1.5)
        
        scrollView.addSubview(mapView)
        scrollView.addSubview(trailDetailsTextView)
        scrollView.addSubview(buttonStackView)
        
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(locationSymbolImageView)
        scrollView.addSubview(locationLabel)
        
        scrollView.addSubview(startButton)
        scrollView.addSubview(summaryTextView)
        
        scrollView.addSubview(forecastSegmentedControl)
        scrollView.addSubview(weatherCollectionView)
        
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
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 20),
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
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 30),
            buttonStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 15),
            buttonStackView.widthAnchor.constraint(equalToConstant: 250),
            buttonStackView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        startButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            startButton.widthAnchor.constraint(equalToConstant: 90),
            startButton.heightAnchor.constraint(equalToConstant: 50),
            startButton.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 20),
            startButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
        
        summaryTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            summaryTextView.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 40),
            summaryTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            summaryTextView.widthAnchor.constraint(equalToConstant: view.frame.width),
            summaryTextView.heightAnchor.constraint(equalToConstant: 75)
        ])
        
        forecastSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            forecastSegmentedControl.bottomAnchor.constraint(equalTo: summaryTextView.bottomAnchor, constant: 100),
            forecastSegmentedControl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            forecastSegmentedControl.widthAnchor.constraint(equalToConstant: view.frame.width - 30),
            forecastSegmentedControl.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        weatherCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherCollectionView.topAnchor.constraint(equalTo: forecastSegmentedControl.bottomAnchor),
            weatherCollectionView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            weatherCollectionView.widthAnchor.constraint(equalToConstant: view.frame.width - 30),
            weatherCollectionView.heightAnchor.constraint(equalToConstant: 250)
        ])
        
    }
    
    private func loadWeather() {
        DarkSkyAPIClient.manager.fetchWeatherForecast(lat: self.trail.latitude, long: self.trail.longitude) { (result) in
            switch result {
                case .success(let weatherForecast):
                    self.forecastDetails = weatherForecast
                case .failure(let error):
                    print(error)
            }
        }
    }
    
}


//MARK: - Mapbox Methods
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
