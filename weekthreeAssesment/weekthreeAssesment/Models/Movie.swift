//
//  Movie.swift
//  weekthreeAssesment
//
//  Created by Jackson Tubbs on 8/16/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import Foundation

struct Movie: Codable {
    
    let title: String
    let voteAverage: Double
    let overview: String
    let posterPath: String?
    var indexOfPost: Int?
    
    private enum CodingKeys: String, CodingKey {
        
        case title
        case voteAverage = "vote_average"
        case overview
        case posterPath = "poster_path"
        case indexOfPost
    }
}
