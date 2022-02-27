//
//  CitiesView.swift
//  PlaceTips
//
//  Created by Дмитрий Шайманов on 17.02.2022.
//

import UIKit

final class CitiesView: UITableViewController {
    var citiesArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchBar()
        tableView.backgroundColor = .lightGray
        tableView.register(CitiesViewCells.self,
                           forCellReuseIdentifier: CitiesViewCells.reuseIdentifier)
        navigationItem.title = "Города"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        APIService().getPost(collection: "country", docName: "Country", completion: {doc in
            guard doc != nil else {return}
                self.citiesArray = (doc?.Russia)!
        })
        print(citiesArray)
    }

    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
    }

    // MARK: - Overrides to tableView

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CitiesViewCells.reuseIdentifier,
            for: indexPath
        ) as? CitiesViewCells else {
            return .init()
        }
        cell.configureCityCell(cityName: citiesArray[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SomeVC(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(vc, animated: true)
    }
}
