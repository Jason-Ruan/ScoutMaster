//
//  CustomPointAnnotation.swift
//  ScoutMaster
//
//  Created by Sam Roman on 2/3/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//

// MGLAnnotation protocol reimplementation
import UIKit
import Mapbox

class CustomPointAnnotation: NSObject, MGLAnnotation {
// As a reimplementation of the MGLAnnotation protocol, we have to add mutable coordinate and (sub)title properties ourselves.
var coordinate: CLLocationCoordinate2D
var title: String?
var subtitle: String?
 
// Custom properties that we will use to customize the annotation's image.
var image: UIImage?
var reuseIdentifier: String?
 
init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
self.coordinate = coordinate
self.title = title
self.subtitle = subtitle
}
}
 
// MGLPolyline subclass
class CustomPolyline: MGLPolyline {
// Because this is a subclass of MGLPolyline, there is no need to redeclare its properties.
 
// Custom property that we will use when drawing the polyline.
var color: UIColor?
}

class CustomAnnotationView: MGLAnnotationView {
override func layoutSubviews() {
super.layoutSubviews()
 
// Use CALayer’s corner radius to turn this view into a circle.
layer.cornerRadius = bounds.width / 2
layer.borderWidth = 2
layer.borderColor = UIColor.white.cgColor
}
 
override func setSelected(_ selected: Bool, animated: Bool) {
super.setSelected(selected, animated: animated)
 
// Animate the border width in/out, creating an iris effect.
let animation = CABasicAnimation(keyPath: "borderWidth")
animation.duration = 0.1
layer.borderWidth = selected ? bounds.width / 4 : 2
layer.add(animation, forKey: "borderWidth")
}
}
