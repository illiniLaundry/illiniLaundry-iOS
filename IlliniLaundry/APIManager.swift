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
import SWXMLHash

class APIManager {
    static let shared = APIManager()
    
    let operationQueue = OperationQueue()
    
    private let LAUNDRY_URL = "http://api.laundryview.com/room/?api_key=" + API_KEY
    private let DORM_IDS = ["589877048", "589877054", "589877017", "589877019","589877004", "589877022", "589877043", "589877003", "589877021", "589877044", "589877027", "589877026", "589877032", "589877030", "589877031", "589877038", "589877057", "589877037", "589877036", "589877040", "589877023", "589877046", "589877024", "589877008", "589877009", "589877052", "589877051", "589877015","589877002", "589877058", "589877061", "589877028"];
    
    private init() { }
    
    func getAllStatus(success: @escaping ((XMLIndexer) -> Void), failure: @escaping ((Error) -> Void)) {
        var url = "for loop through dorm ids"
        performRequest(url: url, method: .get, parameters: nil, success: success, failure: failure)
    }
    
    func getAllStatusSuccess(xml: XMLIndexer){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let privateContext = appDelegate.privateContext
        privateContext.perform {
            CoreDataHelpers.updateAll(xml: xml) { () -> () in
            }
        }

    }
    
    func getAllStatusError(error: Error) {
        print("get all status failed \(error.localizedDescription)")
    }
    
    
    private func performRequest(url: String, method: HTTPMethod, parameters: [String: Any]?, headers: [String: String]? = nil, success: @escaping ((XMLIndexer) -> Void), failure: @escaping ((Error) -> Void)) {
        Alamofire.request(url, method: method, parameters: parameters).response { response in
            if let error = response.error {
                failure(error)
            } else {
                let xml = SWXMLHash.parse(response.data!)
                success(xml)
            }
        }
    }
    /*
    func getSingleDormStatus(success: ((XMLIndexer) -> Void), failure: ((Error) -> Void)) {
        performRequest(method: .get, parameters: nil, success: success, failure: failure)
    }
    
    func getSingleDormStatusSuccess(xml: XMLIndexer) {
        CoreDataHelpers.updateSingleDorm(dormName: dormName, json: json) { () -> () in
        }
    }
    */
    
    // MARK: add supoort
    
    // make a function called getSingleDormStaus that looks //DONE
    // just like getAllStatus
    
    // make two functions getSingleDormStatusSuccess and ...Error
    // that look just like getAllStatusSuccess and ... Error
    // but it will call CoreDataHelpers.updateSingleDorm
    
    // make a function called updateSingleDorm in CoreDataHelpers
    
}
