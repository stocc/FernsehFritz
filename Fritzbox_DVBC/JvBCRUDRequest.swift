//
//  JvBCRUDRequest.swift
//  CRUD
//
//  Created by Justus von Brandt on 16.11.15.
//  Copyright © 2015 Justus von Brandt. All rights reserved.
//

import Foundation

enum JvBCRUDRequestType: String {
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case GET = "GET"
}

class JvBCRUDRequest: NSObject {
    
    class func request(type: JvBCRUDRequestType, urlString: String, queryParameters: NSDictionary?, dataDictionary: NSDictionary? , headers: NSDictionary?, completion: @escaping (_ error: Error?, _ data: String?, _ response: URLResponse?)->()) {
        let components = NSURLComponents(string: urlString)
        var items: [NSURLQueryItem] = []
        if let params = queryParameters {
            for (key,obj) in params {
                items.append(NSURLQueryItem(name: key as! String, value: obj as? String))
            }
            components?.queryItems = items as [URLQueryItem]?
        }
        
        let url = components?.url!
        //print(url)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = type.rawValue
        //request.addValue("application/json", forHTTPHeaderField: "Accept")
        if let h = headers {
            for (key, header) in h as! Dictionary<String,String> {
                request.addValue(header, forHTTPHeaderField: key)
            }
        }
        if let dict = dataDictionary {
            var data: NSData
            do {
                try data = JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
                request.httpBody = data as Data
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                completion(nil, nil, nil)
            }
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error0) -> Void in
            DispatchQueue.main.async(execute: {
                if error0 == nil {
                    completion(nil,NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as String?, response)
                } else {
                    completion(nil, nil, response)
                }
            })
        })
        dataTask.resume()
    }
}
