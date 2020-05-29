//
//  MovieInfoViewController.swift
//  MovieCollection
//
//  Created by Trisha Dani on 5/18/20.
//  Copyright © 2020 Trisha Dani. All rights reserved.
//

import UIKit

class MovieInfoViewController: UIViewController {

    // store movies array
    var model = MovieModel()
    
    // store the movie you're currently displaying
    var movieToDisplay = Movie()
    
    // MARK: - Label IBOutlets
    
    // movie name connection
    @IBOutlet weak var movieNameLabel: UILabel!
    // year connection
    @IBOutlet weak var yearLabel: UILabel!
    // director connection
    @IBOutlet weak var directorLabel: UILabel!
    // genre label
    @IBOutlet weak var genreLabel: UILabel!
    // comments label
    @IBOutlet weak var commentsLabel: UILabel!
    
    // MARK: - View did load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // have received movie, now will populate the screen with information
        populateText()
    }
    
    // MARK: - Outgoing Segue Functions

    // Prep for segue to main ViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MovieDisplaySegue" {
            // sends movies array back to ViewController
            let dest1VC : ViewController = segue.destination as! ViewController
            dest1VC.model = self.model
        }
        // send to add/edit movie location
        else if segue.identifier == "EditMovieSegue" {
            let dest1VC : AddScreenViewController = segue.destination as! AddScreenViewController
            dest1VC.model = self.model
            // send the location of the movie to edit within the model
            dest1VC.existingMovieIndex = model.moviesArray.firstIndex(where: {$0.name == movieToDisplay.name && $0.director == movieToDisplay.director})!
        }
    }
    
    @IBAction func doneViewingMovie(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helper Functions
    
    func populateText () {
        // edit text of display of movie
        movieNameLabel.text = movieToDisplay.name
        yearLabel.text = "\(String(describing: movieToDisplay.year))"
        directorLabel.text = movieToDisplay.director
        genreLabel.text = movieToDisplay.genre
        commentsLabel.text = movieToDisplay.comments
    }
    
    // delete a record
    func deleteMovieData () {
        model.removeMovie(movie: self.movieToDisplay)
    }

}
