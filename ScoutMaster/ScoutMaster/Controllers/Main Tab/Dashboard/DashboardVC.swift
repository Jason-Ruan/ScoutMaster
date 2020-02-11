import UIKit

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
        searchIt.placeholder = "Search..."
        return searchIt
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .cyan
        collectionView.register(TrailCell.self, forCellWithReuseIdentifier: "trailCell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        if let collectionLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
             collectionLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
         }
        
        loadData()
        
        // add Subviews
    
        view.addSubview(searchItBar)
        view.addSubview(collectionView)
        
        // add Constraints
        
        setSearchItBarConstraints()
        setCollectionViewConstraints()
        
        
        
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
    

    // Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HPTrails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trailCell", for: indexPath) as! TrailCell
        let selectedTrail = HPTrails[indexPath.row]
        cell.configureCell(trail: selectedTrail)
        return cell
    }
    
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width * 0.7 , height: view.bounds.height * 0.3)
    }
    

    
    // Constraints
    
    private func setCollectionViewConstraints() {
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            self.collectionView.topAnchor.constraint(equalTo: self.searchItBar.bottomAnchor, constant: 5),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    private func setSearchItBarConstraints() {
        self.searchItBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.searchItBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            self.searchItBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.searchItBar.heightAnchor.constraint(equalToConstant: 30),
            self.searchItBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50)
        ])
    }
    
}
