//
//  MapboxTestVC.swift
//  ScoutMaster
//
//  Created by Jason Ruan on 1/31/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//

import UIKit
import Mapbox
import Reachability

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
        if let trail = self.trail, let latitude = mv.userLocation?.coordinate.latitude, let longitude = mv.userLocation?.coordinate.longitude {
            mv.setCenter(CLLocationCoordinate2D(latitude: latitude, longitude: longitude), zoomLevel: 14, animated: false)
        }
        mv.showsUserLocation = true
        mv.userTrackingMode = .followWithHeading
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
    
    lazy var weatherCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 5
        
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 2), collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(WeatherCell.self, forCellWithReuseIdentifier: "weatherCell")
        
        cv.backgroundColor = .gray
        
        return cv
    }()
    
    lazy var forecastSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl()
        sc.insertSegment(withTitle: "Daily", at: 0, animated: true)
        sc.insertSegment(withTitle: "Hourly", at: 1, animated: true)
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(tappedForecastSegmentControl), for: .valueChanged)
        return sc
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
    
    var userTraversedCoordinates: [CLLocationCoordinate2D] = []
    
    let reachability = try? Reachability()
    
    var weatherForecast: [DayForecastDetails]? {
        didSet {
            self.weatherCollectionView.reloadData()
        }
    }
    
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
        view.backgroundColor = .cyan
        setUpViews()
        //        drawTrailPolyline()
        //        startReachability()
        loadWeather()
    }
    
    
    //MARK: - Objective-C Methods
    @objc func loadWeather() {
        guard let trail = self.trail else {return}
        DarkSkyAPIClient.manager.fetchWeatherForecast(lat: trail.latitude, long: trail.longitude) { (result) in
            switch result {
                case .success (let forecast):
                    self.forecastDetails = forecast
                
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    @objc func toggleFavoriteStatus() {
        print("favorited")
    }
    
    
    //MARK: - Private Functions
    
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
    
    //MARK: Private Functions
    
    private func setUpViews() {
        view.addSubview(weatherCollectionView)
        weatherCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            weatherCollectionView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            weatherCollectionView.widthAnchor.constraint(equalToConstant: view.frame.width),
            weatherCollectionView.heightAnchor.constraint(equalToConstant: view.frame.height / 3)
        ])
        
        view.addSubview(forecastSegmentedControl)
        forecastSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            forecastSegmentedControl.bottomAnchor.constraint(equalTo: weatherCollectionView.topAnchor, constant: -20),
            forecastSegmentedControl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            forecastSegmentedControl.widthAnchor.constraint(equalToConstant: view.frame.width),
            forecastSegmentedControl.heightAnchor.constraint(equalToConstant: 30)
        ])
        
    }
    
    //    private func setUpViews() {
    //        scrollView = UIScrollView(frame: view.bounds)
    //        scrollView.delegate = self
    //        scrollView.backgroundColor = .black
    //        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 1.5)
    //
    //        //        scrollView.addSubview(mapView)
    //        //        scrollView.addSubview(trailDetailsTextView)
    //        //        scrollView.addSubview(toolBar)
    //
    //        scrollView.addSubview(nameLabel)
    //        scrollView.addSubview(locationSymbolImageView)
    //        scrollView.addSubview(locationLabel)
    //
    //        scrollView.addSubview(summaryTextView)
    //        scrollView.addSubview(weatherCollectionView)
    //
    //        view.addSubview(scrollView)
    //
    //        constrainViews()
    //    }
    
    private func constrainViews() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
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
        
        weatherCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherCollectionView.topAnchor.constraint(equalTo: summaryTextView.bottomAnchor),
            weatherCollectionView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            weatherCollectionView.widthAnchor.constraint(equalToConstant: view.frame.width),
            weatherCollectionView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        
        
    }
    
    func startReachability() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            guard let reachability = self.reachability else { return }
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
            case .wifi:
                showAlertController(message: "Reachable via WiFi")
            case .cellular:
                showAlertController(message: "Reachable via Cellular")
            case .unavailable:
                showAlertController(message: "Network not reachable")
            default:
                showAlertController(message: "Network status unknown")
        }
    }
    
    func stopReachability() {
        guard let reachability = self.reachability else { return }
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
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
        let polyline = MGLPolyline(coordinates: self.userTraversedCoordinates, count: UInt(self.userTraversedCoordinates.count))
        DispatchQueue.main.async {
            self.mapView.addAnnotation(polyline)
        }
        
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
    
    func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
        
        if let userCoord = userLocation?.coordinate {
            self.userTraversedCoordinates.append(userCoord)
        }
        
        if self.userTraversedCoordinates.count >= 2 {
            drawTrailPolyline()
        }
        
    }
    
    
}

extension MapboxTestVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == weatherCollectionView {
            switch selectedForecast {
                case .daily:
                    return forecastDetails?.daily?.data?.count ?? 0
                case .hourly:
                    return forecastDetails?.hourly?.data?.count ?? 0
                case .none:
                    return 0
            }
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == weatherCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weatherCell", for: indexPath) as? WeatherCell else { return WeatherCell() }
            switch selectedForecast {
                case .daily:
                    cell.forecastType = .daily
                    let dayForecast = forecastDetails?.daily?.data?[indexPath.row]
                    cell.dateLabel.text = convertTimeToDate(forecastType: .daily, time: dayForecast?.time ?? 0)
                    cell.weatherIconImageView.image = getWeatherIcon(named: dayForecast?.icon ?? "")
                    cell.weatherSummaryLabel.text = dayForecast?.icon?.trimmingCharacters(in: CharacterSet.punctuationCharacters).capitalized
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
                    cell.weatherSummaryLabel.text = hourlyForecast?.icon?.trimmingCharacters(in: CharacterSet.punctuationCharacters).capitalized
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
        
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == weatherCollectionView {
            return CGSize(width: view.frame.width / 3, height: collectionView.frame.height * 0.9)
        } else {
            return CGSize(width: 200, height: 200)
        }
    }
    
    private func convertTimeToDate(forecastType: ForecastType, time: Int) -> String {
        let dateInput = Date(timeIntervalSinceNow: TimeInterval(exactly: time) ?? 0)
        let formatter = DateFormatter()
        switch forecastType {
            case .daily:
                formatter.dateFormat = "E M/d"
            case .hourly:
                formatter.dateFormat = "E h a"
        }
        formatter.locale = .current
        return formatter.string(from: dateInput)
    }
    
    private func getWeatherIcon(named: String) -> UIImage {
        switch named {
            case "clear-day":
                return UIImage(systemName: "sun.max.fill")!
            case "clear-night":
                return UIImage(systemName: "moon.fill")!
            case "wind":
                return UIImage(systemName: "wind")!
            case "rain":
                return UIImage(systemName: "cloud.rain.fill")!
            case "sleet":
                return UIImage(systemName: "cloud.sleet.fill")!
            case "snow":
                return UIImage(systemName: "cloud.snow.fill")!
            case "fog":
                return UIImage(systemName: "cloud.fog.fill")!
            case "cloudy":
                return UIImage(systemName: "cloud.fill")!
            case "hail":
                return UIImage(systemName: "cloud.hail.fill")!
            case "thunderstorm":
                return UIImage(systemName: "cloud.bolt.rain.fill")!
            case "tornado":
                return UIImage(systemName: "tornado")!
            default:
                return UIImage(systemName: "cloud.sun.fill")!
        }
    }
    
}


extension MapboxTestVC {
    func showAlertController(message: String) {
        let alertController = UIAlertController(title: "Network Status Changed", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
