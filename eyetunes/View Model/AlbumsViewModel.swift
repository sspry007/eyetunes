//
//  AlbumsViewModel.swift
//  eyetunes
//
//  Created by Steven Spry on 5/28/20.
//  Copyright © 2020 Steven Spry. All rights reserved.
//

import UIKit

class AlbumsViewModel {
    
    var albums:[Album] = []
    var service: AlbumServiceProtocol?
    
    init(isMocked:Bool = true) {
        self.service = AlbumService(isMocked: isMocked)
    }
    
    @objc func tapCancel(_ sender: UIBarButtonItem) {
        service?.cancelFetchAlbums()
    }

    func fetchAlbums(_ completion: @escaping ((Result<[Album], ErrorResult>) -> Void)) {
        
        guard let service = service else {
            completion(.failure(.service(string: "Missing service")))
            return
        }
        
        service.fetchAlbums { result in
                switch result {
                case .success(let data) :
                    
                    AlbumParser.parse(data: data) { result in
                        switch result {
                        case .success(let albums):
                            self.albums = albums
                            completion(.success(albums))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                case .failure(let error) :
                    completion(.failure(error))
                }
        }
    }
}
