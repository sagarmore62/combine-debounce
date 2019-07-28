//
//  TweetRepo.swift
//  Debounce-Demo
//
//  Created by Sagar More on 27/07/19.
//  Copyright © 2019 Sagar More. All rights reserved.
//

import Foundation
import STTwitter

struct TweetRepo {
   
    lazy private var api = STTwitterAPI(appOnlyWithConsumerKey: Constants.key, consumerSecret: Constants.secret)
    
    mutating func searchTweetFor(_ searchText : String, completionHandler : @escaping(_ :Data?, _: Error?)-> Void) {
        api?.getSearchTweets(withQuery: searchText, successBlock: { (data, res) in
            guard let res = res else {
                completionHandler(nil, nil)
                return
            }
            guard let jsonData = try? JSONSerialization.data(withJSONObject: res, options: .prettyPrinted) else {
                completionHandler(nil, nil)
                return
            }
           completionHandler(jsonData, nil)
            
        }, errorBlock: { (err) in
            completionHandler(nil, err)
        })
    }
    
    mutating func verifyCredentials(_ completionHandler : @escaping (_ : Bool)-> Void) {
        api?.verifyCredentials(userSuccessBlock: { (username, userId) in
           completionHandler(true)
        }, errorBlock: { (err) in
            completionHandler(false)
        })
    }
    
}
