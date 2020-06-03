//
//  AlbumService.swift
//  eyetunes
//
//  Created by Steven Spry on 5/28/20.
//  Copyright © 2020 Steven Spry. All rights reserved.
//

import UIKit
import Foundation

typealias AlbumServiceCompletionHandler = ((Result<Data, ErrorResult>) -> Void)

private let endpoint = "https://rss.itunes.apple.com/api/v1/us/itunes-music/top-albums/all/100/non-explicit.json"

protocol AlbumServiceProtocol : class {
    func fetchAlbums(_ completion: @escaping AlbumServiceCompletionHandler)
    func cancelFetchAlbums()
}

enum AlbumArtSize {
    case thumb,full
}

final class AlbumService : AlbumServiceProtocol {
    
    var task : URLSessionTask?
    var isMocked: Bool
    var serviceURL:String = endpoint
    
    init(isMocked:Bool = true) {
        self.isMocked = isMocked
    }
    
    func cancelFetchAlbums() {
        if let task = task {
            task.cancel()
        }
        task = nil
    }
    
    func fetchAlbums(_ completion: @escaping AlbumServiceCompletionHandler) {
        if isMocked {
            fetchMockedAlbums(completion)
        } else {
            fetchRemoteAlbums(completion)
        }
    }
    
    fileprivate func fetchRemoteAlbums(_ completion: @escaping AlbumServiceCompletionHandler) {
        
        if let url = URL(string: serviceURL) {
            var request = URLRequest(url: url,cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 30)
            request.httpMethod = "GET"
            
            task = URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completion(.failure(.network(string: "An error occured during request :" + error.localizedDescription)))
                    return
                }
                
                if let data = data {
                    completion(.success(data))
                }
            }
            task?.resume()
        } else {
            completion(.failure(.network(string: "Invalid URL")))
        }
    }
    
    fileprivate func fetchMockedAlbums(_ completion: @escaping AlbumServiceCompletionHandler) {
        
        guard let data = FileManager.readJson(forResource: "Feed") else {
            completion(Result.failure(ErrorResult.custom(string: "No file or data")))
            return
        }
        completion(.success(data))
    }

    func loadAlbumArt(url: String, size:AlbumArtSize, completion: @escaping (UIImage?) -> ()) {
        
        if let baseURL = URL(string: url) {
            let imageURL = (size == .full) ? largeURL(baseURL) : baseURL
            let request = URLRequest(url: imageURL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30)
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else { return }
                completion(UIImage(data: data))
            }.resume()
        } else {
            completion(UIImage())
        }        
    }
    
    private func largeURL(_ url:URL) -> URL {
        let baseURL = url.deletingLastPathComponent()
        let largeURL = baseURL.appendingPathComponent(Strings.fromKey("AlbumLargeFilename"))
        return largeURL
    }
}

extension FileManager {
    static func readJson(forResource fileName: String ) -> Data? {
        
        if let fileURL = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: fileURL, options: .mappedIfSafe)
                return data
            } catch {
                // handle error
            }
        }
        return nil
    }
}
