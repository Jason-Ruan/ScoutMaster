import UIKit

class DashboardVC: UIViewController, UITextFieldDelegate {
    
    var HPTrails = [Trail]() {
        didSet {
            collectionView.reloadData()
        }
    }
    var longitude: Double = 40.668
    var latitude: Double = -73.9738
    var newText = ""
    var dropDownOptions = ["Popular", "Nearby"]
    
    lazy var nameLabel: UILabel = {
        var yourName = UILabel()
        let attributedTitle = NSMutableAttributedString(string: "Hey Scout,", attributes: [NSAttributedString.Key.font: UIFont(name: "Baskerville", size: 50)!, NSAttributedString.Key.foregroundColor: UIColor.black])
        attributedTitle.append(NSAttributedString(string: "\n\nExplore the best hiking trails and routes.\n\n", attributes: [NSAttributedString.Key.font: UIFont(name: "Baskerville", size: 20)!, NSAttributedString.Key.foregroundColor:  UIColor.init(white: 0.3, alpha: 1) ]))
        yourName.attributedText = attributedTitle
        yourName.numberOfLines = 0
        yourName.backgroundColor = .clear
        return yourName
    }()
    
    lazy var searchItBar: UITextField = {
        var searchIt = UITextField()
        searchIt.frame = CGRect (x: 0, y: 45, width: 415, height: 50)
        searchIt.attributedPlaceholder = NSMutableAttributedString(string: "   Search...", attributes: [NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!, NSAttributedString.Key.foregroundColor: UIColor.black])
        
        searchIt.layer.cornerRadius = 25
        searchIt.textColor = .black
        searchIt.backgroundColor = .white
        searchIt.textAlignment = .center
        searchIt.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        searchIt.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        searchIt.layer.shadowOpacity = 0.8
        searchIt.layer.shadowRadius = 0.0
        searchIt.layer.masksToBounds = false
        searchIt.autocorrectionType = .no
        searchIt.delegate = self
        return searchIt
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(TrailCell.self, forCellWithReuseIdentifier: "trailCell")
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    lazy var displayedFilterButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("Tttttttttttttttt", for: .normal)
        button.titleLabel?.font = UIFont.init(name: "Baskerville", size: 20)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.adjustsFontSizeToFitWidth = false
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
        button.addTarget(self, action: #selector(clickDisplayedFilterButton), for: .touchUpInside)
        return button
    }()
    
        @objc func clickDisplayedFilterButton(sender: UIButton) {
            print("click")
    //        filterLabel.isHidden = false
            horizontalStackViewForFilterIcon.isHidden = true
        }
    
    lazy var easyButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("Easy", for: .normal)
        button.titleLabel?.font = UIFont.init(name: "Baskerville", size: 20)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.adjustsFontSizeToFitWidth = false
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
        button.addTarget(self, action: #selector(clickEasyButton), for: .touchUpInside)
        return button
    }()
    
    @objc func clickEasyButton(sender: UIButton) {
        print("click")
//        filterLabel.isHidden = false
        horizontalStackViewForFilterIcon.isHidden = true
    }
    
    lazy var mediumButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("Medium", for: .normal)
        button.titleLabel?.font = UIFont.init(name: "Baskerville", size: 20)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.adjustsFontSizeToFitWidth = false
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
        button.addTarget(self, action: #selector(clickMediumButton), for: .touchUpInside)
        return button
    }()
    
    @objc func clickMediumButton(sender: UIButton) {
        print("click")
        filterLabel.isHidden = false
        horizontalStackView.isHidden = true
    }
    
    lazy var hardButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("Hard", for: .normal)
        button.titleLabel?.font = UIFont.init(name: "Baskerville", size: 20)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.adjustsFontSizeToFitWidth = false
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
        button.addTarget(self, action: #selector(clickHardButton), for: .touchUpInside)
        return button
    }()
    
    @objc func clickHardButton(sender: UIButton) {
        print("click")
        filterLabel.isHidden = false
        horizontalStackView.isHidden = true
    }
    
    lazy var nearbyButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("Nearby", for: .normal)
        button.titleLabel?.font = UIFont.init(name: "Baskerville", size: 25)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(clickNearbyButton), for: .touchUpInside)
        button.isEnabled = false
        button.isHidden = true
        return button
    }()
    
    lazy var horizontalStackViewForFilterIcon: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [easyButton, mediumButton, hardButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 30
        stackView.isHidden = true
        return stackView
    }()
    
    @objc func clickNearbyButton(sender: UIButton) {
        print("click")
        filterLabel.isHidden = false
        horizontalStackView.isHidden = true
    }
    
    lazy var popularButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("Popular", for: .normal)
        button.titleLabel?.font = UIFont.init(name: "Baskerville", size: 25)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(clickPopularButton), for: .touchUpInside)
        button.isHidden = true
        button.isEnabled = false
        return button
    }()
    
    @objc func clickPopularButton(sender: UIButton) {
        print("click")
        filterLabel.isHidden = false
        filterLabel.titleLabel?.text = "Popular"
        horizontalStackView.isHidden = true
    }
    
    lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nearbyButton, popularButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 30
        stackView.isHidden = true
        return stackView
    }()
    
    lazy var filterLabel: UIButton = {
        let label = UIButton()
        label.setTitle("Nearby", for: .normal)
        label.titleLabel?.font = UIFont.init(name: "Baskerville", size: 25)
        label.setTitleColor(.black, for: .normal)
        label.addTarget(self, action: #selector(click), for: .touchUpInside)
        label.titleLabel?.numberOfLines = 1
        label.titleLabel?.adjustsFontSizeToFitWidth = true
        label.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
        label.isHidden = true
        label.isEnabled = false
        return label
    }()


    @objc func click(sender: UIButton) {
        print("click")
        filterLabel.isHidden = true
        horizontalStackView.isHidden = false
    }
    
    lazy var searchIcon: UIImageView = {
        let icon = UIImageView()
        icon.backgroundColor = .clear
        icon.contentMode = .scaleAspectFill
        icon.image = UIImage(named: "search")
        return icon
    }()
    
   lazy var profileImage: UIButton = {
        let icon = UIButton()
        icon.backgroundColor = .clear
        icon.contentMode = .scaleAspectFill
        icon.setBackgroundImage( UIImage(named: "personhiking"), for: .normal)
    icon.addTarget(self, action: #selector(logout), for: .touchUpInside)
        return icon
    }()
    
    lazy var filterButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "filter"), for: .normal)
