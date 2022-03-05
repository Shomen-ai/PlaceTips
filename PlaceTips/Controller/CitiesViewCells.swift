import UIKit

final class CitiesViewCells: UITableViewCell {
    
    private lazy var cityLabel: UILabel = {
        let nickname = UILabel()
        nickname.layer.frame.size.width = contentView.layer.frame.size.width / 2
        nickname.lineBreakMode = .byTruncatingTail
        nickname.numberOfLines = 1
        nickname.font = .systemFont(ofSize: 17)
        nickname.textColor = .black
        nickname.translatesAutoresizingMaskIntoConstraints = false
        return nickname
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupCellsConstrains()
    }

    // MARK: setupConstrains of items in TableViewCell

    private func setupCellsConstrains() {
        contentView.addSubview(cityLabel)

        cityLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        NSLayoutConstraint.activate([

            cityLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            cityLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 20
            )
        ])
    }

    func configureCityCell(cityName: String) {
        cityLabel.text = "\(cityName)"
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("tableError")
    }
}


extension UITableViewCell {
    public class var identifier: String {
        return "\(self.self)"
    }
}
