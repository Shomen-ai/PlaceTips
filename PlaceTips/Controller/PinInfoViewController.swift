import PanModal
import UIKit
import SwiftUI

class PinInfoViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

        view.addSubview(placeNameInput)
        view.addSubview(otherInput)
        view.addSubview(photoPicker)

        setUpPlaceNameInputConstraints()
        setUpOtherInputConstraints()
//        setUpPhotoPickerConstraints()
    }
    
    let placeNameInput: UILabel = {
        let label = UILabel()
        label.text = "Название места"
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let otherInput: UILabel = {
        let label = UILabel()
        label.text = "Описание места"
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let photoPicker: UIImageView = {
        let view = UIImageView(frame: CGRect(x: UIScreen.main.bounds.width/2 - 256/2, y: 135, width: 256, height: 256))
        view.layer.cornerRadius = 25
        view.image = UIImage(named: "default_pic")
        view.isUserInteractionEnabled = true
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    func setUpPlaceNameInputConstraints() {
        placeNameInput.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placeNameInput.topAnchor.constraint(equalTo: view.topAnchor, constant: 25),
            placeNameInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25)
        ])
    }
    
    func setUpOtherInputConstraints() {
        otherInput.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            otherInput.topAnchor.constraint(equalTo: placeNameInput.bottomAnchor, constant: 20),
            otherInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25)
        ])
    }
}

extension PinInfoViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        nil
    }

    var shortFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(UIScreen.main.bounds.height/2.4)
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

/// Тут надо на кнопку "Готово" закрыть клаву
///
