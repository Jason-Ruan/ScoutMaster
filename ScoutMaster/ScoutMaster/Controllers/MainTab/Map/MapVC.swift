import UIKit
import Mapbox
import MapboxAnnotationExtension

class MapVC: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, AddPointViewDelegate {
    
    
    //MARK: - UI Variables
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.backgroundColor = .init(white: 0.2, alpha: 0)
        cv.register(MapCell.self, forCellWithReuseIdentifier: "mapCell")
        cv.isScrollEnabled = true
        cv.contentInset = .init(top: 0, left: 4, bottom: 0, right: 4)
        return cv
    }()
    
    lazy var locationButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .init(white: 0.2, alpha: 0.8)
        button.layer.cornerRadius = 25
        button.tintColor = .white
        button.setBackgroundImage(UIImage(systemName: "location.circle"), for: .normal)
        button.addTarget(self, action: #selector(locationButtonTapped(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var addAnnotationButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .init(white: 0.2, alpha: 0.8)
        button.layer.cornerRadius = 25
        button.tintColor = .white
        button.setBackgroundImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.addTarget(self, action: #selector(showAddPointView(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var recordTrailButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 25
        button.backgroundColor = .init(white: 0.2, alpha: 0.8)
        button.tintColor = .white
        button.setBackgroundImage(UIImage(systemName: "smallcircle.fill.circle"), for: .normal)
        button.addTarget(self, action: #selector(recordTrailPrompt(button:)), for: .touchUpInside)
        return button
    }()
    
    lazy var addPopUp: AddPointView = {
        let popUp = AddPointView()
        popUp.delegate = self
        return popUp
    }()
    
    lazy var forecastSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl()
        sc.insertSegment(withTitle: "Hourly", at: 0, animated: true)
        sc.insertSegment(withTitle: "Daily", at: 1, animated: true)
        sc.selectedSegmentIndex = 0
        sc.backgroundColor = .lightGray
        sc.addTarget(self, action: #selector(tappedForecastSegmentControl), for: .valueChanged)
        return sc
    }()
    
    lazy var weatherTableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.layer.borderWidth = 3
        tv.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0.5, alpha: 0.5)
        tv.register(WeatherTableViewCell.self, forCellReuseIdentifier: "weatherTableViewCell")
        return tv
    }()
    
    
    //MARK: - Properties
    
    var trail: Trail? {
        didSet{
            drawTrailPolyline()
        }
    }
    
    var mapView = MapSettings.customMap
    
    var newCoords: [(Double,Double)]! {
        didSet {
            for i in newCoords {
                coordinates.append(CLLocationCoordinate2D(latitude: i.0, longitude: i.1))
                drawTrailPolyline()
            }
        }
    }
    
    var coordinates = [CLLocationCoordinate2D]()
    
    var userTraversedCoordinates: [CLLocationCoordinate2D] = []
    
    var pointsOfInterest = [PointOfInterest]() {
        didSet {
            self.pointsOfInterest.forEach { (point) in
                let poi = MGLPointAnnotation()
                poi.coordinate = CLLocationCoordinate2D(latitude: point.lat, longitude: point.long)
                poi.title = point.title
                mapView.addAnnotation(poi)
                POIAnnotations.append(poi)
            }
        }
    }
    
    var POIAnnotations = [MGLAnnotation]()
    
    var POIShown = true
    
    var recordingStatus = false
    
    var forecastDetails: WeatherForecast? {
        didSet {
            selectedForecast = .hourly
        }
    }
    
    var selectedForecast: ForecastType? {
        didSet {
            switch selectedForecast {
                case .hourly:
                    forecastSegmentedControl.selectedSegmentIndex = 0
                case .daily:
                    forecastSegmentedControl.selectedSegmentIndex = 1
                default:
                    forecastSegmentedControl.selectedSegmentIndex = 0
            }
            weatherTableView.reloadData()
        }
    }
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.setCenter(CLLocationCoordinate2D(latitude: mapView.userLocation!.coordinate.latitude, longitude: mapView.userLocation!.coordinate.longitude), zoomLevel: 13.5, animated: false)
        mapView.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        constrainMap()
        constrainCV()
        constrainLocationButton()
        constrainAddAnnotationButton()
        constrainRecordTrailButton()
        constrainAddPopUp()
        getPointsOfInterest()
        
    }
    
    //MARK: - Constraint Methods
    func constrainLocationButton(){
        view.addSubview(locationButton)
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            locationButton.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height / 9),
            locationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            locationButton.heightAnchor.constraint(equalToConstant: 50),
            locationButton.widthAnchor.constraint(equalToConstant: 50)])
    }
    
    func constrainAddAnnotationButton(){
        view.addSubview(addAnnotationButton)
        addAnnotationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addAnnotationButton.topAnchor.constraint(equalTo: locationButton.bottomAnchor, constant: 10),
            addAnnotationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            addAnnotationButton.heightAnchor.constraint(equalToConstant: 50),
            addAnnotationButton.widthAnchor.constraint(equalToConstant: 50)])
    }
    
    func constrainRecordTrailButton(){
        view.addSubview(recordTrailButton)
        recordTrailButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            recordTrailButton.topAnchor.constraint(equalTo: addAnnotationButton.bottomAnchor, constant: 10),
            recordTrailButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            recordTrailButton.heightAnchor.constraint(equalToConstant: 50),
            recordTrailButton.widthAnchor.constraint(equalToConstant: 50)])
    }
    
    func constrainCV(){
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 90),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            collectionView.heightAnchor.constraint(equalToConstant: 100)])
        
    }
    
    func constrainMap(){
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 30),
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.widthAnchor.constraint(equalTo: view.widthAnchor)])
        
    }
    
    func constrainAddPopUp(){
        view.addSubview(addPopUp)
        addPopUp.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addPopUp.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hidePopUpTopAnchorConstraint,
            addPopUp.heightAnchor.constraint(equalToConstant: view.frame.height / 2),
            addPopUp.widthAnchor.constraint(equalToConstant: view.frame.width)])
    }
    
    func showWeatherTableView() {
        view.addSubview(forecastSegmentedControl)
        forecastSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            forecastSegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            forecastSegmentedControl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            forecastSegmentedControl.widthAnchor.constraint(equalToConstant: view.frame.width - 30),
            forecastSegmentedControl.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        view.addSubview(weatherTableView)
        weatherTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherTableView.topAnchor.constraint(equalTo: forecastSegmentedControl.bottomAnchor, constant: 3),
            weatherTableView.heightAnchor.constraint(equalToConstant: view.frame.height / 2),
            weatherTableView.widthAnchor.constraint(equalToConstant: view.frame.width)])
    }
    
    lazy var hidePopUpTopAnchorConstraint: NSLayoutConstraint = {
        return addPopUp.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    }()
    
    lazy var showPopUpTopAnchorConstraint: NSLayoutConstraint = {
        return addPopUp.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
    }()
    
    
    //MARK: - Private Methods
    
    private func getCoordinatesFromJSON(data: Data){
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
    
    func showAlertController(title: String?, message: String?, actions: [UIAlertAction]) -> UIAlertController {
        let alertController = UIAlertController(title: title , message: message, preferredStyle: .alert)
        actions.forEach { (action) in
            alertController.addAction(action)
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        return alertController
    }
    
    
    //MARK: - Trail Recording Methods
    @objc func recordTrailPrompt(button: UIButton){
        switch recordingStatus {
            case false:
                let action =  UIAlertAction(title: "Start Recording", style: .destructive, handler: { (action) in
                    //record trail method goes here
                    
                    self.recordingStatus = true
                })
                let alertController = showAlertController(title: "Record New Trail?", message: nil, actions: [action])
                present(alertController, animated: true, completion: nil)
            
            case true:
                print("stop recording prompt goes here")
                let yesAction = UIAlertAction(title: "Yes", style: .destructive) { (action) in
                    //save or discard trail here, add images, title , description then persist
                    //maybe a custom uiview to add these properties visually
                    self.recordingStatus = false
                }
                
                let keepRecording = UIAlertAction(title: "No, Keep Recording", style: .destructive) { (action) in
                    //
                }
                let discard = UIAlertAction(title: "No, Discard Recording", style: .destructive) { (action) in
                    //
                    self.recordingStatus = false
                    self.userTraversedCoordinates = [CLLocationCoordinate2D]()
                }
                let alertController = showAlertController(title: "Save New Trail?", message: nil, actions: [yesAction,keepRecording,discard])
                present(alertController,animated: true)
        }
        
    }
    
    
    //MARK: - Points Of Interest Methods
    private func getPointsOfInterest() {
        var poi = [PointOfInterest]()
        do {
            try poi = POIPersistenceHelper.manager.getItems()
        } catch {
            print("unable to fetch points of interest")
        }
        self.pointsOfInterest = poi
    }
    
    private func hidePointsOfInterest(){
        guard mapView.annotations != nil else { return }
        mapView.removeAnnotations(POIAnnotations)
    }
    
    private func togglePOI(){
        switch POIShown {
            case true:
                hidePointsOfInterest()
                POIShown = false
            case false:
                getPointsOfInterest()
                POIShown = true
        }
    }
    
    func addPointOfInterest() {
        let current = mapView.userLocation!.coordinate
        do {
            try POIPersistenceHelper.manager.save(newItem: PointOfInterest(lat: Double(current.latitude), long: Double(current.longitude), type: "Default", title: addPopUp.titleField.text ?? "", desc: addPopUp.descField.text ?? ""))
        } catch {
            print("error, could not save POI")
        }
        
    }
    
    func dismissAddPointView() {
        switchAnimationAddPopUp()
    }
    
    @objc func showAddPointView(sender: UIButton){
        switchAnimationAddPopUp()
        
    }
    
    private func switchAnimationAddPopUp(){
        switch addPopUp.shown {
            case false:
                UIView.animate(withDuration: 0.3) {
                    self.hidePopUpTopAnchorConstraint.isActive = false
                    self.showPopUpTopAnchorConstraint.isActive = true
                    self.view.layoutIfNeeded()
                    self.addPopUp.shown = true
            }
            case true:
                UIView.animate(withDuration: 0.3) {
                    self.hidePopUpTopAnchorConstraint.isActive = true
                    self.showPopUpTopAnchorConstraint.isActive = false
                    self.view.layoutIfNeeded()
                    self.addPopUp.shown = false
            }
        }
    }
    
    //MARK: - Visual Map Methods
    
    @objc func locationButtonTapped(sender: UIButton) {
        var mode: MGLUserTrackingMode
        switch (mapView.userTrackingMode) {
            case .none:
                mode = .follow
            case .follow:
                mode = .followWithHeading
            case .followWithHeading:
                mode = .followWithCourse
            case .followWithCourse:
                mode = .none
            @unknown default:
                fatalError("Unknown user tracking mode")
        }
        mapView.userTrackingMode = mode
        mapView.setCenter(mapView.userLocation!.coordinate, zoomLevel: 16, animated: true)
    }
    
    func drawTrailPolyline() {
        DispatchQueue.global(qos: .background).async(execute: {
            // Get the path for example.geojson in the app's bundle
            let jsonPath = Bundle.main.path(forResource: "prospectparkloop", ofType: "geojson")
            let url = URL(fileURLWithPath: jsonPath!)
            
            do {
                // Convert the file contents to a shape collection feature object
                let data = try Data(contentsOf: url)
                self.getCoordinatesFromJSON(data: data)
                guard let shapeCollectionFeature = try MGLShape(data: data, encoding: String.Encoding.utf8.rawValue) as? MGLShapeCollectionFeature else {
                    fatalError("Could not cast to specified MGLShapeCollectionFeature")
                }
                
                if let polyline = shapeCollectionFeature.shapes.first as? MGLPolylineFeature {
                    // Optionally set the title of the polyline, which can be used for:
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
            }
            
        })
        
    }
    
    func drawUserTrailPolyline() {
        let polyline = MGLPolyline(coordinates: self.userTraversedCoordinates, count: UInt(self.userTraversedCoordinates.count))
        polyline.title = "user"
        DispatchQueue.main.async {
            self.mapView.addAnnotation(polyline)
        }
    }
    
    //MARK: - Weather Methods
    
    @objc func tappedForecastSegmentControl() {
        switch self.forecastSegmentedControl.selectedSegmentIndex {
            case 0:
                selectedForecast = .hourly
            case 1:
                selectedForecast = .daily
            default:
                selectedForecast = .hourly
        }
        
    }
    
}
//MARK: - CV Delegate Methods

extension MapVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mapCell", for: indexPath) as? MapCell else { return UICollectionViewCell() }
        cell.setIconForIndex(index: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 70)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
            case 0:
                print("poi toggled")
                self.togglePOI()
            case 1:
                if weatherTableView.isDescendant(of: self.view) && forecastSegmentedControl.isDescendant(of: self.view) {
                    weatherTableView.removeFromSuperview()
                    forecastSegmentedControl.removeFromSuperview()
                } else {
                    self.showWeatherTableView()
                }
            default:
                return
        }
    }
}



