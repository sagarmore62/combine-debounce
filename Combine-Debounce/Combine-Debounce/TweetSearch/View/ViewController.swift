//
//  ViewController.swift
//  Combine-Debounce
//
//  Created by Sagar More on 27/07/19.
//  Copyright © 2019 Sagar More. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tblView : UITableView!
    private let cellIdentifier = "TweetTableViewCell"
    private var viewModel = TweetVM()
    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        bindSearchBarToListener()
        setupTableView()
        viewModel.delegate = self
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupTableView() {
        tblView.dataSource = self
        tblView.rowHeight = UITableView.automaticDimension
        tblView.estimatedRowHeight = 150
    }
    
    /// Binds UISearchTextField to listener
    private func bindSearchBarToListener() {
        //create publisher for UISearchTextField
        let publisher = NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: searchController.searchBar.searchTextField)
        //listen to publisher events through sink.
        //debounce that allows us to throttle changes we receive when typing into a search field.
        //Read more : https://developer.apple.com/documentation/combine/anypublisher/3204205-debounce
        publisher
            .compactMap{($0.object as! UISearchTextField).text}
            .debounce(for: .milliseconds(400), scheduler: RunLoop.main)
            .sink { [weak self] (query) in
                self?.viewModel.searchTweetFor(query)
        }
    }
    
}

// MARK: - view model delegate methods
extension ViewController : TweetVMDelegate {
    func reloadUI() {
        tblView.reloadData()
    }
}

// MARK: - Tableview datasource methods
extension ViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowData = viewModel.getDataForRowAt(indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TweetTableViewCell
        cell.setupUI(rowData)
        return cell
    }
}

