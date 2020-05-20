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
    var moviesArray = [Movie]()
    
    // text field outlets
    @IBOutlet weak var movieNameField: UITextField!
    
    @IBOutlet weak var yearField: UITextField!
    
    @IBOutlet weak var directorField: UITextField!
    
    // TODO: make genre an optional scroll field
    @IBOutlet weak var genreField: UITextField!
    
    @IBOutlet weak var commentsField: UITextView!
    

    // view load function
    override func viewDidLoad() {
        super.viewDidLoad()

        // set as delegate for all text boxes
        movieNameField.delegate = self
        yearField.delegate = self
        directorField.delegate = self
        genreField.delegate = self
        commentsField.delegate = self
        
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

    // prep for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // sends movies array to ViewController
        let dest1VC : ViewController = segue.destination as! ViewController
        dest1VC.moviesArray = self.moviesArray
    }
    
    // sends back to ViewController WITHOUT saving a movie
    // cancel the addition of a movie to the movies array
    @IBAction func cancelMovie(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Save user data and dismiss popup function

    // sends back to ViewController WITH SAVED MOVIE
    @IBAction func saveMovie(_ sender: Any) {
        // TODO: save movie by accessing data source in MovieModel
        saveMovieData()
        // dismiss
        dismiss(animated: true, completion: nil)
    }
    
    func saveMovieData() {
        
        // populate dummy movie object
        let tempMovie = Movie()
        tempMovie.name = movieNameField.text ?? "no movie entered"
        tempMovie.year = Int(yearField.text ?? "0") ?? 0
        tempMovie.director = directorField.text ?? "no director entered"
        tempMovie.genre = genreField.text ?? "no genre entered"
        tempMovie.comments = commentsField.text ?? "no comments"
        
        // add movie to array of movies
        moviesArray += [tempMovie]
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
    

}
