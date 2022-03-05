//
//  CitiesView.swift
//  PlaceTips
//
//  Created by Дмитрий Шайманов on 17.02.2022.
//

import UIKit

final class CitiesView: UITableViewController {
    var citiesArray: [String] = [] {
        didSet {
            output = citiesArray
            loadingView.stopAnimating()
            tableView.reloadData()
        }
    }

    private var searchDebouncerTimer: Timer?
    var apiService = APIService()
    var output: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loadingView)
        setupSearchBar()
        setupTableView()
        setupNavBar()
        
        loadCities()
        
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    var loadingView = UIActivityIndicatorView()

    // MARK: - SetIp SearchBar

    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }

    // MARK: - SetUp TableView

    private func setupTableView() {
        tableView.backgroundColor = .lightGray
        tableView.register(CitiesViewCells.self,
                           forCellReuseIdentifier: CitiesViewCells.identifier)
    }

    // MARK: - SetUp NavigationBar

    private func setupNavBar() {
        navigationItem.title = "Города"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Load cities from DB

    private func loadCities() {
        DispatchQueue.main.async {
            self.loadingView.startAnimating()
            self.apiService.getPost(collection: "country", docName: "Country", completion: { result in
                switch result {
                case .success(let cities):
                    self.citiesArray.append(contentsOf: cities.russia)
                case .failure(let error):
                    print("Error") // Впихнуть алерт
                }
            })
        }
    }

    // MARK: - Overrides for TableView

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return output.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CitiesViewCells.identifier,
            for: indexPath
        ) as? CitiesViewCells else {
            return .init()
        }
        cell.configureCityCell(cityName: output[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PlacesView()
        navigationController?.pushViewController(vc, animated: true)
        vc.navigationItem.title = output[indexPath.row]
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        navigationItem.searchController?.searchBar.resignFirstResponder()
    }
}

// MARK: - UISearchBarDelegate extension

extension CitiesView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchDebouncerTimer?.invalidate()

        let timer = Timer.scheduledTimer(
            withTimeInterval: 1.0,
            repeats: false
        ) { [weak self] _ in
            self?.fireTimer()
            self?.tableView.reloadData()
        }

        searchDebouncerTimer = timer
    }

    private func fireTimer() {
        if navigationItem.searchController?.searchBar.text?.isEmpty == true {
            output = citiesArray
        } else {
            output = search(data: citiesArray, input: navigationItem.searchController?.searchBar.text ?? "")
        }
    }

    func search(data: [String], input: String) -> [String] {
        var outputData = [String]()
        for element in data {
            if element.lowercased().contains(input.lowercased()) {
                outputData.append(element)
            }
        }
        return outputData
    }
}
