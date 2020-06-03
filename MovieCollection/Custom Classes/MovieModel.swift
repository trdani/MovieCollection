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
    
    // stores the index of the thing you're trying to delete at a certain time
    var indexToDelete = 0
    
    // gets the movies from the database or data source and adds them to a movie array
    // INITIAL display of movies
    func getMoviesAtAppStart() {
        
        // go to data source and populate array with Movies
        var rawData = readDataFromCSV(fileName: "movieCSV", fileType: "csv")
        rawData = cleanRows(file: rawData!)
        moviesArray = csvIntoArray(data: rawData!)

    }
    
    // MARK: Movie Model editing functions
    
    func addMovie (movie: Movie) {
        // if the movie does not exist yet, add it
        moviesArray += [movie]
        print("New movie added")
        
    }
    
    func removeMovie (movie: Movie) {
        indexToDelete = moviesArray.firstIndex(where: {$0.name == movie.name && $0.director == movie.director})!
        moviesArray.remove(at: indexToDelete)
    }
    
    func replaceMovie (movie: Movie, index: Int) {
        // writes over existing movie data based on edits on Add/Edit screen
        moviesArray[index] = movie
        print("Movie edited")
    }
    
    func updateMoviesArray () {
        // if this is the first time accessing the model (at app start)
        if accessCount == 1 {
            // populate initially with data from data source
            getMoviesAtAppStart()
        }
        // increment accessCount
        accessCount += 1
    }
    
    // MARK: Sort functions
    
    // sorts movies array alphabetically by default
    func sortMoviesArray (by type:String = "alpha") {
        if type == "alpha" {
            moviesArray = moviesArray.sorted(by: { $0.name < $1.name })
        }
        
    }

    // MARK: - File reading helper functions
    
    // reads in raw data
    func readDataFromCSV(fileName:String, fileType: String)-> String!{
        guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
            else {
                return nil
        }
        do {
            var contents = try String(contentsOfFile: filepath, encoding: .utf8)
            contents = cleanRows(file: contents)
            //contents = cleanRows(file: contents)
            return contents
        } catch {
            print("File Read Error for file \(filepath)")
            return nil
        }
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
    func csvIntoArray(data: String) -> [Movie] {
        let rows = data.components(separatedBy: "\n")
        var generatedMoviesArray = [Movie]()
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
            //print(tempMovie.name)
            
            //append to array
            generatedMoviesArray += [tempMovie]
        }
        return generatedMoviesArray
    }
    
}
