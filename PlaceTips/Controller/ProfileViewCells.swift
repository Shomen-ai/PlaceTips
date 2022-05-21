//
//  ProfileViewCells.swift
//  PlaceTips
//
//  Created by Дмитрий Шайманов on 08.05.2022.
//

import Foundation
import UIKit

final class ProfileViewCells: UITableViewCell {
    // MARK: Margins for items in TableViewCell

    private enum Margin {
        static let topMargin: CGFloat = 10
        static let bottomMargin: CGFloat = -10
        static let leadingMargin: CGFloat = 25
        static let trailingMargin: CGFloat = -20
    }


    static let reuseIdentifier = "Cell_Cell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    let label: UILabel = {
        let label = UILabel()
        return label
    }()
    
    func configureCell(number: String) {
        label.text = number
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("commit #31")
    }
}
