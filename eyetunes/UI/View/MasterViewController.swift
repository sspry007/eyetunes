//
//  MasterViewController.swift
//  eyetunes
//
//  Created by Steven Spry on 5/28/20.
//  Copyright © 2020 Steven Spry. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {
        
    lazy var viewModel : AlbumsViewModel = {
        let viewModel = AlbumsViewModel(isMocked: false)
        return viewModel
    }()
    
    // MARK: - UI Elements
    let tableView:UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 66
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(AlbumCell.self, forCellReuseIdentifier: "AlbumCell")
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        
        return tableView
    }()
    
    let activityIndicator:UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    let cancelButton: UIBarButtonItem = {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: nil)
        return cancelButton
    }()
        
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Strings.fromKey("MasterTitle")
        view.backgroundColor = .white
        
        let activityButton = UIBarButtonItem(customView: activityIndicator)
        navigationItem.leftBarButtonItem = activityButton
        cancelButton.target = self
        cancelButton.action = #selector(tapCancel(_:))
        navigationItem.rightBarButtonItem = cancelButton

        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self

        setupConstraints()
        
        self.viewModel.fetchAlbums { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_) :
                    self?.closeFetch()
                    self?.tableView.reloadData()
                    break
                case .failure(let error) :
                    self?.closeFetch()

                    switch error {
                    case .network(let string):
                        self?.navigationItem.prompt = "Network: \(string)"
                    case .service(let string):
                        self?.navigationItem.prompt = "Service: \(string)"
                    case .parser(let string):
                        self?.navigationItem.prompt = "Parsing: \(string)"
                    case .custom(let string):
                        self?.navigationItem.prompt = "Custom: \(string)"
                    }
                }
            }
        }
        
    }
    
    // MARK: - Private Instance methods
    @objc fileprivate func tapCancel(_ sender: UIBarButtonItem) {
        viewModel.service?.cancelFetchAlbums()
        closeFetch()
    }
    
    fileprivate func closeFetch() {
        activityIndicator.stopAnimating()
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = nil
    }
    
    
}

// MARK: - Setup Constraints
extension MasterViewController {
    
    fileprivate func setupConstraints() {
        tableView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
}

// MARK: - TableView Delegates
extension MasterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath) as? AlbumCell else { return UITableViewCell()}
        
        let album = self.viewModel.albums[indexPath.row]
        cell.album = album
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let album = self.viewModel.albums[indexPath.row]
        let detailVC = DetailViewController()
        detailVC.album = album
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

