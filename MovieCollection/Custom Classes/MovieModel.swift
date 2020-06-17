//
//  MovieModel.swift
//  MovieCollection
//
//  Created by Trisha Dani on 5/18/20.
//  Copyright © 2020 Trisha Dani. All rights reserved.
//
import Foundation
import SQLite

class MovieModel  {
    // store all movies in this array
    var moviesArray = [Movie]()
    
    // tracks number of times the model has been accessed
    var accessCount = 1
    
    // stores the index of the thing you're trying to delete at a certain time
    var indexToDelete = 0
    
    // database items
    var database:Connection!
    let moviesTable = Table("movies")
    let uniqueIdCol = Expression<String>("unique_id")
    let nameCol = Expression<String>("name")
    let yearCol = Expression<Int>("year")
    let directorCol = Expression<String>("director")
    let genreCol = Expression<String>("genre")
    let commentsCol = Expression<String>("comments")
    
    
    // gets the movies from the database or data source and adds them to a movie array
    // INITIAL display of movies
    func getMoviesAtAppStart() {
        
        // go to data source (currently a file within scope) and populate array with Movies
        var rawData = readDataFromCSV(fileName: "movieCSV", fileType: "csv")
        rawData = cleanRows(file: rawData!)
        moviesArray = csvIntoArrayAndDB(data: rawData!)
        
        // initial sorting
        sortMoviesArray(movies: &moviesArray)
    }
    
    // MARK: Database setup functions
    
    // call in viewDidLoad
    func loadDatabase () {
        // create a file if it does not exist with movies.sqlite3 name and extension
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            // create file URL for database
            let fileUrl = documentDirectory.appendingPathComponent("movies4").appendingPathExtension("sqlite3")
            // connect database to the file URL within the directory
            let database = try Connection(fileUrl.path)
            self.database = database
            
        } catch {
            print(error)
        }
        
        // create table
        let createTable = self.moviesTable.create { (table) in
            table.column(self.uniqueIdCol)
            table.column(self.nameCol)
            table.column(self.yearCol)
            table.column(self.directorCol)
            table.column(self.genreCol)
            table.column(self.commentsCol)
        }
        
        do {
            try self.database.run(createTable)
            print("Created table")
            updateMoviesArray()
        } catch {
            // this means db already existed
            print(error)
            // populate movies array from db
            migrateDBIntoArray()
        }
    }
    
    func migrateDBIntoArray () {
        do {
            let movies = try self.database.prepare(self.moviesTable)
            for movie in movies {
                let tempMovie = Movie()
                tempMovie.unique_id = movie[self.uniqueIdCol]
                tempMovie.name = movie[self.nameCol]
                tempMovie.year = movie[self.yearCol]
                tempMovie.director = movie[self.directorCol]
                tempMovie.genre = movie[self.genreCol]
                tempMovie.comments = movie[self.commentsCol]
                
                moviesArray += [tempMovie]
            }
        } catch {
            print(error)
        }
        sortMoviesArray(movies: &moviesArray)
        printContentsOfDB()
    }
    
    // MARK: - Database Editing Functions
    
    func insertMovieIntoDB (movie:Movie) {
        let insertMovie = self.moviesTable.insert(self.uniqueIdCol <- movie.unique_id, self.nameCol <- movie.name, self.yearCol <- movie.year, self.directorCol <- movie.director, self.genreCol <- movie.genre, self.commentsCol <- movie.comments)
        
        do {
            try self.database.run(insertMovie)
            print("Inserted movie: \(movie.name)")
        } catch {
            print(error)
        }
    }
    
    func updateMovieInDB (movie:Movie) {
        let movieToUpdate = moviesTable.filter(self.uniqueIdCol == movie.unique_id)
        do {
            // debugging
            //let row = try database.pluck(movieToUpdate)
            // print("Updating \(row![self.nameCol])")
            
            try self.database.run(movieToUpdate.update(
                [self.nameCol <- movie.name,
                 self.yearCol <- movie.year,
                 self.directorCol <- movie.director,
                 self.genreCol <- movie.genre,
                 self.commentsCol <- movie.comments]))
            print("Movie updated: \(movie.name)")
        } catch {
            print(error)
        }
        printContentsOfDB()
    }
    
    func deleteMovieFromDB (movie:Movie) {
        let movieToDelete = self.moviesTable.filter(self.uniqueIdCol == movie.unique_id)
        
        let deleteMovie = movieToDelete.delete()
        
        do {
            try self.database.run(deleteMovie)
            print("Deleted movie: \(movie.name)")
        } catch {
            print(error)
        }
        printContentsOfDB()
        
    }
    
    // for testing purposes
    func printContentsOfDB () {
        print("Database Contents:")
        do {
            let movies = try self.database.prepare(self.moviesTable)
            for movie in movies {
                print("Unique ID: \(movie[self.uniqueIdCol]), Movie name: \(movie[self.nameCol]), year: \(movie[self.yearCol])")
            }
        } catch {
            print(error)
        }
    }
    
    // MARK: - Movie Model editing functions
    
    func addMovie (movie: Movie) {
        // if the movie does not exist yet, add it
        movie.unique_id = UUID().uuidString
        moviesArray += [movie]
        // add to DB
        insertMovieIntoDB(movie: movie)
    }
    
    func removeMovie (movie: Movie) {
        indexToDelete = moviesArray.firstIndex(where: {$0.unique_id == movie.unique_id})!
        moviesArray.remove(at: indexToDelete)
        // remove from DB
        deleteMovieFromDB(movie: movie)
    }
    
    func replaceMovie (movie: Movie, index: Int) {
        // writes over existing movie data based on edits on Add/Edit screen
        moviesArray[index] = movie
        // update in DB
        updateMovieInDB(movie: movie)
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
    
    // MARK: - Sort functions
    
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
    
    // separates rows into Movie records for array and DB
    func csvIntoArrayAndDB(data: String) -> [Movie] {
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
            tempMovie.unique_id = UUID().uuidString
            
            //append to array
            
            generatedMoviesArray += [tempMovie]
            //add to db
            insertMovieIntoDB(movie: tempMovie)
        }
        //test if DB was populated
        printContentsOfDB()
        return generatedMoviesArray
    }
    
}
