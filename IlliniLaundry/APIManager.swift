//
//  APIManager.swift
//  IlliniLaundry
//
//  Created by Minhyuk Park on 24/02/2017.
//  Copyright © 2017 Minhyuk Park. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIManager {
    static let shared = APIManager()
    
    let operationQueue = OperationQueue()
    
    private let LAUNDRY_URL = "http://23.23.147.128/homes/mydata/urba7723"
    
    private init() { }
    
    func getAllStatus(success: ((JSON) -> Void)?, failure: ((Error) -> Void)?) {
        performRequest(method: .get, parameters: nil, success: success, failure: failure)
    }
    
    func getAllStatusSuccess(json: JSON){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let privateContext = appDelegate.privateContext
        privateContext.perform {
            CoreDataHelpers.updateAll(json: json) { () -> () in
            }
        }

    }
    
    func getAllStatusError(error: Error) {
        print("get all status failed \(error.localizedDescription)")
    }
    
    
    private func performRequest(method: HTTPMethod, parameters: [String: Any]?, headers: [String: String]? = nil, success: ((JSON) -> Void)?, failure: ((Error) -> Void)?) {
        let url = LAUNDRY_URL
        Alamofire.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (reponse) in
            
            if reponse.result.isSuccess {
                let json = JSON(reponse.result.value!)
                success?(json)
            }
            
            if reponse.result.isFailure {
                failure?(reponse.result.error!)
            }
        }
    }
    func getSingleDormStatus(success: ((JSON) -> Void)?, failure: ((Error) -> Void)?) {
        performRequest(method: .get, parameters: nil, success: success, failure: failure)
    }
    
    // make a function called getSingleDormStaus that looks //DONE
    // just like getAllStatus
    
    // make two functions getSingleDormStatusSuccess and ...Error
    // that look just like getAllStatusSuccess and ... Error
    // but it will call CoreDataHelpers.updateSingleDorm
    
    // make a function called updateSingleDorm in CoreDataHelpers
    
}
