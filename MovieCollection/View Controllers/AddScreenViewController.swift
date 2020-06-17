//
//  AddScreenViewController.swift
//  MovieCollection
//
//  Created by Trisha Dani on 5/18/20.
//  Copyright © 2020 Trisha Dani. All rights reserved.
//

import UIKit

class AddScreenViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    // stores movies array
    var model = MovieModel()
    var currentMovie = Movie()
    var existingMovieIndex:Int = -1
    
    // MARK: - TextView IBOutlets
    // TODO: make into TextView objects
    // text field outlets
    @IBOutlet weak var movieNameField: UITextView!
    
    @IBOutlet weak var yearField: UITextView!
    
    @IBOutlet weak var directorField: UITextView!
    
    @IBOutlet weak var genreField: UITextView!
    
    @IBOutlet weak var commentsField: UITextView!
    
    // MARK: - View did load and keyboard control
    // view load function
    override func viewDidLoad() {
        super.viewDidLoad()

        // set as delegate for all text boxes
        movieNameField.delegate = self
        yearField.delegate = self
        directorField.delegate = self
        genreField.delegate = self
        commentsField.delegate = self
        
        // add borders to the text boxes
        addBorders()
        setupExistingMovie()
        
        // allow tapping off the keyboard anywhere on the screen and removing the keyboard
        let tapRecogniser = UITapGestureRecognizer()
        tapRecogniser.addTarget(self, action: #selector(self.viewTapped))
        self.view.addGestureRecognizer(tapRecogniser)
        
    }
    
    // Keyboard closing upon tapping screen function
    @objc func viewTapped(){
       self.view.endEditing(true)
    }

    // MARK: - Segue Functions
    
    // outbound to save taken care of in unwind sequence
    
    // Outbound to ViewController WITHOUT saving a movie
    // cancel the addition of a movie to the movies array
    @IBAction func cancelMovie(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Delegate functions
    
    // sets which text field is active
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == movieNameField {
           textField.resignFirstResponder()
           yearField.becomeFirstResponder()
        } else if textField == yearField {
           textField.resignFirstResponder()
           directorField.becomeFirstResponder()
        } else if textField == directorField {
            textField.resignFirstResponder()
            genreField.becomeFirstResponder()
        } else if textField == genreField {
            textField.resignFirstResponder()
            commentsField.becomeFirstResponder()
        } else {
            commentsField.resignFirstResponder()
        }
        return true
    }
    
    // MARK: - Helper functions
    
    // add borders to the TextView objects on the screen
    func addBorders() {
        addIndivBorders(self.movieNameField)
        addIndivBorders(self.yearField)
        addIndivBorders(self.directorField)
        addIndivBorders(self.genreField)
        addIndivBorders(self.commentsField)
    }
    
    func addIndivBorders(_ textView: UITextView) {
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 3
    }
    
    // saves the movie that was just added to the moviesArray inside the MovieModel
    func saveMovieData() {
        
        // populate dummy movie object
        let tempMovie = Movie()
        tempMovie.name = movieNameField.text ?? "no movie entered"
        tempMovie.year = Int(yearField.text ?? "0") ?? 0
        tempMovie.director = directorField.text ?? "no director entered"
        tempMovie.genre = genreField.text ?? "no genre entered"
        tempMovie.comments = commentsField.text ?? "no comments"
        
        // replace movie record if it already exists and this is editing the record
        if existingMovieIndex != -1 {
            // attach the edited movie to the existing unique id
            tempMovie.unique_id = model.moviesArray[existingMovieIndex].unique_id
            model.replaceMovie(movie: tempMovie, index: existingMovieIndex)
            // reset value
            existingMovieIndex = -1
        }
        // otherwise, add a new movie
        else {
            // add movie to array of movies if it is the first time this record has been added
            model.addMovie(movie: tempMovie)
        }
        currentMovie = tempMovie
    }
    
    // populates text boxes if there is a movie to display that already exists
    func setupExistingMovie() {
        // if there is an existing movie to try and setup in the text fields,
        // then set it up
        if existingMovieIndex != -1 {
            movieNameField.text = model.moviesArray[existingMovieIndex].name
            yearField.text = String(model.moviesArray[existingMovieIndex].year)
            directorField.text = model.moviesArray[existingMovieIndex].director
            genreField.text = model.moviesArray[existingMovieIndex].genre
            commentsField.text = model.moviesArray[existingMovieIndex].comments
        }
    }
}
