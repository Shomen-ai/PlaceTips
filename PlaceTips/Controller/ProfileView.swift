//
//  Profile.swift
//  PlaceTips
//
//  Created by Дмитрий Шайманов on 13.03.2022.
//

import UIKit

final class ProfileView: UIViewController {
    override func viewDidLoad() {
        navigationItem.title = "Профиль"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(avatarView)
        setupAvatarConstraints()
        
        view.addSubview(nicknameLabel)
        setUpLabelConstraints()
        
        view.addSubview(tableView)
        view.addSubview(favLabel)
        setUpTableViewConstraints()
    }
    
    // MARK: - AvatarImage
    
    let avatarView: UIImageView = {
        let view = UIImageView()
        // view.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 30.0, height: 30.0))
        view.image = resizeImage(image: UIImage(named: "default_pic")!, targetSize: CGSize(width: 150.0, height: 150.0))
        
        view.contentMode = UIView.ContentMode.scaleAspectFit
        view.frame.size.width = 150.0
        view.frame.size.height = 150.0
        view.layer.cornerRadius = view.frame.size.height / 2
        view.clipsToBounds = true
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.lightGray.cgColor
        
        return view
    }()
    
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
        label.font = .systemFont(ofSize: 20)
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
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(ProfileViewCells.self,
                       forCellReuseIdentifier: ProfileViewCells.reuseIdentifier)
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    func setUpTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        favLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            favLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 20),
            favLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: favLabel.bottomAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
        ])
    }

    // MARK: -
}

func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
    let size = image.size
    let widthRatio = targetSize.width / size.width
    let heightRatio = targetSize.height / size.height
    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if widthRatio > heightRatio {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
    }
    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRect(origin: .zero, size: newSize)
    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
}

extension ProfileView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var items = ["1", "2", "3"]
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProfileViewCells.reuseIdentifier,
            for: indexPath
        ) as? ProfileViewCells else {
            return .init()
        }
        cell.configureCell(number: items[indexPath.row])
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}
