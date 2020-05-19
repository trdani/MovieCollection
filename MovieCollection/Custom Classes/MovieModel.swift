//
//  MovieModel.swift
//  MovieCollection
//
//  Created by Trisha Dani on 5/18/20.
//  Copyright © 2020 Trisha Dani. All rights reserved.
//

import Foundation

class MovieModel  {
    
    // gets the movies from the database or data source and adds them to a movie array
    // INITIAL display of movies
    func getMovies() -> [Movie] {
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
            
            // add to array
            generatedMovies += [tempMovie]
            
            // testing
            print(tempMovie.name)
        }
    
        //return the array of Movies
        return generatedMovies
    }
    
}
