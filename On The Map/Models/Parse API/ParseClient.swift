//
//  ParseClient.swift
//  On The Map
//
//  Created by Sameer Almutairi on 17/05/2019.
//  Copyright © 2019 Sameer Almutairi. All rights reserved.
//

import Foundation

class ParseClient{
    static let appID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    static let apiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
    enum EndPoints {
        static let base = "https://parse.udacity.com/parse/classes"
        
        case getAllStudentLocation
        case getStudnetLocation
     
        var stringValues: String {
            switch self {
            case .getAllStudentLocation:
                return EndPoints.base + "/StudentLocation?limit=200&skip=0&order=-updatedAt"
//                limit = 100, skip = 0
            case .getStudnetLocation:
                return EndPoints.base + "/StudentLocation"
            }
        }
        
        var url: URL {
            return URL(string: stringValues)!
        }
    }
    
    
    class func getAllStudentLocation(completion: @escaping ([StudentLocation]?, Error?) -> Void){
        taskForGETRequest(url: EndPoints.getAllStudentLocation.url, responseType: StudentLocationResult.self) { (respose, error) in
            if let response = respose {
                completion(response.results, nil)
            }
            else {
                completion(nil, error)
            }
        }
    }
    
    class func postStudnetLocation(student: StudentLocationRequest, completion: @escaping (StudentLocationPost?, Error?) -> Void) {
        taskForPostRequest(url: EndPoints.getStudnetLocation.url, responseType: StudentLocationPost.self, body: student) { (response, error) in
            if let response = response  {
                DispatchQueue.main.async {
                    print("++++++ Start student ++++++")
                    print(student)
                    print("++++++ End student ++++++")
                    completion(response, nil)
                }
            }
            else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
            
            
        }
//        print(student)
    }
    
    
    class func taskForPostRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping(ResponseType?, Error?) -> Void){
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(appID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
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
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask{
        var request = URLRequest(url: url)
        request.addValue(appID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            do {
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
        return task
    }
}


