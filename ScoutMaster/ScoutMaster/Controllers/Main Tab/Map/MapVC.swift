//
//  JourneyVC.swift
//  ScoutMaster
//
//  Created by Sam Roman on 1/27/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//
import UIKit
import Mapbox

class MapVC: UIViewController, MGLMapViewDelegate {
    
    
    lazy var mapView: MGLMapView = {
        let mv = MGLMapView(frame: view.bounds)
        mv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mv.styleURL = MGLStyle.darkStyleURL
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.setCenter(CLLocationCoordinate2D(latitude: 40.8720442, longitude: -73.9256923), zoomLevel: 14, animated: false)
        view.addSubview(self.mapView)
        mapView.delegate = self
        drawTrailPolyline()
    }
    
    func getCoordinates(data: Data){
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
            }

        })

    }
    

    
    //MARK: MV Delegates
    
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
