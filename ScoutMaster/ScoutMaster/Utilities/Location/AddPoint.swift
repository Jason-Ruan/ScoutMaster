//
//  AddPoint.swift
//  ScoutMaster
//
//  Created by Sam Roman on 2/19/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//
import UIKit

class AddPointView: UIView {
    
    var shown = true
    
    lazy var mainView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 50
        return view
    }()
    
}
