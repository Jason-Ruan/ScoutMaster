//
//  TrailCell.swift
//  ScoutMaster
//
//  Created by Aaron Pachesa on 1/31/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//

import UIKit

class TrailCell: UICollectionViewCell {
    

    
    var allFavorites = [Trail]()
    
    var trail: Trail?
    
    override init(frame: CGRect) {
        super.init(frame:CGRect(x: 0, y: 0, width: 414 / 3, height: 414/3))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
        
    }
//
//    lazy var frontButton: UIButton = {
//
//        var frontButton = UIButton()
//        frontButton.frame = CGRect (x: 0, y: 0, width: 300, height: 300)
//        frontButton.titleLabel?.numberOfLines = 0
//        frontButton.backgroundColor = .black
//        frontButton.setTitle("front", for: .normal)
//        return frontButton
//
//    }()
//
//    lazy var deleteButton: UIButton = {
//
//        var otherButton = UIButton()
//        otherButton.frame = CGRect (x: 0, y: 0, width: 50, height: 50)
//        otherButton.backgroundColor = .black
//        otherButton.setTitle("...", for: .normal)
//        otherButton.titleLabel?.numberOfLines = 0
//        return otherButton
//
//    }()
    
}
