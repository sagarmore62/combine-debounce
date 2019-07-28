//
//  TweetVM.swift
//  Debounce-Demo
//
//  Created by Sagar More on 27/07/19.
//  Copyright © 2019 Sagar More. All rights reserved.
//

import Foundation

protocol TweetVMDelegate : class {
    func reloadUI()
}

class TweetVM  {
    weak var delegate : TweetVMDelegate?
    private var repo : TweetRepo
    private var list = [Tweet]() {
        didSet {
            DispatchQueue.main.async {
                self.delegate?.reloadUI()
            }
        }
    }
    
    init() {
        repo = TweetRepo()
        repo.verifyCredentials { [weak self](result) in
            if result {
                self?.searchTweetFor("technology") //get default search result
            } else {
                print("authentication failed.")
            }
        }
    }
}

// MARK: - Tableview data methods
extension TweetVM {
    func getNumberOfRows() -> Int {
        return list.count
    }
    
    func getDataForRowAt(_ index : Int) -> Tweet {
        return list[index]
    }
}

// MARK: - Networking methods
extension TweetVM {
    func searchTweetFor(_ searchText : String) {
        repo.searchTweetFor(searchText) { [weak self] (data, error) in
            guard let unwrappedData = data else {
                print(error)
                return
            }
            unwrappedData.getJsonModel(modelType: [Tweet].self) { (model, error) in
                if let unwrappedModel = model {
                    self?.list = unwrappedModel
                }
            }
        }
    }
    
}