//MARK: - MV Delegate Methods
extension MapVC: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, lineWidthForPolylineAnnotation annotation: MGLPolyline) -> CGFloat {
        return 4.0
    }
    
    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        switch annotation.title {
            case "user":
                return .systemGreen
            default:
                return .systemBlue
        }
        
    }
    
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
    }
    
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        let reuseIdentifier = "reusableDotView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        if annotationView == nil {
            annotationView = MGLAnnotationView(reuseIdentifier: reuseIdentifier)
            annotationView?.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            annotationView?.layer.cornerRadius = (annotationView?.frame.size.width)! / 2
            annotationView?.layer.borderWidth = 2.0
            annotationView?.layer.borderColor = UIColor.white.cgColor
            annotationView!.backgroundColor = UIColor(red: 0.03, green: 0.80, blue: 0.69, alpha: 1.0)
        }
        
        return annotationView
    }
    
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
        if recordingStatus == true {
            if let userCoord = userLocation?.coordinate {
                self.userTraversedCoordinates.append(userCoord)
                drawUserTrailPolyline()
            }
            
            if self.userTraversedCoordinates.count >= 3 {
                drawUserTrailPolyline()
            }
        }
    }
    
    
    
    
}


//MARK: - TableView Methods for Weather

extension MapVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerlabel = UILabel()
        headerlabel.backgroundColor = .lightGray
        headerlabel.adjustsFontSizeToFitWidth = true
        headerlabel.textAlignment = .center
        if let trail = self.trail {
            headerlabel.text = " Weather for \(trail.name) "
        } else {
            headerlabel.text = "No trail detected"
        }
        return headerlabel
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedForecast {
            case .daily:
                return forecastDetails?.daily?.data?.count ?? 0
            case .hourly:
                return forecastDetails?.hourly?.data?.count ?? 0
            case .none:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "weatherTableViewCell", for: indexPath) as? WeatherTableViewCell else  {
            print("Could not make tvc")
            return UITableViewCell()
            
        }
        switch selectedForecast {
            case .daily:
                let dayForecast = forecastDetails?.daily?.data?[indexPath.row]
                if indexPath.row == 0 {
                    cell.dateLabel.text = "Today"
                } else {
                    cell.dateLabel.text = convertTimeToDate(forecastType: .daily, time: dayForecast?.time ?? 0)
                }
                cell.weatherIconImageView.image = getWeatherIcon(named: dayForecast?.icon ?? "cloud")
                cell.weatherDescription.text = dayForecast?.icon?.replacingOccurrences(of: "-", with: " ").capitalized
                cell.lowTempLabel.textColor = .systemBlue
                if let lowTemp = dayForecast?.temperatureLow, let highTemp = dayForecast?.temperatureHigh {
                    cell.lowTempLabel.text = String(format: "%.0f\u{00B0}", lowTemp)
                    cell.highTempLabel.text = String(format: "%.0f\u{00B0}", highTemp)
            }
            
            case .hourly:
                let hourForecast = forecastDetails?.hourly?.data?[indexPath.row]
                cell.dateLabel.text = convertTimeToDate(forecastType: .hourly, time: hourForecast?.time ?? 0)
                cell.weatherIconImageView.image = getWeatherIcon(named: hourForecast?.icon ?? "cloud")
                cell.weatherDescription.text = hourForecast?.icon?.replacingOccurrences(of: "-", with: " ").capitalized
                cell.lowTempLabel.textColor = .black
                if let temp = hourForecast?.temperature {
                    cell.highTempLabel.text = ""
                    cell.lowTempLabel.text = String(format: "%.0f\u{00B0}", temp)
            }
            
            default:
                return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    
}
