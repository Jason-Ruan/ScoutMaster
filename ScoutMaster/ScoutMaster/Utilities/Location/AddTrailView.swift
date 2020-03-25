//
//  AddTrailView.swift
//  ScoutMaster
//
//  Created by Sam Roman on 3/23/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//

import UIKit


protocol AddTrailViewDelegate: AnyObject {
    func dismissAddTrailView()
    func addTrail()
    
}
class AddTrailView: UIView {
    
    
    private func setupView(){
        
    }
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           setupView()
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
}
