import UIKit

class DashboardVC: UIViewController, UISearchBarDelegate {
    
    var HPTrails = [Trail]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    lazy var nameLabel: UILabel = {
        var yourName = UILabel()
        let attributedTitle = NSMutableAttributedString(string: "Hey Scout,", attributes: [NSAttributedString.Key.font: UIFont(name: "Baskerville", size: 50)!, NSAttributedString.Key.foregroundColor: UIColor.black])
        attributedTitle.append(NSAttributedString(string: "\n\nExplore the best hiking trails and routes.\n\n", attributes: [NSAttributedString.Key.font: UIFont(name: "Baskerville", size: 20)!, NSAttributedString.Key.foregroundColor:  UIColor.init(white: 0.3, alpha: 1) ]))
        yourName.attributedText = attributedTitle
        yourName.numberOfLines = 0
        yourName.backgroundColor = .clear
//        yourName.font = yourName.font.withSize(20)
        return yourName
    }()
    
    lazy var searchItBar: UITextField = {
        var searchIt = UITextField()
        searchIt.frame = CGRect (x: 0, y: 45, width: 415, height: 50)
        searchIt.attributedPlaceholder = NSMutableAttributedString(string: "   Search...", attributes: [NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!, NSAttributedString.Key.foregroundColor: UIColor.black])
        
        searchIt.layer.cornerRadius = 25
        searchIt.backgroundColor = .white
        searchIt.textAlignment = .center
        searchIt.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        searchIt.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        searchIt.layer.shadowOpacity = 0.8
        searchIt.layer.shadowRadius = 0.0
        searchIt.layer.masksToBounds = false
        searchIt.autocorrectionType = .no
        //        searchIt.addSoftUIEffectForView()
        return searchIt
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(TrailCell.self, forCellWithReuseIdentifier: "trailCell")
        
        return collectionView
    }()
    
    lazy var filterLabel: UILabel = {
        let label = UILabel()
        label.text = "Nearby"
        label.font = UIFont.init(name: "Baskerville", size: 25)
        return label
    }()
    
    lazy var searchIcon: UIImageView = {
        let icon = UIImageView()
        icon.backgroundColor = .clear
        icon.contentMode = .scaleAspectFill
        icon.image = UIImage(named: "search")
        return icon
    }()
    
   lazy var profileImage: UIImageView = {
        let icon = UIImageView()
        icon.backgroundColor = .clear
        icon.contentMode = .scaleAspectFill
        icon.image = UIImage(named: "personhiking")
        return icon
    }()
    
    lazy var filterButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "filter"), for: .normal)
        return button
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
        view.addSubview(nameLabel)
        view.addSubview(filterLabel)
        view.addSubview(searchIcon)
        view.addSubview(profileImage)
        view.addSubview(filterButton)
        
        // add Constraints
        setCollectionViewConstraints()
        setNameLabelConstraints()
        setFilterLabelConstraints()
        setSearchItBarConstraints()
        setSearchIconConstraints()
        setProfileImageConstraints()
        setFilterButtonConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        profileImage.layer.cornerRadius = 35
                     profileImage.clipsToBounds = true
                     profileImage.layer.borderWidth = 3.0
                     profileImage.layer.borderColor = UIColor.white.cgColor
    }
    
    private func loadData() {
        Trail.getTrails(lat: 41.3406907, long: -76.2594981) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let hikingProjectAPI):
                    self.HPTrails = hikingProjectAPI
                }
            }
        }
    }
    

    // Constraints
    
    private func setCollectionViewConstraints() {
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            self.collectionView.topAnchor.constraint(equalTo: self.filterLabel.bottomAnchor, constant: 20),
            self.collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10),
            self.collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -100)
            
//            self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -view.frame.height / 2)
        ])
    }
    
    private func setSearchItBarConstraints() {
        self.searchItBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.searchItBar.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor),
            self.searchItBar.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            self.searchItBar.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
            self.searchItBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setSearchIconConstraints(){
        self.searchIcon.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.searchIcon.trailingAnchor.constraint(equalTo: searchItBar.trailingAnchor, constant: -15),
            searchIcon.centerYAnchor.constraint(equalTo: searchItBar.centerYAnchor),
            searchIcon.heightAnchor.constraint(equalToConstant: 25),
        searchIcon.widthAnchor.constraint(equalToConstant: 25)])
    }
    
    private func setNameLabelConstraints() {
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            self.nameLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30),
            self.nameLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10),
            self.nameLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10)
            
//            self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -view.frame.height / 2)
        ])
        
    }
    
    private func setProfileImageConstraints(){
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            profileImage.widthAnchor.constraint(equalToConstant: 70),
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)])
    }
    
    
    private func setFilterLabelConstraints(){
        self.filterLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            filterLabel.topAnchor.constraint(equalTo: searchItBar.bottomAnchor,constant: 30),
            filterLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            filterLabel.heightAnchor.constraint(equalToConstant: 30)])
    }
    
    private func setFilterButtonConstraints(){
        self.filterButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            filterButton.widthAnchor.constraint(equalToConstant: 40),
            filterButton.heightAnchor.constraint(equalToConstant: 40),
            filterButton.centerYAnchor.constraint(equalTo: filterLabel.centerYAnchor)])
    }
    
    
}

extension DashboardVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        return CGSize(width: 380, height: 400)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailVC()
        detailVC.trail = HPTrails[indexPath.row]
        present(detailVC, animated: true, completion: nil)
        
    }
}
