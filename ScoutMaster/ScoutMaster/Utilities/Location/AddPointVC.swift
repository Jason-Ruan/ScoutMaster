//
//  AddPointVC.swift
//  ScoutMaster
//
//  Created by Sam Roman on 2/18/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//

import UIKit

class AddPointVC: UIViewController {
    
    lazy var mainView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 50
        return view
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .init(white: 0.0, alpha: 0.0)
        view.addSubview(mainView)
        constrainMainView()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    private func constrainMainView(){
        mainView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            mainView.heightAnchor.constraint(equalToConstant: view.frame.height / 2),
            mainView.widthAnchor.constraint(equalToConstant: view.frame.width)])
    }
    
    
}
