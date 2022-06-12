//
//  ProfileViewCells.swift
//  PlaceTips
//
//  Created by Дмитрий Шайманов on 08.05.2022.
//

import Foundation
import UIKit

final class ProfileViewCells: UITableViewCell {
    
    static let reuseIdentifier = "Cell_Cell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(numberLabel)
        contentView.addSubview(placeLabel)
        setUpNumberLabelConstraints()
        setUpPlaceLabelConstraints()
    }
    // номер по порядку
    let numberLabel: UILabel = {
        let label = UILabel()
        label.font =  .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // название места
    let placeLabel: UILabel = {
        let label = UILabel()
        label.font =  .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setUpNumberLabelConstraints() {
        NSLayoutConstraint.activate([
            numberLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func setUpPlaceLabelConstraints() {
        NSLayoutConstraint.activate([
            placeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            placeLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configureCell(number: String, place: String) {
        numberLabel.text = number
        placeLabel.text = place
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("commit #31")
    }
}
