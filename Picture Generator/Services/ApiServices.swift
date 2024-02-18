//
//  ApiServices.swift
//  Picture Generator
//
//  Created by Sultan Rifaldy on 06/02/24.
//

import Foundation
import Alamofire

class ApiServices {
    static let shared: ApiServices = ApiServices()
    private init() {}
    private let API = "https://api.imgflip.com/get_memes"
    
    func loadMemes(completion: @escaping (Result<[Memes], Error>)-> Void) {
        let urlString = API
        AF.request(urlString, method: HTTPMethod.get)
            .validate()
            .responseDecodable(of: Data.self) { response in
                switch response.result {
                case .success(let success):
                    completion(.success(success.data.memes))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}

    

