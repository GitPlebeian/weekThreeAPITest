//
//  MovieController.swift
//  weekthreeAssesment
//
//  Created by Jackson Tubbs on 8/16/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import Foundation
import UIKit

class MovieController {
    
    static func fetchMovies(searchQuery: String, completion: @escaping ([Movie]?) -> Void) {
        
        // Cool URL for the search
        guard let baseURL = URL(string: "https://api.themoviedb.org/3/search/movie") else {completion(nil); return}
        
        // Initializes our urlComponents Object so we can add queries and stuff
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        
        // Initaializes all the queryies
        let includeAdultContentQuery = URLQueryItem(name: "include_adult", value: "false")
        let pageQuery = URLQueryItem(name: "page", value: "1")
        let apiKeyQuery = URLQueryItem(name: "api_key", value: "c17812157d6de4d9c61efdf69042bbce")
        let searchQuery = URLQueryItem(name: "query", value: searchQuery)
        
        // Adds the queries to our urlComponents
        urlComponents?.queryItems = [includeAdultContentQuery, pageQuery, apiKeyQuery, searchQuery]
        
        // Good Unwrapping
        guard let finalURL = urlComponents?.url else {completion(nil); return}
        
        // For us to make sure we are good programmers
        print(finalURL.absoluteString)
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            
            if let error = error {
                print("Error at \(#function):\nMain Error: \(error)\nShort Error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {completion(nil); return}
            
            do {
                let decoder = JSONDecoder()
                let fullData = try decoder.decode(MoviesData.self, from: data)
                let movies = fullData.results
                completion(movies)
            } catch {
                print("Error at \(#function):\nMain Error: \(error)\nShort Error: \(error.localizedDescription)")
                completion(nil)
                return
            }
        }.resume()
        
        //!!! Remove this !!!
        completion(nil)
        return
    }
    
    static func fetchMoviePoster(imageURL: String, completion: @escaping (UIImage?) -> Void) {
        
        guard let baseURL = URL(string: "http://image.tmdb.org/t/p/w500") else {completion(UIImage()); return}
        
        let finalURL = baseURL.appendingPathComponent(imageURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("Error at \(#function):\nMain Error: \(error)\nShort Error: \(error.localizedDescription)")
                completion(UIImage())
                return
            }
            
            guard let data = data else {completion(UIImage()); return}
            
            guard let poster = UIImage(data: data) else {completion(UIImage()); return}
            
            completion(poster)
        }.resume()
    }
}
