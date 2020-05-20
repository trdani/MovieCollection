//
//  MovieModel.swift
//  MovieCollection
//
//  Created by Trisha Dani on 5/18/20.
//  Copyright © 2020 Trisha Dani. All rights reserved.
//

import Foundation

class MovieModel  {
    // store all movies in this array
    var moviesArray = [Movie]()
    
    // tracks number of times the model has been accessed
    var accessCount = 1
    
    // gets the movies from the database or data source and adds them to a movie array
    // INITIAL display of movies
    func getMoviesAtAppStart() -> [Movie] {
        // declare an empty dictionary to store all movies
        var generatedMovies = [Movie]()
        
        // TODO: go to data source and populate array with Movies
        // for now: manually enter some movies to display
        for i in 1...8 {
            // create a temp movie to append to the array
            let tempMovie = Movie()
            // set all temp values
            tempMovie.name = "movie\(i)"
            tempMovie.year = 2000 + i
            tempMovie.director = "director name to test width behavior \(i)"
            tempMovie.genre = "genre\(i)"
            tempMovie.comments = "comments pertaining to the movie and other information"
            
            // add to array
            generatedMovies += [tempMovie]
            
            // testing
            print(tempMovie.name)
        }
    
        //return the array of Movies
        return generatedMovies
    }
    
    func addMovie (movie: Movie) {
        moviesArray += [movie]
        print("New movie added")
    }
    
    func updateMoviesArray () {
        // if this is the first time accessing the model (at app start)
        if accessCount == 1 {
            // populate initially with data from data source
            moviesArray = getMoviesAtAppStart()
        }
        // increment accessCount
        accessCount += 1
    }
    
}
