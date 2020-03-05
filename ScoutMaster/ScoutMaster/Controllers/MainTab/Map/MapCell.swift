//
//  MapCell.swift
//  ScoutMaster
//
//  Created by Sam Roman on 2/10/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//

import UIKit

class MapCell: UICollectionViewCell {
    
    //MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCell()
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 20
        contentView.backgroundColor = .init(white: 0.3, alpha: 0.6)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var label: UILabel = {
       let label = UILabel()
        label.text = "Placehold"
        return label
    }()
    
    lazy var iconImage: UIImageView = {
        let icon = UIImageView()
        icon.backgroundColor = .clear
        icon.tintColor = .white
        return icon
    }()
    
    func setUpCell(){
        constrainIcon()
    }
    
    
    func constrainIcon() {
        contentView.addSubview(iconImage)
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -20),
            iconImage.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -20),
            iconImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        iconImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)])
    }
    
    func setIconForIndex(index: Int) {
        switch index {
        case 0:
            self.iconImage.image = UIImage(systemName: "mappin.circle")
        case 1:
            self.iconImage.image = UIImage(systemName: "thermometer.sun")
        case 2:
        self.iconImage.image = UIImage(systemName: "staroflife")
        default:
            self.iconImage.image = nil
        }
    }
    
    
    
}
