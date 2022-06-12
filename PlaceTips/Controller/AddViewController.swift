import Firebase
import PanModal
import UIKit

class AddViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

        view.addSubview(placeNameInput)
        view.addSubview(otherInput)
        view.addSubview(handleView)
        view.addSubview(photoPicker)
        view.addSubview(addButton)
        
        setUpPlaceNameInputConstraints()
        setUpOtherInputConstraints()
        setUpPhotoPickerConstraints()
        setUpHandleViewConstraints()
        setUpButtonConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let tapGestureRecognizerOnPhotoPicker = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        let tapGestureRecognizerOnHandleView = UITapGestureRecognizer(target: self, action: #selector(selectImageAndHideView))
        photoPicker.addGestureRecognizer(tapGestureRecognizerOnPhotoPicker)
        handleView.addGestureRecognizer(tapGestureRecognizerOnHandleView)
    }
    
    // MARK: - Some Data
    var cityName = ""
    var lat = 0.0
    var lon = 0.0
    var count = 0
    
    // MARK: - PlaceNameTextField

    let placeNameInput: PaddingTextField = {
        let textField = PaddingTextField()
        textField.placeholder = "Название для этого места"
        
        textField.bottomInset = 10.0
        textField.topInset = 10.0
        textField.leftInset = 10.0
        textField.rightInset = 10.0
        
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 20
        textField.layer.borderWidth = 1
        textField.backgroundColor = ColorPalette.inputsBackground
        textField.layer.masksToBounds = true
        textField.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return textField
    }()
    
    // MARK: - OtherTextField

    let otherInput: PaddingTextField = {
        let textField = PaddingTextField()
        
        textField.bottomInset = 10.0
        textField.topInset = 10.0
        textField.leftInset = 10.0
        textField.rightInset = 10.0
        
        textField.placeholder = "Описание места(опицаонльно)"
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 20
        textField.layer.borderWidth = 1
        textField.backgroundColor = ColorPalette.inputsBackground
        textField.layer.masksToBounds = true
        textField.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        textField.returnKeyType = UIReturnKeyType.done
        
        return textField
    }()
    
    // MARK: - Default view for ImageView

    let handleView: UIView = {
        let view = UIView()
        
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.backgroundColor = ColorPalette.inputsBackground
        view.layer.masksToBounds = true
        view.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 256).isActive = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImageAndHideView))
        tapGestureRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGestureRecognizer)
        
        let label = UILabel()
        label.text = "Выберите фото из галереи..."
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .lightGray
        
        let image = UIImageView()
        image.image = UIImage(systemName: "photo.on.rectangle.angled")!
        image.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.widthAnchor.constraint(equalToConstant: 125).isActive = true
        image.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(label)
        view.addSubview(image)

        image.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -10),

            label.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 10),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        return view
    }()
    
    @objc func selectImageAndHideView(tapGestureRecognizer: UITapGestureRecognizer) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary // подумать как использовать камеру
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
        
//        handleView.isHidden = true
//        photoPicker.isHidden = false
    }
    
    // MARK: - ImageView

    let photoPicker: UIImageView = {
        let view = UIImageView()
        
        view.widthAnchor.constraint(equalToConstant: 256).isActive = true
        view.heightAnchor.constraint(equalToConstant: 256).isActive = true
        
        view.isHidden = true
        
        view.layer.cornerRadius = 25
        view.image = UIImage(named: "default_pic")
        view.isUserInteractionEnabled = true
        view.contentMode = .scaleAspectFit
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        tapGestureRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGestureRecognizer)
        return view
    }()
    
    @objc func selectImage(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary // подумать как использовать камеру
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    // MARK: - Add button

    let addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 110).isActive = true
        button.heightAnchor.constraint(equalToConstant: 35).isActive = true
        button.setTitle("Добавить", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 35/2
        button.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
        return button
    }()
    
    @objc func addButtonAction(_: UITapGestureRecognizer) {
        let db = Firestore.firestore()
        if !placeNameInput.text!.isEmpty, photoPicker.image != UIImage(named: "default_pic") {
            DBManager.shared.uploadImage(id: Auth.auth().currentUser!.uid, photo: photoPicker.image!, path: "placesPicture") { [self] result in
                switch result {
                case .success(let url):
                    db.collection(cityName).document("\(count + 1)").setData([
                        "id": cityName + "_" + "\(count + 1)",
                        "lat": "\(lat)",
                        "lon": "\(lon)",
                        "other": otherInput.text ?? "-",
                        "placeName": placeNameInput.text!,
                        "placeImageUrl": url.absoluteString
                    ]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                case .failure(let error):
                    print("Fail to add place to Database")
                }
            }
            
        } else {
            print("Введите название места")
        }
        // добавление в бд метки и рефреш карты
    }
    
    // MARK: - SetUp constraints

    func setUpPlaceNameInputConstraints() {
        placeNameInput.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placeNameInput.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            placeNameInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            placeNameInput.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func setUpOtherInputConstraints() {
        otherInput.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            otherInput.topAnchor.constraint(equalTo: placeNameInput.bottomAnchor, constant: 20),
            otherInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            otherInput.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func setUpPhotoPickerConstraints() {
        photoPicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoPicker.topAnchor.constraint(equalTo: otherInput.bottomAnchor, constant: 20),
            photoPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setUpHandleViewConstraints() {
        handleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            handleView.topAnchor.constraint(equalTo: otherInput.bottomAnchor, constant: 20),
            handleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            handleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            handleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func setUpButtonConstraints() {
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.topAnchor.constraint(equalTo: photoPicker.bottomAnchor, constant: 20)
        ])
    }
}

// MARK: - Extension PanModalPresentable

extension AddViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        nil
    }

    var shortFormHeight: PanModalHeight {
        return .contentHeight(UIScreen.main.bounds.height/1.9)
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

// MARK: - Extension UIImagePickerControllerDelegate

extension AddViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            photoPicker.image = image
        }
        handleView.isHidden = true
        photoPicker.isHidden = false
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Extension UINavigationControllerDelegate

extension AddViewController: UINavigationControllerDelegate {}

// MARK: - Extension UITextFieldDelegate

extension AddViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        becomeFirstResponder()
    }
}

// MARK: - PaddingTextField class

class PaddingTextField: UITextField {
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
