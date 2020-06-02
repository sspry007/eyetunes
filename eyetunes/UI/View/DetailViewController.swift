//
//  DetailViewController.swift
//  eyetunes
//
//  Created by Steven Spry on 5/29/20.
//  Copyright © 2020 Steven Spry. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    lazy var viewModel : AlbumViewModel = {
        let viewModel = AlbumViewModel()
        return viewModel
    }()
        
    var album : Album? {
        didSet {
            
            guard let album = album else {
                return
            }
            viewModel.album = album
            
            artistLabel.text = album.artist
            albumLabel.text = album.album
            genreLabel.text = "Genre: \(album.genre)"
            releaseLabel.text = "Released: \(album.formattedReleaseDate)"
            copyrightLabel.text = album.copyright

            AlbumService().loadAlbumArt(url: album.thumbnailUrl, size: .full) { (image) in
                if let image = image {
                    DispatchQueue.main.async { [weak self] in
                        self?.albumImage.image = image
                    }
                }
            }
        }
    }
    
    let scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.bounces = true
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
       return scrollView
    }()

    
    let contentView:UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .white
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.darkGray.cgColor
        contentView.layer.cornerRadius = 12.0
        contentView.clipsToBounds = true
        return contentView
    }()
 
    
    let albumImage:UIImageView = {
        let albumImage = UIImageView()
        albumImage.contentMode = .scaleAspectFill
        albumImage.translatesAutoresizingMaskIntoConstraints = false
        albumImage.heightAnchor.constraint(equalToConstant: 300).isActive = true
        albumImage.widthAnchor.constraint(equalToConstant: 300).isActive = true
        return albumImage
    }()
    
    let artistLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.font = UIFont.artistFont()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let albumLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.albumFont()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let genreLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.normalFont()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let releaseLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.normalFont()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let copyrightLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.mouseTypeFont()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let itunesButtonView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let iTunesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Strings.fromKey("OpeniTunesAction"), for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.buttonTitleFont()
        button.backgroundColor = .white
        button.layer.cornerRadius = 16.0
        button.layer.borderWidth = 1.0
        button.clipsToBounds = true
        button.layer.borderColor = UIColor.systemRed.cgColor
        return button
    }()

    

    override func viewDidLoad() {
        super.viewDidLoad()

        title = Strings.fromKey("DetailTitle")
        view.backgroundColor = UIColor.init(red: 244/255, green: 244/255, blue: 244/255, alpha: 1.0)
        iTunesButton.addTarget(viewModel, action: #selector(AlbumViewModel.openStore(_:)), for: .touchUpInside)
        
        setupViews()
        setupConstraints()
    }
    
}

// MARK: - Setup Views and Constraints
extension DetailViewController {
    
    fileprivate func setupViews() {
        view.addSubview(scrollView)
        view.addSubview(itunesButtonView)
        itunesButtonView.addSubview(iTunesButton)

        scrollView.addSubview(contentView)
        contentView.addSubview(albumImage)
        contentView.addSubview(albumLabel)
        contentView.addSubview(artistLabel)
        contentView.addSubview(genreLabel)
        contentView.addSubview(releaseLabel)
        contentView.addSubview(copyrightLabel)
    }
    
    fileprivate func setupConstraints() {
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo:view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo:view.trailingAnchor).isActive = true

        itunesButtonView.topAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true

        itunesButtonView.leadingAnchor.constraint(equalTo:view.leadingAnchor).isActive = true
        itunesButtonView.trailingAnchor.constraint(equalTo:view.trailingAnchor).isActive = true
        itunesButtonView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        itunesButtonView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        iTunesButton.topAnchor.constraint(equalTo: itunesButtonView.topAnchor, constant: 20).isActive = true
        iTunesButton.leadingAnchor.constraint(equalTo: itunesButtonView.leadingAnchor, constant: 20).isActive = true
        iTunesButton.trailingAnchor.constraint(equalTo: itunesButtonView.trailingAnchor, constant: -20).isActive = true
        iTunesButton.bottomAnchor.constraint(equalTo: itunesButtonView.bottomAnchor, constant: -20).isActive = true

        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true

        albumImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        albumImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        albumImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true

        albumLabel.topAnchor.constraint(equalTo:albumImage.bottomAnchor, constant: 20).isActive = true
        albumLabel.leadingAnchor.constraint(equalTo:contentView.leadingAnchor,constant: 20).isActive = true
        albumLabel.trailingAnchor.constraint(equalTo:contentView.trailingAnchor,constant: -20).isActive = true

        artistLabel.topAnchor.constraint(equalTo:albumLabel.bottomAnchor, constant: 10).isActive = true
        artistLabel.leadingAnchor.constraint(equalTo:contentView.leadingAnchor,constant: 20).isActive = true
        artistLabel.trailingAnchor.constraint(equalTo:contentView.trailingAnchor,constant: -20).isActive = true

        genreLabel.topAnchor.constraint(equalTo:artistLabel.bottomAnchor, constant: 40).isActive = true
        genreLabel.leadingAnchor.constraint(equalTo:contentView.leadingAnchor,constant: 20).isActive = true
        genreLabel.trailingAnchor.constraint(equalTo:contentView.trailingAnchor,constant: -20).isActive = true

        releaseLabel.topAnchor.constraint(equalTo:genreLabel.bottomAnchor, constant: 5).isActive = true
        releaseLabel.leadingAnchor.constraint(equalTo:contentView.leadingAnchor,constant: 20).isActive = true
        releaseLabel.trailingAnchor.constraint(equalTo:contentView.trailingAnchor,constant: -20).isActive = true

        copyrightLabel.topAnchor.constraint(equalTo:releaseLabel.bottomAnchor, constant: 20).isActive = true
        copyrightLabel.leadingAnchor.constraint(equalTo:contentView.leadingAnchor,constant: 20).isActive = true
        copyrightLabel.trailingAnchor.constraint(equalTo:contentView.trailingAnchor,constant: -20).isActive = true
        copyrightLabel.bottomAnchor.constraint(equalTo:contentView.bottomAnchor,constant: -20).isActive = true
    }
    
}
