//
//  ImageService.swift
//  eyetunes
//
//  Created by Steven Spry on 6/19/20.
//  Copyright © 2020 Steven Spry. All rights reserved.
//

import UIKit

typealias ImageServiceCompletionHandler = ((UIImage?) -> Void)

enum ImageStatus {
  case downloading, downloaded, failed
}

private class ImageState {
    let identifier: UUID = UUID()
    var status: ImageStatus = .downloading
    var completionHandlers:[ImageServiceCompletionHandler] = []
}

final class ImageService {
    
    static let shared: ImageService = {
        let instance = ImageService()

        instance.setup()
        return instance
    }()
    var delay:Int = 1
    
    private var images:[String:ImageState] = [:]
    private var downloadQueue = OperationQueue()
    
    func fetchImage(url:String,completion: @escaping ImageServiceCompletionHandler) {
        
        if let state = images[url] {
            // We know about this URL
            switch state.status {
            case .downloading:
                state.completionHandlers.append(completion)
            case .downloaded:
                completion(loadImageFromCache(state: state))
            case .failed:
                completion(nil)
            }
            
        } else {
            // We do not know about this URL
            let state = ImageState()
            state.completionHandlers.append(completion)
            images[url] = state
            
            let newOperation:Operation = BlockOperation(block: {
                self.imageFromURL(url: url) { (img) in
                    if let image = img {
                        if self.cacheImage(image: image, state: state) {
                            state.status = .downloaded
                        }
                    } else {
                        state.status = .failed
                    }
                    for completion in state.completionHandlers {
                        OperationQueue.main.addOperation({
                            completion(img)
                        })
                    }
                    state.completionHandlers = []
                }
            })
            
            if let last = downloadQueue.operations.last {
                newOperation.addDependency(last)
            }
            downloadQueue.addOperation(newOperation)
        }
    }
}

// MARK: - Private methods
extension ImageService {
    private func setup() {
        downloadQueue.maxConcurrentOperationCount = 1
        removeCache()
    }
}

// MARK: - Private network methods
extension ImageService {
    
    private func imageFromURL(url:String, completion: @escaping (UIImage?) -> ()) {
        
        if delay > 0 {
            sleep(UInt32(delay))
        }
        
        if let imageURL = URL(string: url) {
            let request = URLRequest(url: imageURL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30)
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    completion(UIImage())
                    return
                }
                completion(UIImage(data: data))
            }.resume()
        } else {
            completion(nil)
        }
    }
}

// MARK: - Private cache methods
extension ImageService {
    private func cacheImage(image:UIImage, state:ImageState ) -> Bool {
        
        let filePath = getCacheDirectory().appendingPathComponent(state.identifier.uuidString)
        do {
            if let data = image.jpegData(compressionQuality: 0.8) {
                try data.write(to: filePath)
                return true
            }
        } catch {
            print("Couldn't write file")
        }
        return false
    }
    
    private func loadImageFromCache(state: ImageState) -> UIImage? {
        let filePath = getCacheDirectory().appendingPathComponent(state.identifier.uuidString)
        
        do {
            let data = try Data(contentsOf:filePath)
            return try UIImage(data: data)
        } catch {
            print("Couldn't read file")
        }
        return nil
    }
    
    func removeCache() {
        let fileManager = FileManager.default
        do {
            let cacheDirectoryURL = try fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            print(cacheDirectoryURL)
            let fileURLs = try fileManager.contentsOfDirectory(at: cacheDirectoryURL, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
            for url in fileURLs {
               try fileManager.removeItem(at: url)
            }
        } catch {
            print(error)
        }
    }
    
    private func getCacheDirectory() -> URL {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}
