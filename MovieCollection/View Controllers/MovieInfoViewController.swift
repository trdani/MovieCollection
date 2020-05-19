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
    var moviesArray = [Movie]()
    
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
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // TODO: receive the movieToDisplay parameter and assign values
        print("Made it to the MovieInfo view controller")
        movieNameLabel.text = " "
        yearLabel.text = " "
        directorLabel.text = " "
        genreLabel.text = " "
    }
    
    // MARK: - Segue Functions

    // Prep for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // sends movies array to ViewController
        let dest1VC : ViewController = segue.destination as! ViewController
        dest1VC.moviesArray = self.moviesArray
    }
    
    @IBAction func doneViewingMovie(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func populateText (currentMovieToDisplay: Movie) {
        print("editing inner text for \(currentMovieToDisplay.name)")
        
        // have received the movie to display at this point
        movieToDisplay = currentMovieToDisplay
        
        // edit text
        movieNameLabel.text = movieToDisplay.name
        yearLabel.text = "\(String(describing: movieToDisplay.year))"
        directorLabel.text = movieToDisplay.director
        genreLabel.text = movieToDisplay.genre
    }
    
    
    

}
