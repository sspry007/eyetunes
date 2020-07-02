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
        let viewModel = AlbumsViewModel(isMocked: true)
        return viewModel
    }()
    
    // MARK: - UI Elements
    @IBOutlet weak var tableView:UITableView!
    let refreshControl = UIRefreshControl()
    let navIcon: UIBarButtonItem = {
        let logo = UIImage(named: "NavIcon")
        let imageView = UIImageView(image:logo)
        let buttonItem = UIBarButtonItem(customView: imageView)
        return buttonItem
    }()
        
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Strings.fromKey("MasterTitle")
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = navIcon
        
        setupViews()
        fetchAlbums()
    }
    
    // MARK: - Private Instance methods
    @objc private func refreshData() {
        self.refreshControl.beginRefreshing()
        fetchAlbums()
    }
    
    func fetchAlbums() {
        refreshControl.beginRefreshing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
            self.viewModel.fetchAlbums { [weak self] result in
                
                DispatchQueue.main.async {
                    
                    self?.refreshControl.endRefreshing()

                    switch result {
                    case .success(_) :
                        self?.tableView.reloadData()
                        break
                    case .failure(let error) :
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        if segue.identifier == "PickAlbumSegue", let detailViewController = segue.destination as? DetailViewController {
            if let selectedIndex = self.tableView.indexPathForSelectedRow {
                let album = self.viewModel.albums[selectedIndex.row]
                detailViewController.album = album
            }
        }
    }
    
}

// MARK: - Setup Views
extension MasterViewController {
    
    fileprivate func setupViews() {
        view.backgroundColor = .white

        refreshControl.addTarget(self, action: #selector(self.refreshData), for: .valueChanged)
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = self.refreshControl
        } else {
            self.tableView.addSubview(self.refreshControl)
        }

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 66
        tableView.rowHeight = UITableView.automaticDimension
        //tableView.register(AlbumCell.self, forCellReuseIdentifier: "AlbumCell")
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
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
    }
}

