import Firebase
import PanModal
import SwiftUI
import UIKit

class PinInfoViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

        view.addSubview(placeNameInput)
        view.addSubview(otherInput)
        view.addSubview(photoPicker)
        view.addSubview(favButton)
        view.addSubview(raitingView)
        
        setUpPlaceNameInputConstraints()
        setUpOtherInputConstraints()
        setUpPhotoPickerConstraints()
        setUpFavButtonConstraints()
        setUpRaitingViewConstraints()
        
        placeNameInput.text = placeName
        otherInput.text = other
        
        if favIndex[id]! == "1" {
            favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            favButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        print(id)
    }

    // MARK: - Some Data

    var placeName = String()
    var other = String()
    var id = String()
    var favIndex = ["Kazan_0": "1",
                    "Kazan_1": "1"]
    var cityName = String()
    var raiting = 4.5 // вычисляемая переменная по данным из бд

    // MARK: - PlaceName Label

    let placeNameInput: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "Название места..."
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20.0)
        
        label.bottomInset = 10.0
        label.topInset = 10.0
        label.leftInset = 10.0
        label.rightInset = 10.0
        
        label.layer.cornerRadius = 20
        label.layer.borderWidth = 1
        label.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        label.backgroundColor = ColorPalette.inputsBackground
        label.layer.masksToBounds = true
        return label
    }()
    
    // MARK: - Other Label

    let otherInput: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "Описание места..."
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17.0)
        
        label.bottomInset = 10.0
        label.topInset = 10.0
        label.leftInset = 10.0
        label.rightInset = 10.0
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 60).isActive = true
        
        label.layer.cornerRadius = 20
        label.layer.borderWidth = 1
        label.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        label.backgroundColor = ColorPalette.inputsBackground
        label.layer.masksToBounds = true
        return label
    }()
    
    // MARK: - ImageView

    let photoPicker: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 256).isActive = true
        view.heightAnchor.constraint(equalToConstant: 256).isActive = true
        view.layer.cornerRadius = 25
        view.image = UIImage(named: "default_pic")
        view.isUserInteractionEnabled = true
        view.contentMode = .scaleAspectFit
        return view
    }()

    // MARK: - FavButton

    var favButton: UIButton = {
        var button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
         
        button.layer.cornerRadius = 50/2
        button.clipsToBounds = true
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button.tintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        button.addTarget(self, action: #selector(addToFav), for: .touchUpInside)
        return button
    }()

    // почему не робит кнопка
    @objc func addToFav(tapGestureRecognizer: UITapGestureRecognizer) {
        if favIndex[id]! == "1" {
            favIndex[id]! = "0"
            favButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        if favIndex[id]! == "0" {
            favIndex[id]! = "1"
            favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        print(favIndex[id]!)
        let db = Firestore.firestore()
        db.collection("users").document(Auth.auth().currentUser!.uid).setData(["favorites": [id: favIndex[id]!]], merge: true)
    }
    
    // MARK: - Raiting View

    let raitingView: UIView = {
        let view = UIView()
        
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.layer.masksToBounds = true
        view.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let label = UILabel()
        label.text = "Рейтинг: "
        label.font = UIFont.systemFont(ofSize: 15)
        
        let width = 25
        let height = 22
        let image1 = UIImageView()
        image1.image = UIImage(systemName: "star")!
        image1.tintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        image1.translatesAutoresizingMaskIntoConstraints = false
        image1.widthAnchor.constraint(equalToConstant: CGFloat(width)).isActive = true
        image1.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
        
        let image2 = UIImageView()
        image2.image = UIImage(systemName: "star")!
        image2.tintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        image2.translatesAutoresizingMaskIntoConstraints = false
        image2.widthAnchor.constraint(equalToConstant: CGFloat(width)).isActive = true
        image2.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
       
        let image3 = UIImageView()
        image3.image = UIImage(systemName: "star")!
        image3.tintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        image3.translatesAutoresizingMaskIntoConstraints = false
        image3.widthAnchor.constraint(equalToConstant: CGFloat(width)).isActive = true
        image3.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
       
        let image4 = UIImageView()
        image4.image = UIImage(systemName: "star")!
        image4.tintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        image4.translatesAutoresizingMaskIntoConstraints = false
        image4.widthAnchor.constraint(equalToConstant: CGFloat(width)).isActive = true
        image4.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
       
        let image5 = UIImageView()
        image5.image = UIImage(systemName: "star")!
        image5.tintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        image5.translatesAutoresizingMaskIntoConstraints = false
        image5.widthAnchor.constraint(equalToConstant: CGFloat(width)).isActive = true
        image5.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
       
        view.addSubview(label)
        view.addSubview(image1)
        view.addSubview(image2)
        view.addSubview(image3)
        view.addSubview(image4)
        view.addSubview(image5)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            image1.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            image1.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 10),
            
            image2.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            image2.leadingAnchor.constraint(equalTo: image1.trailingAnchor, constant: 5),
            
            image3.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            image3.leadingAnchor.constraint(equalTo: image2.trailingAnchor, constant: 5),
            
            image4.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            image4.leadingAnchor.constraint(equalTo: image3.trailingAnchor, constant: 5),
            
            image5.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            image5.leadingAnchor.constraint(equalTo: image4.trailingAnchor, constant: 5)
        ])
        
        return view
    }()

    // MARK: - SetUp Constraints

    func setUpPlaceNameInputConstraints() {
        placeNameInput.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placeNameInput.topAnchor.constraint(equalTo: view.topAnchor, constant: 25),
            placeNameInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            placeNameInput.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25)
        ])
    }
    
    func setUpOtherInputConstraints() {
        otherInput.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            otherInput.topAnchor.constraint(equalTo: placeNameInput.bottomAnchor, constant: 20),
            otherInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            otherInput.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25)
        ])
    }
    
    func setUpPhotoPickerConstraints() {
        photoPicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoPicker.topAnchor.constraint(equalTo: otherInput.bottomAnchor, constant: 20),
            photoPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setUpFavButtonConstraints() {
        NSLayoutConstraint.activate([
            favButton.topAnchor.constraint(equalTo: photoPicker.bottomAnchor, constant: 20),
            favButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25)
        ])
    }
    
    func setUpRaitingViewConstraints() {
        NSLayoutConstraint.activate([
            raitingView.topAnchor.constraint(equalTo: photoPicker.bottomAnchor, constant: 20),
            raitingView.leadingAnchor.constraint(equalTo: favButton.trailingAnchor, constant: 25),
            raitingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
        ])
    }
}

// MARK: - Extension PanModalPresentable

extension PinInfoViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        nil
    }

    var shortFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(UIScreen.main.bounds.height/3 - 15)
    }

    var anchorModalToLongForm: Bool {
        return false
    }

    var cornerRadius: CGFloat {
        return 25
    }
    
    var isUserInteractionEnabled: Bool {
        return true
    }
}

// MARK: - PaddingLabel class

class PaddingLabel: UILabel {
    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 5.0
    @IBInspectable var rightInset: CGFloat = 5.0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += topInset + bottomInset
        contentSize.width += leftInset + rightInset
        return contentSize
    }
}
