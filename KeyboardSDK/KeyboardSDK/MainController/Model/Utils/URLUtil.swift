//
//  URLUtil.swift
//  KeyboardSDK
//
//  Created by ximAir on 11/21/23.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
}

public class URLUtil: NSObject {
    
    class func customCallApi(url: String, method: HTTPMethod, parameters: [String: Any]?, token: String?, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let url = URL(string: url)!
        var request = URLRequest(url: url)
        
        request.httpMethod = method.rawValue
        
        if let token = token {
            request.setValue("\(token)", forHTTPHeaderField: "x-refresh-token")
        }
        
        if method == .GET, let parameters = parameters {
            var components = URLComponents()
            components.scheme = url.scheme
            components.host = url.host
            components.path = url.path
            
            var cs = CharacterSet.urlQueryAllowed
            cs.remove("+")
            cs.remove("/")
            cs.remove("=")
            
            components.percentEncodedQuery = parameters.map { key, value in
                var encodedValue = ""
                
                if let stringValue = value as? String {
                    encodedValue = stringValue.addingPercentEncoding(withAllowedCharacters: cs)!
                } else if let intValue = value as? Int {
                    encodedValue = "\(intValue)"
                }
                #if DEBUG
                    print("encodedValue: \(encodedValue)")
                #endif
                return "\(key.addingPercentEncoding(withAllowedCharacters: cs)!)=\(encodedValue)"
            }.joined(separator: "&")
            #if DEBUG
                print("api check : \(components.url?.absoluteString)")
            #endif
            request.url = components.url

        }
        
        if method == .POST, let parameters = parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
            request.setValue("application/json", forHTTPHeaderField: "Contetn-Type")
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

            completion(data, response, error)
        }
        
        task.resume()
    }
}
