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
    var rawData:String? = String()
    
    // stores the index of the thing you're trying to delete at a certain time
    var indexToDelete = 0
    
    func addMovie (movie: Movie) {
        moviesArray += [movie]
        print("New movie added")
    }
    
    func removeMovie (movie: Movie) {
        indexToDelete = moviesArray.firstIndex(where: {$0.name == movie.name})!
        moviesArray.remove(at: indexToDelete)
    }
    
    
    // MARK: - File reading helper functions
    
    // called from view controller when the view loads
    // gets the movies from a file and adds them to a movie array
    // INITIAL display of movies
    func getMoviesFromFile() {
        // go to data source and populate array with Movies
        rawData = cleanRows(file: rawData!)
        // transforms raw data into the moviesArray that we want
        csvIntoArray()
    }
    
    // clean up data
    func cleanRows(file:String)->String{
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        //        cleanFile = cleanFile.replacingOccurrences(of: ";;", with: "")
        //        cleanFile = cleanFile.replacingOccurrences(of: ";\n", with: "")
        return cleanFile
    }
    
    // separates rows into Movie records
    // uses raw data to
    func csvIntoArray() {
        let rows = rawData!.components(separatedBy: "\n")
        for row in rows {
            // skip last row (== null)
            if row == "" {
                break;
            }
            // separate each row into different sections to parse
            let columns = row.components(separatedBy: ",")
            // save into a Movie record
            let tempMovie = Movie()
            tempMovie.name = columns[0]
            tempMovie.year = Int(columns[1])!
            tempMovie.director = columns[2]
            tempMovie.genre = columns[3]
            tempMovie.comments = columns[4]
            
            // testing
            print(tempMovie.name)
            
            //append to array
            addMovie(movie: tempMovie)
        }
    }
    
}
