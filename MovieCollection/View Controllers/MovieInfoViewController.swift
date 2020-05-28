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

    // Prep for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MovieDisplaySegue" {
            // sends movies array back to ViewController
            let dest1VC : ViewController = segue.destination as! ViewController
            dest1VC.model = self.model
        }
        else if segue.identifier == "EditSegue" {
            let dest1VC : EditViewController = segue.destination as! EditViewController
            dest1VC.model = self.model
        }
    }
    
    @IBAction func doneViewingMovie(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func populateText () {
        // edit text of display of movie
        movieNameLabel.text = movieToDisplay.name
        yearLabel.text = "\(String(describing: movieToDisplay.year))"
        directorLabel.text = movieToDisplay.director
        genreLabel.text = movieToDisplay.genre
        commentsLabel.text = movieToDisplay.comments
    }
    
    // MARK: - Inbound segue functions
    
    // save the movie record after editing
    @IBAction func unwindAfterEditingMovie(segue: UIStoryboardSegue) {
        let sourceVC : EditViewController = segue.source as! EditViewController
        self.model = sourceVC.model
    }
    
    // MARK: - Helper Functions
    
    // delete a record
    func deleteMovieData () {
        model.removeMovie(movie: self.movieToDisplay)
    }

}
