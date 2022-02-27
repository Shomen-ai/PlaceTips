import UIKit

final class SomeVC: UICollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .red
        setupNavigationBar()
    }
    private func setupNavigationBar() {
        let title = UILabel()
        title.text = "FAVOURRITES"
        title.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        title.textColor = .lightGray
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: title)
    }
}
