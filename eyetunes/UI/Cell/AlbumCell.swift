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
            
            guard let album = album else { return }
            
            albumLabel.text = album.album
            artistLabel.text = album.artist
            thumbnailImage.image = nil
            
            ImageService.shared.fetchImage(url: album.thumbnailUrl) { [weak self] (image) in
                if let image = image {
                    self?.thumbnailImage.image = image
                } else {
                    self?.thumbnailImage.image = nil
                }
            }
        }
    }
    
    // MARK: - UI Elements
    @IBOutlet weak var thumbnailImage:UIImageView!
    @IBOutlet weak var containerView:UIView!
    @IBOutlet weak var artistLabel:UILabel!
    @IBOutlet weak var albumLabel:UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
}

// MARK: - Setup Views and Constraints
extension AlbumCell {
    
    fileprivate func setupViews() {
        thumbnailImage.layer.cornerRadius = 8
        thumbnailImage.clipsToBounds = true
        artistLabel.font = UIFont.artistFont()
        albumLabel.font = UIFont.albumFont()
    }
}
