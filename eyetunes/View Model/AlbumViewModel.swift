//
//  AlbumViewModel.swift
//  eyetunes
//
//  Created by Steven Spry on 5/29/20.
//  Copyright © 2020 Steven Spry. All rights reserved.
//

import UIKit

class AlbumViewModel {
    
    var album : Album?
    
    @objc func openStore(_ sender: Any) {
        
        guard let appStoreLink = self.album?.url else { return }

        if let url = URL(string: appStoreLink),
            UIApplication.shared.canOpenURL(url)
        {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
