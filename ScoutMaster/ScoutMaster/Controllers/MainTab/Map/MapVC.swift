import UIKit
import Mapbox

class MapVC: UIViewController, MGLMapViewDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
 
    
    
   //MARK: Variables
    
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
    
    
    lazy var mapView: MGLMapView = {
        let mv = MGLMapView(frame: view.bounds)
        mv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mv.styleURL = MGLStyle.lightStyleURL
        mv.userTrackingMode = .followWithHeading
        return mv
    }()


    var newCoords: [(Double,Double)]! {
        didSet {
            print(newCoords!)
            for i in newCoords {
                coordinates.append(CLLocationCoordinate2D(latitude: i.0, longitude: i.1))
            }
        }
    }
    
    var coordinates = [CLLocationCoordinate2D]()
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.setCenter(CLLocationCoordinate2D(latitude: 40.668, longitude: -73.9738), zoomLevel: 14, animated: false)
        mapView.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        drawTrailPolyline()
        constrainMap()
        constrainCV()
        constrainLocationButton()
        
    }
    
    //MARK: Constraint Methods
    
    func constrainLocationButton(){
        view.addSubview(locationButton)
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            locationButton.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height / 9),
            locationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            locationButton.heightAnchor.constraint(equalToConstant: 50),
            locationButton.widthAnchor.constraint(equalToConstant: 50)])
    }
    
    func constrainCV(){
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
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
    
    
    //MARK: UI Methods
    
    func setLocationTint(){
        let center = mapView.centerCoordinate
        let user = mapView.userLocation!.coordinate
        if center.latitude == user.latitude && center.longitude == user.longitude {
            locationButton.alpha = 1
        } else {
            locationButton.alpha = 0.3
   
    }
    }

    
    //MARK: Private Methods
    
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
    
    private func getCoordinates(data: Data){
        do {
            var coords = [(Double,Double)]()
            let rawCoords = (try LocationData.getCoordinatesFromData(data: data))!
                     for i in rawCoords {
                             coords.append((i[1],i[0]))
                         
                     }
                     newCoords = coords
                     print("got coordinates")
}
        catch {
            print("error, could not decode geoJSON")
        }
    }
    
    
   
    

    //MARK: Visual Map Data
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
            }

        })

    }
    
    
    //MARK: CV Delegate Methods
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return 5
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
        let tag = indexPath.row
        switch tag {
        case 4:
        present(MapSettings.toggleMapStyle(mapView: mapView), animated: true)
        default:
            return
        }
        
        
        
    }
    
    
    
    
     

    //MARK: MV Delegate Methods
    
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
    
    func mapView(_ mapView: MGLMapView, didChange mode: MGLUserTrackingMode, animated: Bool) {
        setLocationTint()
    }

    
   
    
    
}

