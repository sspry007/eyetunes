//
//  AlbumCell.swift
//  eyetunes
//
//  Created by Steven Spry on 5/28/20.
//  Copyright © 2020 Steven Spry. All rights reserved.
//

import UIKit

class AlbumCell: UITableViewCell {
    
    var album : Album? {
        didSet {
            
            guard let album = album else {
                return
            }
            
            albumLabel.text = album.album
            artistLabel.text = album.artist
            
            AlbumService().loadAlbumArt(url: album.thumbnailUrl, size: .thumb) { [weak self] image in
                DispatchQueue.main.async {
                    if let image = image {
                            self?.thumbnailImage.image = image
                    } else {
                        self?.thumbnailImage.image = nil
                    }
                }
            }
        }
    }
    
    // MARK: - UI Elements
    let thumbnailImage:UIImageView = {
        let thumbnailImage = UIImageView()
        thumbnailImage.contentMode = .scaleAspectFill
        thumbnailImage.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImage.layer.cornerRadius = 8
        thumbnailImage.clipsToBounds = true
       return thumbnailImage
    }()
    
    let containerView:UIView = {
      let view = UIView()
      view.translatesAutoresizingMaskIntoConstraints = false
      return view
    }()
    
    let artistLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.artistFont()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let albumLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.albumFont()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Setup Views and Constraints
extension AlbumCell {
    
    fileprivate func setupViews() {
        self.contentView.addSubview(thumbnailImage)
        self.contentView.addSubview(containerView)
        containerView.addSubview(albumLabel)
        containerView.addSubview(artistLabel)
    }
    
    fileprivate func setupConstraints() {
        let marginGuide = contentView.layoutMarginsGuide
        
        thumbnailImage.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 10).isActive = true
        thumbnailImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        thumbnailImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        thumbnailImage.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        
        containerView.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo:thumbnailImage.trailingAnchor, constant: 10).isActive = true
        containerView.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true

        albumLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        albumLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        albumLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        
        artistLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        artistLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        artistLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10).isActive = true
        artistLabel.topAnchor.constraint(equalTo: albumLabel.bottomAnchor, constant: 5).isActive = true
    }
}
