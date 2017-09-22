//
//  YelpClient.swift
//  Yelp
//
//  Created by Timothy Lee on 9/19/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

import AFNetworking
import BDBOAuth1Manager

// You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
let yelpConsumerKey = "vxKwwcR_NMQ7WaEiQBK_CA"
let yelpConsumerSecret = "33QCvh5bIF5jIHR5klQr7RtBDhQ"
let yelpToken = "uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV"
let yelpTokenSecret = "mqtKIxMIR4iBtBPZCmCLEb-Dz3Y"

class YelpClient: BDBOAuth1RequestOperationManager {
    var accessToken: String!
    var accessSecret: String!
    
    //MARK: Shared Instance
    
    static let sharedInstance = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
        self.accessToken = accessToken
        self.accessSecret = accessSecret
        let baseUrl = URL(string: "https://api.yelp.com/v2/")
        super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);
        
        let token = BDBOAuth1Credential(token: accessToken, secret: accessSecret, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
    }

    func searchWithTerm(_ term: String, filterModel: FiltersViewModel, offset: Int?, limit: Int?, completion: @escaping ([Business]?, Int?, Error?) -> Void) -> AFHTTPRequestOperation {
        var parameters: [String : AnyObject] = ["term": term as AnyObject, "ll": "37.785771,-122.406165" as AnyObject]

        for model in filterModel.items {
            if let value = model.yelpAPIValue() {
                parameters[model.yelpAPIKey] = value
            }
        }
        if offset != nil {
            parameters["offset"] = offset! as AnyObject
        }
        if limit != nil {
            parameters["limit"] = limit! as AnyObject
        }

//        print("Searching with \(parameters)")
        return self.get("search", parameters: parameters,
                        success: { (operation: AFHTTPRequestOperation, response: Any) -> Void in
                            if let response = response as? [String: Any]{
//                                print("RESPONSE: \(response)")
                                let dictionaries = response["businesses"] as? [NSDictionary]
                                let total_results = response["total"] as? Int
                                if dictionaries != nil {
                                    completion(Business.businesses(array: dictionaries!), total_results, nil)
                                }
                            }
        },
                        failure: { (operation: AFHTTPRequestOperation?, error: Error) -> Void in
                            completion(nil, 0, error)
        })!

    }

    func detailsForBusiness(id: String, completion: @escaping ([String:Any]?, Error?) -> Void) -> AFHTTPRequestOperation {
        let escapedId = id.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        return self.get("business/" + escapedId!, parameters:  nil,
                        success: { (operation: AFHTTPRequestOperation, response: Any) -> Void in
                            if let response = response as? [String: Any] {
//                                print("RESPONSE: \(response)")
                                completion(response, nil)
                            }
        },
                        failure: { (operation: AFHTTPRequestOperation?, error: Error?) -> Void in
                            completion(nil, error)
        })!
    }
}
