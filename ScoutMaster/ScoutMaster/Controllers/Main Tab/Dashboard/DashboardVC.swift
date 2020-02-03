//
//  DashboardVC.swift
//  ScoutMaster
//
//  Created by Aaron Pachesa on 2/3/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class DashboardVC: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var HPTrails = [Trail]() {
        didSet {
            print("got here")
            collectionView.reloadData()
        }
    }
    
    lazy var searchItBar: UISearchBar = {
        var searchIt = UISearchBar()
        searchIt.frame = CGRect (x: 0, y: 45, width: 415, height: 50)
        searchIt.placeholder = "Enter location"
        return searchIt
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 500, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 60, height: 60)
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemPurple
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        view.addSubview(searchItBar)
        
        view.addSubview(collectionView)
        
        loadData()
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return HPTrails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
//            as! TrailCell
        
        return cell
    }
    
    private func loadData() {
        Trail.getTrails(lat: 41.3406907, long: -76.2594981) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let hikingProjectAPI):
                    self.HPTrails = hikingProjectAPI
                    print(self.HPTrails)
                }
            }
        }
    }
    
}
