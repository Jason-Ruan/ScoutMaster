//
//  ProfileVC.swift
//  ScoutMaster
//
//  Created by Sam Roman on 1/27/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//

import UIKit
import FirebaseAuth 

class ProfileVC: UIViewController {
    
//    MARK: DATA
    var user = AppUser(from: FirebaseAuthService.manager.currentUser!)
    
    var userPost = [Post] () {
        didSet {
            faveHikesCollection.reloadData()
        }
    }
    
    
//    MARK: UI OBJECTS
    
    lazy var userImage: UIImageView = {
    let defaultImage = UIImageView()
        defaultImage.image = UIImage(named: "defaultpicture")
        return defaultImage
    }()
    
    lazy var userName: UILabel = {
       let name = UILabel()
        return name
    }()
    
    lazy var statsCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
            cv.backgroundColor = .lightGray
//          cv.register(mainVC.self, forCellWithReuseIdentifier: "mainCell")
//            cv.dataSource = self
//            cv.delegate = self
        return cv
    }()
    
    lazy var faveHikesCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.backgroundColor = .darkGray
        return cv
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
// MARK: PRIVATE FUNCS

     private func getPosts(){
              FirestoreService.manager.getAllPosts { (result) in
                  DispatchQueue.main.async {
                      switch result{
                      case .failure(let error):
                          print(error)
                      case .success(let data):
                          self.userPost = data
 
                          print(data.count)
                      }
                  }
              }
            
        }

}


extension ProfileVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    
}

