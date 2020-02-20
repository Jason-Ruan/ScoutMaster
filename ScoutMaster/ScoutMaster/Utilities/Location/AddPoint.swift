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
    
    lazy var titleField: UITextField = {
        var tf = UITextField()
        tf.backgroundColor = .gray
        tf.placeholder = "Add Title for Annotation"
        return tf
    }()
    
    lazy var descField: UITextField = {
           var tf = UITextField()
           tf.backgroundColor = .gray
           tf.placeholder = "Add Title for Annotation"
           return tf
       }()
    
    //initWithFrame to init view from code
      override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
      }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
      //common func to init our view
      private func setupView() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 50
        constrainTitleField()
    
    }
    
    
    func constrainTitleField(){
        self.addSubview(titleField)
        titleField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleField.heightAnchor.constraint(equalToConstant: 100),
            titleField.topAnchor.constraint(equalTo: self.topAnchor, constant: 50),
            titleField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleField.trailingAnchor.constraint(equalTo: self.trailingAnchor)])
    }
    
    func constrainDescField(){
        self.addSubview(descField)
        titleField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleField.heightAnchor.constraint(equalToConstant: 100),
            titleField.topAnchor.constraint(equalTo: self.topAnchor, constant: 50),
            titleField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleField.trailingAnchor.constraint(equalTo: self.trailingAnchor)])
    }
    
    
}
