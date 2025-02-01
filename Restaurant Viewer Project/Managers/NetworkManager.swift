//
//  NetworkManager.swift
//  Restaurant Viewer Project
//
//  Created by Chris W on 1/31/25.
//

import UIKit

class NetworkManager{
    static let shared = NetworkManager()
    private init() { }
    
    let apiEndpoint = "https://api.yelp.com/v3/businesses/search"
    let apiKey = "itoMaM6DJBtqD54BHSZQY9WdWR5xI_CnpZdxa3SG5i7N0M37VK1HklDDF4ifYh8SI-P2kI_mRj5KRSF4_FhTUAkEw322L8L8RY6bF1UB8jFx3TOR0-wW6Tk0KftNXXYx"
    
    func fetchRestaurantsAtLocation(lat: Double, long: Double,
                                    completed: @escaping (Result<YelpResponse, NetworkError>) -> Void) {
        //Make sure the url was successfully created before continuing
        let endpoint = "\(apiEndpoint)?term=restaurants&latitude=\(lat)&longitude=\(long)&limit=3"
        guard let endpointURL = URL(string: endpoint) else {
            completed(.failure(.unableToComplete))
            return
        }
        
        //Set request header with api key
        var request = URLRequest(url: endpointURL)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        //Set the network task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            //If response if valid and http status code == OK, continue
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            //Make sure data received is valid
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                //Decode JSON response
                let decoder = JSONDecoder()
                let response = try decoder.decode(YelpResponse.self, from: data)
                completed(.success(response))
            }catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume() //start the task
    }
    
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void){
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Image download error: \(error)")
                completion(nil)
                return
            }
            
            //create the image
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
        }
        task.resume()
    }
}

