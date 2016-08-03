//
//  NetworkManager.swift
//  QuantumDice
//
//  Created by Martin Walsh on 03/08/2016.
//  Copyright © 2016 Frosty Cube. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    
    /* Singleton */
    static let sharedInstance = NetworkManager()
    
    var manager: Manager!
    
    private init() {
        
        /*
         Create server trust policy for quantum domain.
         Turns out this was actually an issue in NSAppTransportSecurity and TLS 1.0.  However, leaving this in just in case and it's a good example to have anyway.
         */
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            Constants.quantumDomain : .DisableEvaluation
        ]
        
        /* Setup custom manager */
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        manager = Alamofire.Manager(configuration: configuration, serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
    }
    
    func requestJSON(URLString: URLStringConvertible,
                     parameters: [String: AnyObject]?) -> String? {
        /* Request URL, validate and return JSON */
 
        let result:String? = nil
        
        manager.request(.GET, URLString, parameters: parameters)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .Success:
                    print(response)
                case .Failure(let error):
                    print(error)
                }
        }
        
        return result
    }
}