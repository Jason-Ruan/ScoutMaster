//
//  AddPoint.swift
//  ScoutMaster
//
//  Created by Sam Roman on 2/19/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//
import UIKit


protocol AddPointViewDelegate: AnyObject {
    func dismissAddPointView()
    func addPointOfInterest()
    
}

class AddPointView: UIView {
    
    var shown = true
    
    weak var delegate: AddPointViewDelegate?
    
    lazy var mainLabel: UILabel = {
        var label = UILabel()
        label.text = "Add Trail Marker"
        label.textColor = .black
        return label
    }()
    
    lazy var titleField: UITextField = {
        var tf = UITextField()
        tf.backgroundColor = .systemBackground
//        tf.borderStyle = .roundedRect
        tf.placeholder = "Title for trail mark..."
        return tf
    }()
    
    lazy var descField: UITextField = {
        var tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .systemBackground
        tf.placeholder = "Description..."
        tf.isUserInteractionEnabled = true
        return tf
    }()
    
    lazy var cancelButton: UIButton = {
        var button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.showsTouchWhenHighlighted = true
        button.addTarget(self, action: #selector(cancelTouched(sender:)), for: .touchUpInside)
        return button
    }()
    
    @objc func cancelTouched(sender: UIButton) {
        titleField.text = nil
        descField.text = nil
        print("getting here")
        delegate?.dismissAddPointView()
    }
    
    lazy var submitButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("Submit", for: .normal)
        button.tintColor = .systemBlue
        button.setTitleColor(.systemBlue, for: .normal)
        button.showsTouchWhenHighlighted = true
        button.addTarget(self, action: #selector(submitTouched(sender:)), for: .touchUpInside)
        return button
    }()
    
    @objc func submitTouched(sender: UIButton) {
        delegate?.addPointOfInterest()
        print("submitted POI")
        titleField.text = nil
        descField.text = nil
        delegate?.dismissAddPointView()
    }
    
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
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemBlue.cgColor
        constrainTitleField()
        constrainDescField()
        constrainCancelButton()
        constrainSubmitButton()
        constrainMainLabel()
        
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
        descField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descField.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 5),
            descField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            descField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            descField.bottomAnchor.constraint(equalTo: self.bottomAnchor)])
    }
    
    func constrainCancelButton(){
        self.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelButton.heightAnchor.constraint(equalToConstant: 30),
            cancelButton.widthAnchor.constraint(equalToConstant: 30),
            cancelButton.leadingAnchor.constraint(equalTo: titleField.leadingAnchor, constant: 10),
            cancelButton.bottomAnchor.constraint(equalTo: titleField.topAnchor, constant: -3)])
    }
    
    func constrainSubmitButton(){
        self.addSubview(submitButton)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            submitButton.heightAnchor.constraint(equalToConstant: 30),
            submitButton.widthAnchor.constraint(equalToConstant: 60),
            submitButton.trailingAnchor.constraint(equalTo: titleField.trailingAnchor, constant: -10),
            submitButton.bottomAnchor.constraint(equalTo: titleField.topAnchor, constant: -3)])
    }
    
    func constrainMainLabel() {
        self.addSubview(mainLabel)
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            mainLabel.heightAnchor.constraint(equalToConstant: 30),
            mainLabel.widthAnchor.constraint(equalToConstant: 150),
            mainLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10)
        ])
    }
    
}
