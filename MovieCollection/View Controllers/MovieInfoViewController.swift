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
    
    // MARK: - Connection to labels on Movie Info Summary page
    
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
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // have received movie, now will populate the screen with information
        populateText()
    }
    
    // MARK: - Segue Functions

    // Prep for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // sends movies array back to ViewController
        let dest1VC : ViewController = segue.destination as! ViewController
        dest1VC.model = self.model
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

}
