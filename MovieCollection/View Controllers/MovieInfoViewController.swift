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
        
        print("Made it to the MovieInfo view controller")
        // have received movie, now will populate the screen with information
        populateText()
    }
    
    // MARK: - Segue Functions

    // Prep for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // sends movies array back to ViewController
        let dest1VC : ViewController = segue.destination as! ViewController
        dest1VC.moviesArray = self.moviesArray
    }
    
    @IBAction func doneViewingMovie(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func populateText () {
        print("editing inner text for \(movieToDisplay.name)")
        // edit text of display of movie
        movieNameLabel.text = movieToDisplay.name
        yearLabel.text = "\(String(describing: movieToDisplay.year))"
        directorLabel.text = movieToDisplay.director
        genreLabel.text = movieToDisplay.genre
    }
    
    
    

}
