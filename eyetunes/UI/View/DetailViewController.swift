//
//  DetailViewController.swift
//  eyetunes
//
//  Created by Steven Spry on 5/29/20.
//  Copyright © 2020 Steven Spry. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView:UIScrollView!
    @IBOutlet weak var contentView:UIView!
    @IBOutlet weak var albumImage:UIImageView!
    @IBOutlet weak var artistLabel:UILabel!
    @IBOutlet weak var albumLabel:UILabel!
    @IBOutlet weak var genreLabel:UILabel!
    @IBOutlet weak var releaseLabel:UILabel!
    @IBOutlet weak var copyrightLabel:UILabel!
    
    @IBOutlet weak var itunesButtonView:UIView!
    @IBOutlet weak var iTunesButton: UIButton!

    lazy var viewModel : AlbumViewModel = {
        let viewModel = AlbumViewModel()
        return viewModel
    }()
        
    var album : Album?
    
    func setAlbum() {
        guard let album = album else {
            return
        }
        viewModel.album = album
        
        artistLabel.text = album.artist
        albumLabel.text = album.album
        genreLabel.text = "Genre: \(album.genre)"
        releaseLabel.text = "Released: \(album.formattedReleaseDate)"
        copyrightLabel.text = album.copyright
        
        
        
        if let largeURL = largeURL(album.thumbnailUrl) {
            ImageService.shared.fetchImage(url: largeURL) { [weak self] (image) in
                if let image = image {
                    self?.albumImage.image = image
                } else {
                    self?.albumImage.image = nil
                }
            }
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        title = Strings.fromKey("DetailTitle")
        
        let logo = UIImage(named: "NavIcon")
        let imageView = UIImageView(image:logo)
        let buttonItem = UIBarButtonItem(customView: imageView)
        navigationItem.rightBarButtonItem = buttonItem

        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setAlbum()
    }
    
    private func largeURL(_ string:String) -> String? {
        
        if let baseURL = URL(string: string)?.deletingLastPathComponent() {
            let largeURL = baseURL.appendingPathComponent(Strings.fromKey("AlbumLargeFilename"))
            return largeURL.absoluteString
        }
        return nil
    }
}

// MARK: - Setup Views
extension DetailViewController {
    
    fileprivate func setupViews() {
        contentView.backgroundColor = .white
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.darkGray.withAlphaComponent(0.5).cgColor
        contentView.layer.cornerRadius = 12.0
        contentView.clipsToBounds = false
        
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.shadowOffset = .zero
        contentView.layer.shadowRadius = 5

        view.backgroundColor = UIColor.init(red: 244/255, green: 244/255, blue: 244/255, alpha: 1.0)
        iTunesButton.addTarget(viewModel, action: #selector(AlbumViewModel.openStore(_:)), for: .touchUpInside)
        iTunesButton.layer.cornerRadius = 16.0
        iTunesButton.layer.borderWidth = 1.0
        iTunesButton.clipsToBounds = true
        iTunesButton.layer.borderColor = UIColor.systemRed.cgColor
        iTunesButton.setTitle(Strings.fromKey("OpeniTunesAction"), for: .normal)
        iTunesButton.setTitleColor(.white, for: .normal)
        iTunesButton.translatesAutoresizingMaskIntoConstraints = false
        iTunesButton.titleLabel?.font = UIFont.buttonTitleFont()
        iTunesButton.backgroundColor = .systemRed
        
        artistLabel.font = UIFont.artistFont()
        albumLabel.font = UIFont.albumFont()
        genreLabel.font = UIFont.normalFont()
        releaseLabel.font = UIFont.normalFont()
        copyrightLabel.font = UIFont.normalFont()

    }
    
}