//                button.addTarget(self, action: #selector(clickFilterButton), for: .touchUpInside)
        button.isHidden = true
        button.isEnabled = false
        return button
    }()
    
    @objc func clickFilterButton(sender: UIButton) {
        print("click")
//        filterLabel.isHidden = true
        if horizontalStackViewForFilterIcon.isHidden == false {
            horizontalStackViewForFilterIcon.isHidden = true
        } else {
            horizontalStackViewForFilterIcon.isHidden = false
        }
        
    }
    
    @objc func logout(){
              let alert = UIAlertController(title: "Log Out?", message: nil, preferredStyle: .alert)
              let action = UIAlertAction.init(title: "Yup!", style: .destructive, handler: .some({ (action) in
                  DispatchQueue.main.async {
                      FirebaseAuthService.manager.logOut { (result) in
                      }
                      guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                          let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window
                          else {
                              return
                      }
                      UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromBottom, animations: {
                          window.rootViewController = LoginVC()
                      }, completion: nil)
                  }
              }))
              let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
              alert.addAction(action)
              alert.addAction(cancel)
              present(alert, animated:true)
          }
    
    
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
        view.addSubview(horizontalStackView)
        view.addSubview(horizontalStackViewForFilterIcon)
        view.addSubview(displayedFilterButton)
        
        
        // add Constraints
        setCollectionViewConstraints()
        setNameLabelConstraints()
        setFilterLabelConstraints()
        setSearchItBarConstraints()
        setSearchIconConstraints()
        setProfileImageConstraints()
        setFilterButtonConstraints()
        setHorizontalStackViewConstraints()
        setHorizontalForFilterButtonStackViewConstraints()
        setdisplayedFilterButtonConstraints()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        for char in searchItBar.text ?? "" {
            if char == " " {
            continue
            }
            newText += String(char)
        }
        loadGeoCoordinates()
        textField.resignFirstResponder()
        newText = ""
        return true
    }
    
    func loadGeoCoordinates() {
        Location.getGeoCode(searchString: newText ) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print("a")
                    print(error.localizedDescription)
                case .success(let theGeoCode):
                    print("b")
                    self.latitude = theGeoCode.lng ?? -73.972
                    self.longitude = theGeoCode.lat ?? 40.668
                    self.loadData()
                    print(self.latitude)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        profileImage.layer.cornerRadius = 35
                     profileImage.clipsToBounds = true
                     profileImage.layer.borderWidth = 3.0
                     profileImage.layer.borderColor = UIColor.white.cgColor
    }
    
    private func loadData() {
        Trail.getTrails(lat: longitude, long: latitude) { (result) in
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
            
            self.collectionView.topAnchor.constraint(equalTo: self.filterLabel.bottomAnchor),
            self.collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10),
            self.collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    private func setTableViewConstraints() {
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            self.collectionView.topAnchor.constraint(equalTo: searchItBar.bottomAnchor,constant: 30),
            self.collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            self.collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
            self.collectionView.heightAnchor.constraint(equalToConstant: 50)
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
    
    private func setHorizontalStackViewConstraints(){
        self.horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: searchItBar.bottomAnchor,constant: 30),
            horizontalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            horizontalStackView.heightAnchor.constraint(equalToConstant: 30)])
    }
    // try width anchor contraint next
    private func setHorizontalForFilterButtonStackViewConstraints(){
        self.horizontalStackViewForFilterIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalStackViewForFilterIcon.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            horizontalStackViewForFilterIcon.widthAnchor.constraint(equalToConstant: 275),
            horizontalStackViewForFilterIcon.heightAnchor.constraint(equalToConstant: 140),
            horizontalStackViewForFilterIcon.centerYAnchor.constraint(equalTo: filterLabel.centerYAnchor)])
    }
    
    private func setFilterButtonConstraints(){
        self.filterButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            filterButton.widthAnchor.constraint(equalToConstant: 40),
            filterButton.heightAnchor.constraint(equalToConstant: 40),
            filterButton.centerYAnchor.constraint(equalTo: filterLabel.centerYAnchor)])
    }
    
    private func setdisplayedFilterButtonConstraints(){
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
        ImageHelper.shared.fetchImage(urlString: selectedTrail.imgMedium) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                print(error)
                case .success(let pic):
                    cell.image.image = pic
                }
            }
          
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailVC()
        detailVC.trail = HPTrails[indexPath.row]
        present(detailVC, animated: true, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
    

//extension DashboardVC: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        dropDownOptions.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell()
//        cell.textLabel?.text = dropDownOptions[indexPath.row]
//        return cell
//    }
//
//
//}
    
