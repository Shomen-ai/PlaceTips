import CoreLocation
import Firebase
import UIKit

final class ProfileView: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        avatarView.addGestureRecognizer(tapGestureRecognizer)
        avatarView.image = user.image
        nicknameLabel.text = user.login
    }
    
    override func viewDidLoad() {
        setUpNavBar()
        
        view.backgroundColor = .white
        
        avatarView.image = DBManager.shared.userData.image
        nicknameLabel.text = DBManager.shared.userData.login
        
        view.addSubview(avatarView)
        setupAvatarConstraints()
        
        view.addSubview(nicknameLabel)
        setUpLabelConstraints()
        
        view.addSubview(tableView)
        view.addSubview(favLabel)
        setUpTableViewConstraints()
    
        print(DBManager.shared.places)
        print(DBManager.shared.userData)
    }

    // MARK: - FavFata
    var user = DBManager.shared.userData
    
    var places = DBManager.shared.places
    
    // а как данные записать ?
    
    // MARK: - AvatarImage

    let avatarView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "default_pic")
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 150).isActive = true
        view.heightAnchor.constraint(equalToConstant: 150).isActive = true

        view.layer.cornerRadius = 150 / 2
        view.clipsToBounds = true
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        tapGestureRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGestureRecognizer)
        return view
    }()
    
    @objc func selectImage(tapGestureRecognizer: UITapGestureRecognizer) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary // подумать как использовать камеру
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func setupAvatarConstraints() {
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        ])
    }
    
    // MARK: - NicknameLabel
    
    let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "Здесь должно быть имя!"
        label.font = .boldSystemFont(ofSize: 20)
        
        return label
    }()
    
    func setUpLabelConstraints() {
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nicknameLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 20),
            nicknameLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        ])
    }

    // MARK: - FavTable

    let favLabel: UILabel = {
        let label = UILabel()
        label.text = "Любимые места"
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(ProfileViewCells.self,
                       forCellReuseIdentifier: ProfileViewCells.reuseIdentifier)
        table.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        table.delegate = self
        table.dataSource = self
        table.layer.cornerRadius = 20
        return table
    }()
    
    func setUpTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        favLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            favLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 20),
            favLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: favLabel.bottomAnchor, constant: 15),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
        ])
    }
    
    // MARK: - NavBar setUp

    func setUpNavBar() {
        navigationItem.title = "Профиль"
        navigationController?.navigationBar.prefersLargeTitles = true
        let button = UIButton()
        button.setImage(UIImage(systemName: "rectangle.portrait.and.arrow.right"), for: .normal)
        button.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }

    // MARK: - LogOut function

    @objc func logOut(_: UITapGestureRecognizer) {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Fail to log out")
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ProfileView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProfileViewCells.reuseIdentifier,
            for: indexPath
        ) as? ProfileViewCells else {
            return .init()
        }
        cell.configureCell(number: String(indexPath.row + 1), place: places[indexPath.row].placeName)
        cell.backgroundColor = indexPath.row % 2 == 0 ? #colorLiteral(red: 0.955997279, green: 0.955997279, blue: 0.955997279, alpha: 1) : #colorLiteral(red: 0.8425348579, green: 0.8425348579, blue: 0.8425348579, alpha: 1)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tabBarController?.selectedIndex = 0
        print("It works")
        // zomm to selected place
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ProfileView: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let db = Firestore.firestore()
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            avatarView.image = image
        }
        DBManager.shared.uploadImage(id: Auth.auth().currentUser!.uid, photo: avatarView.image!, path: "avatars") { result in
            switch result {
            case .success(let url):
                db.collection("users").document(Auth.auth().currentUser!.uid).setData(["image": url.absoluteString], merge: true)
            case .failure(let error):
                print(error)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UINavigationControllerDelegate

extension ProfileView: UINavigationControllerDelegate {}

