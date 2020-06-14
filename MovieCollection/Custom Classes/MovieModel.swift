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

    // gets the movies from the database or data source and adds them to a movie array
    // INITIAL display of movies
    func getMoviesAtAppStart() {
        
        // go to data source and populate array with Movies
        var rawData = readDataFromCSV(fileName: "movieCSV", fileType: "csv")
        rawData = cleanRows(file: rawData!)
        moviesArray = csvIntoArray(data: rawData!)
        
        // initial sorting
        sortMoviesArray(movies: &moviesArray)
    }
    
    // MARK: Movie Model editing functions
    func addMovie (movie: Movie) {
        // if the movie does not exist yet, add it
        moviesArray += [movie]
        //sortMoviesArray(movies: &moviesArray)
        print("New movie added: \(movie.name)")
        
    }
    
    func removeMovie (movie: Movie) {
        indexToDelete = moviesArray.firstIndex(where: {$0.name == movie.name && $0.director == movie.director && $0.year == movie.year})!
        moviesArray.remove(at: indexToDelete)
        //sortMoviesArray(movies: &moviesArray)
    }
    
    func replaceMovie (movie: Movie, index: Int) {
        // writes over existing movie data based on edits on Add/Edit screen
        moviesArray[index] = movie
        //sortMoviesArray(movies: &moviesArray)
        print("Movie edited: \(movie.name)")
    }

    func updateMoviesArray () {
        // if this is the first time accessing the model (at app start)
        if accessCount == 1 {
            // populate initially with data from data source
            getMoviesAtAppStart()
            //sortMoviesArray(movies: &moviesArray)
        }
        // increment accessCount
        accessCount += 1
    }
    
    // MARK: Sort functions
    
    // sorts movies array (alphabetically by default)
    func sortMoviesArray (movies: inout [Movie], by type:String = "alpha") {
        // sort alphabetically
        movies = movies.sorted(by: {
            return ($0.name.localizedLowercase, $0.director.localizedLowercase) <
            ($1.name.localizedLowercase, $1.director.localizedLowercase)
        })
        //testing
        for movie in movies {
            print("Sorted: \(movie.name)")
        }
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
            let columns:[String]? = row.components(separatedBy: ",")
            // save into a Movie record
            let tempMovie = Movie()
            tempMovie.name = columns?[0] ?? "blank"
            tempMovie.year = Int(columns?[1] ?? "0")!
            tempMovie.director = columns?[2] ?? "blank"
            tempMovie.genre = columns?[3] ?? "blank"
            tempMovie.comments = columns?[4] ?? "blank"
            
            // testing
            print(tempMovie.name)
            
            //append to array
            addMovie(movie: tempMovie)
        }
    }
    
}
