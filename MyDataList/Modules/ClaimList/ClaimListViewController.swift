//
//  ClaimListViewController.swift
//  MyDataList
//
//  Created by Dicka Reynaldi on 15/04/25.
//

import UIKit

class ClaimListViewController: UIViewController {
    var presenter: ClaimListViewOutput?

    private var claims: [Claim] = []
    private var datas: [MappedClaim] = []
    private var filteredClaims: [MappedClaim] = []
    var allClaims: [Claim] = []
    var hasMoreData: Bool {
        return filteredClaims.count < allClaims.count
    }
    private var loadedDataCount = 0
    private let pageSize = 5
    private var displayedClaims: [MappedClaim] = []


    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ClaimTableViewCell.self, forCellReuseIdentifier: ClaimTableViewCell.identifier)
        return tableView
    }()

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search Claims"
        searchBar.delegate = self
        return searchBar
    }()

    private lazy var sortDirectionSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Ascending", "Descending"])
        control.translatesAutoresizingMaskIntoConstraints = false
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(applyFilterAndSearch), for: .valueChanged)
        return control
    }()

    private lazy var sortBySegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Claim ID", "Claimant ID"])
        control.translatesAutoresizingMaskIntoConstraints = false
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(applyFilterAndSearch), for: .valueChanged)
        return control
    }()

    private var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Claims"
        view.backgroundColor = .white

        setupUI()
        presenter?.viewDidLoad()
    }

    private func setupUI() {
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])

        view.addSubview(sortBySegmentedControl)
        NSLayoutConstraint.activate([
            sortBySegmentedControl.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            sortBySegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sortBySegmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])

        view.addSubview(sortDirectionSegmentedControl)
        NSLayoutConstraint.activate([
            sortDirectionSegmentedControl.topAnchor.constraint(equalTo: sortBySegmentedControl.bottomAnchor, constant: 10),
            sortDirectionSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sortDirectionSegmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: sortDirectionSegmentedControl.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])

        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func applyFilterAndSearch() {
        var filtered = datas

        if let searchText = searchBar.text, !searchText.isEmpty {
            filtered = filtered.filter { claim in
                return claim.title.lowercased().contains(searchText.lowercased()) ||
                       claim.body.lowercased().contains(searchText.lowercased())
            }
        }

        let ascending = sortDirectionSegmentedControl.selectedSegmentIndex == 0
        let sortByClaimId = sortBySegmentedControl.selectedSegmentIndex == 0

        filtered.sort {
            if sortByClaimId {
                return ascending ? $0.id < $1.id : $0.id > $1.id
            } else {
                return ascending ? $0.userName < $1.userName : $0.userName > $1.userName
            }
        }

        filteredClaims = filtered
        loadedDataCount = 0
        displayedClaims = []
        loadNextPage()

    }

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private func setLoadingState(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    private func loadNextPage() {
        let nextPageCount = min(loadedDataCount + pageSize, filteredClaims.count)
        let newItems = Array(filteredClaims[loadedDataCount..<nextPageCount])
        loadedDataCount = nextPageCount
        displayedClaims.append(contentsOf: newItems)
        tableView.reloadData()
    }

}

// MARK: - ClaimListViewInput
extension ClaimListViewController: ClaimListViewInput {
    func showDatas(_ datas: [MappedClaim]) {
        self.datas = datas
        applyFilterAndSearch()
    }
    
    func showClaims(_ claims: [Claim]) {
        self.claims = claims
        presenter?.fetchData()

    }

    func showError(_ error: String) {
        setLoadingState(false)
        showErrorAlert(message: error)
    }

    func showLoading(_ isLoading: Bool) {
        setLoadingState(isLoading)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ClaimListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedClaims.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let claim = displayedClaims[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ClaimTableViewCell.identifier, for: indexPath) as! ClaimTableViewCell
        cell.configure(claim: claim)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedClaim = filteredClaims[indexPath.row]
        let detailVC = ClaimDetailRouter.createModule(with: selectedClaim)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        if position > contentHeight - frameHeight - 100 {
            guard loadedDataCount < filteredClaims.count else { return }
            loadNextPage()
        }
    }

    
}

// MARK: - UISearchBarDelegate
extension ClaimListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        applyFilterAndSearch()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
