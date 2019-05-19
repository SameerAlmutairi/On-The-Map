//
//  UdacityClient.swift
//  On The Map
//
//  Created by Sameer Almutairi on 16/05/2019.
//  Copyright © 2019 Sameer Almutairi. All rights reserved.
//

import Foundation

class UdacityClient {
    
    struct Auth {
        static var accountKey = ""
        static var sessionId = ""
    }
    enum Endpoints {
        static let base =  "https://onthemap-api.udacity.com/v1"
        
        // cases
        case getSession
        case getUser(String)
        
        
        var stringValues: String {
            switch self {
            case .getSession:
                return Endpoints.base + "/session"
            case .getUser(let user):
                return Endpoints.base + "/users" + user
            }
        }
        
        var url: URL {
            return URL(string: stringValues)!
        }
    }
    
    class func taskForPostRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping(ResponseType?, Error?) -> Void){
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            do {
                print(data.count)
                let range = 5..<data.count
                let newData = data.subdata(in: range)
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    class func login(udacity: Udacity, completion: @escaping (UdacityPostSession?, Error?) -> Void) {
        print(udacity)
        taskForPostRequest(url: Endpoints.getSession.url, responseType: UdacityPostSession.self, body: udacity) { (response, error) in
            
            if let response = response {
                completion(response, nil)
            }
            else {
                completion(nil, error)
            }
        }
    }
    
    class func deleteSession(completion: @escaping (Data?, Error?) -> Void){
        var request = URLRequest(url: Endpoints.getSession.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
            DispatchQueue.main.async {
                completion(data, nil)
            }
        }
        task.resume()
    }
}
