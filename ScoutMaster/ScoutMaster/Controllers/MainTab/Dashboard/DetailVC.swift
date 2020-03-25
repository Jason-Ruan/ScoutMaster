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
import Reachability

class DetailVC: UIViewController, UIScrollViewDelegate {
    
    //MARK: - UI Objects
    lazy var mapView: MGLMapView = {
        let mv = MGLMapView(frame: view.bounds)
        mv.delegate = self
        mv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mv.styleURL = MGLStyle.darkStyleURL
        if let trail = self.trail {
            mv.setCenter(CLLocationCoordinate2D(latitude: trail.latitude, longitude: trail.longitude), zoomLevel: 14, animated: false)
            //            mv.setCenter(CLLocationCoordinate2D(latitude: 40.668, longitude: -73.9738), zoomLevel: 14, animated: false)
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
    
    lazy var mapResizingButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.addTarget(self, action: #selector(adjustMapView), for: .touchUpInside)
        return button
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
        let favButton = UIButton(type: UIButton.ButtonType.system)
        favButton.setTitle("Favorite", for: .normal)
        favButton.setTitleColor(.systemBlue, for: .normal)
        favButton.addTarget(self, action: #selector(faveTrail), for: .touchUpInside)
        sv.addArrangedSubview(favButton)
        
        sv.addArrangedSubview(self.webLinkButton)
        let webButton = UIButton(type: UIButton.ButtonType.system)
        webButton.setTitle("Website", for: .normal)
        webButton.setTitleColor(.systemBlue, for: .normal)
        webButton.addTarget(self, action: #selector(openTrailLink), for: .touchUpInside)
        sv.addArrangedSubview(webButton)
        
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
            label.backgroundColor = .clear
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
    
    lazy var descriptionHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.textColor = .lightText
        label.font = label.font.withSize(20)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    lazy var descriptionTextView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        if let trail = self.trail {
            tv.text = trail.summary
            tv.textColor = .white
            tv.font = tv.font?.withSize(16)
            tv.adjustsFontForContentSizeCategory = true
            tv.backgroundColor = .clear
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
    
    lazy var weatherHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Weather Forecast"
        label.textColor = .lightText
        label.font = label.font.withSize(20)
        label.adjustsFontForContentSizeCategory = true
        return label
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
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Could not access the AppDelegate")
            return
        }
        guard let reachability = appDelegate.reachability else {
            print("Could not find property called reachabilty in the appDelegate")
            return
        }
        
        switch reachability.connection {
            case .wifi, .cellular:
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
            default:
                showAlertController(title: "Uh-oh! Looks like you're not connected online.", message: "Please check for a place with a stable internet connection and try again.")
        }
        
    }
    
    @objc func openTrailLink() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Could not access the AppDelegate")
            return
        }
        guard let reachability = appDelegate.reachability else {
            print("Could not find property called reachabilty in the appDelegate")
            return
        }
        
        switch reachability.connection {
            case .wifi, .cellular:
                guard let trail = self.trail, let trailURL = URL(string: trail.url) else {return}
                let safariWebView = SFSafariViewController(url: trailURL)
                present(safariWebView, animated: true, completion: nil)
            default:
                showAlertController(title: "Uh-oh! Looks like you're not connected online.", message: "Please check for a place with a stable internet connection and try again.")
        }
    }
    
    @objc private func segueToMap() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window
            else { return }
        if let tabBarController = window.rootViewController as? MainTabBarViewController, let mapVC = tabBarController.viewControllers![1] as? MapVC {
            tabBarController.selectedIndex = 1
            mapVC.forecastDetails = self.forecastDetails
            mapVC.trail = self.trail
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
        
        weatherCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: true)
        
    }
    
    @objc func adjustMapView() {
        if mapResizingButton.imageView?.image == UIImage(systemName: "chevron.down") {
            
            NSLayoutConstraint.deactivate(self.mapView.constraintsAffectingLayout(for: .vertical))
            self.mapView.heightAnchor.constraint(equalToConstant: self.view.frame.height - 200).isActive = true
            mapResizingButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else if mapResizingButton.imageView?.image == UIImage(systemName: "chevron.up") {
            NSLayoutConstraint.deactivate(self.mapView.constraintsAffectingLayout(for: .vertical))
            self.mapView.heightAnchor.constraint(equalToConstant: self.scrollView.frame.height / 2.5).isActive = true
            mapResizingButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                
                self.view.layoutIfNeeded()
            }, completion: nil)
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
        scrollView.addSubview(mapResizingButton)
        scrollView.addSubview(buttonStackView)
        
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(locationSymbolImageView)
        scrollView.addSubview(locationLabel)
        
        scrollView.addSubview(startButton)
        scrollView.addSubview(descriptionHeaderLabel)
        scrollView.addSubview(descriptionTextView)
        
        scrollView.addSubview(weatherHeaderLabel)
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
        
        mapResizingButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapResizingButton.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 5),
            mapResizingButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            mapResizingButton.widthAnchor.constraint(equalToConstant: 30),
            mapResizingButton.heightAnchor.constraint(equalToConstant: 30)
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
        
        descriptionHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionHeaderLabel.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 50),
            descriptionHeaderLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            descriptionHeaderLabel.widthAnchor.constraint(equalToConstant: view.frame.width / 3),
            descriptionHeaderLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: descriptionHeaderLabel.bottomAnchor, constant: 5),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 75)
        ])
        
        weatherHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherHeaderLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 50),
            weatherHeaderLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            weatherHeaderLabel.widthAnchor.constraint(equalToConstant: view.frame.width / 2),
        ])
        
        forecastSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            forecastSegmentedControl.topAnchor.constraint(equalTo: weatherHeaderLabel.bottomAnchor, constant: 5),
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
    
    private func showAlertController(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
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


//MARK: - CollectionView Methods
extension DetailVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch selectedForecast {
            case .daily:
                return forecastDetails?.daily?.data?.count ?? 0
            case .hourly:
                return forecastDetails?.hourly?.data?.count ?? 0
            case .none:
                return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weatherCell", for: indexPath) as? WeatherCell else { return WeatherCell() }
        switch selectedForecast {
            case .daily:
                cell.forecastType = .daily
                let dayForecast = forecastDetails?.daily?.data?[indexPath.row]
                cell.dateLabel.text = convertTimeToDate(forecastType: .daily, time: dayForecast?.time ?? 0)
                cell.weatherIconImageView.image = getWeatherIcon(named: dayForecast?.icon ?? "")
                cell.weatherSummaryLabel.text = dayForecast?.icon?.replacingOccurrences(of: "-", with: " ").capitalized
                cell.lowTemperature.text = """
                Low
                \(dayForecast?.temperatureLow?.description ?? "N/A")\u{00B0}
                """
                
                cell.highTemperature.text = """
                High
                \(dayForecast?.temperatureLow?.description  ?? "N/A")\u{00B0}
                """
                return cell
            case .hourly:
                cell.forecastType = .hourly
                let hourlyForecast = forecastDetails?.hourly?.data?[indexPath.row]
                cell.dateLabel.text = convertTimeToDate(forecastType: .hourly, time: hourlyForecast?.time ?? 0)
                cell.weatherIconImageView.image = getWeatherIcon(named: hourlyForecast?.icon ?? "")
                cell.weatherSummaryLabel.text = hourlyForecast?.icon?.replacingOccurrences(of: "-", with: " ").capitalized
                cell.lowTemperature.text = """
                \(hourlyForecast?.temperature?.description ?? "N/A")\u{00B0}
                """
                if let precipitationChance = hourlyForecast?.precipProbability {
                    cell.highTemperature.text = """
                    Precip
                    \(String(format: "%.0f", precipitationChance * 100))%
                    """
            }
            default:
                return cell
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 3, height: collectionView.frame.height * 0.9)
    }
    
}
