//
//  NetworkManager.swift
//  Movies
//
//  Created by Mark Rassamni on 7/2/19.
//

import Foundation
import Alamofire
import SwiftyJSON

public final class NetworkManager {
    
    // Singleton
    private init(){}
    public static let shared = NetworkManager()

    func getJSON(from url: String, completion: @escaping (_ json: JSON?, _ error: String?) -> ()) {
        let runLoop = CFRunLoopGetCurrent() // Run loop keeps app alive while waiting for request
        Alamofire.request(url).validate().responseJSON { response in
            switch response.result{
            case .failure(let error):
                completion(nil, error.localizedDescription)
            case .success(let value):
                completion(JSON(value), nil)
            }
            CFRunLoopStop(runLoop)
        }
        CFRunLoopRun()
    }
}
