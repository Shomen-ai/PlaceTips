import PanModal
import UIKit

class AddViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

        view.addSubview(placeNameInput)
        view.addSubview(otherInput)
        view.addSubview(photoPicker)
        view.addSubview(addButton)

        setUpPlaceNameInputConstraints()
        setUpOtherInputConstraints()
//        setUpPhotoPickerConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        photoPicker.addGestureRecognizer(tapGestureRecognizer)
    }
    
    lazy var placeNameInput: UITextField = {
        lazy var textField = UITextField()
        textField.placeholder = "Название для этого места"
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 17.5
        textField.layer.borderWidth = 1
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.delegate = self
        return textField
    }()
    
    lazy var otherInput: UITextField = {
        lazy var textField = UITextField()
        textField.placeholder = "Описание места(опицаонльно)"
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 17.5
        textField.layer.borderWidth = 1
        textField.backgroundColor = .red
        textField.layer.masksToBounds = true
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.delegate = self
        return textField
    }()
    
    let photoPicker: UIImageView = {
        let view = UIImageView(frame: CGRect(x: UIScreen.main.bounds.width/2 - 256/2, y: 150, width: 256, height: 256))
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
    
    let addButton: UIButton = {
        let button = UIButton(frame: CGRect(x: UIScreen.main.bounds.width/2 - 110/2, y: 440, width: 110, height: 40))
        button.setTitle("Добавить", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = button.frame.height/2.2
        button.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
        return button
    }()
    
    func setUpPlaceNameInputConstraints() {
        placeNameInput.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placeNameInput.topAnchor.constraint(equalTo: view.topAnchor, constant: 25),
            placeNameInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }
    
    func setUpOtherInputConstraints() {
        otherInput.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            otherInput.topAnchor.constraint(equalTo: placeNameInput.bottomAnchor, constant: 20),
            otherInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }
    
//    func setUpPhotoPickerConstraints() {
//        photoPicker.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            photoPicker.topAnchor.constraint(equalTo: otherInput.bottomAnchor, constant: 20),
//            photoPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//        ])
//    }
//    func setUpButtonConstraints() {
//        addButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20)
//        ])
//    }

    @objc func addButtonAction(_: UITapGestureRecognizer) {
        print("Кнопка 1 робит")
        // добавление в бд метки и рефреш карты
    }
}

extension AddViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        nil
    }

    var shortFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(UIScreen.main.bounds.height/3)
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

extension AddViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // return NO to disallow editing.
        print("TextField should begin editing method called")
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        // became first responder
        print("TextField did begin editing method called")
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
        print("TextField should snd editing method called")
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
        print("TextField did end editing method called")
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        // if implemented, called in place of textFieldDidEndEditing:
        print("TextField did end editing with reason method called")
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // return NO to not change text
        print("While entering the characters this method gets called")
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        // called when clear button pressed. return NO to ignore (no notifications)
        print("TextField should clear method called")
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // called when 'return' key pressed. return NO to ignore.
        print("TextField should return method called")
        // may be useful: textField.resignFirstResponder()
        return true
    }
}

extension AddViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            photoPicker.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension AddViewController: UINavigationControllerDelegate {}

/// Тут надо на кнопку "Готово" закрыть клаву
///
