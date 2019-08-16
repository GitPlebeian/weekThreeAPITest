//
//  TableViewController.swift
//  weekthreeAssesment
//
//  Created by Jackson Tubbs on 8/16/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var movieSearchBar: UISearchBar!
    
    // MARK: - Properties
    
    var movies: [Movie] = []
    var posters: [UIImage] = []
    var postersCount: Int = 0
    
    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieTableViewCell else {return UITableViewCell()}
        
        let movie = movies[indexPath.row]

        cell.movieTitleLabel.text = movie.title
        cell.movieRatingLabel.text = String(movie.voteAverage)
        cell.movieSummaryLabel.text = movie.overview
        guard let indexOfPoster = movie.indexOfPost else {return cell}
        cell.moviePostImageView.image = posters[indexOfPoster]
        return cell
    }
}

extension MainTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // Reseting for new movies
        postersCount = 0
        posters = []
        searchBar.resignFirstResponder()
        
        // Get search query
        guard let searchQuery = searchBar.text, searchQuery.isEmpty == false else {return}
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // Fetch for an array of movies
        MovieController.fetchMovies(searchQuery: searchQuery) { (movies) in
            
            guard let movies = movies else {return}
            
            // Loops through movies to get the poster for the movie
            for movie in movies {
                // Makes sure that there is a poster for the movie
                if let moviePosterURL = movie.posterPath {
                    // Fetfhes for a poster
                    MovieController.fetchMoviePoster(imageURL: moviePosterURL, completion: { (poster) in
                        guard let poster = poster else {return}
                        print(poster.description)
                        DispatchQueue.main.async {
                            // Appends to the poster to the poster array
                            self.posters.append(poster)
                            self.postersCount += 1
                            if self.postersCount == movies.count {
                                self.tableView.reloadData()
                            }
                        }
                    })
                // If there is not poster for the movie then the no poster will be added to the poster array
                } else {
                    self.postersCount += 1
                    if self.postersCount == movies.count {
                        self.tableView.reloadData()
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.movies = movies
                
                // Assigns the correct poster to the movie and doesn't assign any poster to movies with out a poster
                var index = 0
                var indexOfPoster = 0
                for movieToAssign in self.movies {
                    if let poster = movieToAssign.posterPath {
                        self.movies[index].indexOfPost = indexOfPoster
                        indexOfPoster += 1
                    }
                    index += 1
                }
            }
        }
    }
}
