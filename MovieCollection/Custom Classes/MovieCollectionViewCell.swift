//
//  MovieCollectionViewCell.swift
//  MovieCollection
//
//  Created by Trisha Dani on 5/18/20.
//  Copyright © 2020 Trisha Dani. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    // Movie label in collection view
    @IBOutlet weak var movieLabel: UILabel!
    
    // links the movie that the cell is displaying
    var movie:Movie?
    
    // links the button that takes you to the movie screen
    @IBAction func takeToMovieInfo(_ sender: Any) {
        print ("sending to Movie Info View Controller: \(String(describing: self.movie?.name))")
        let sendTo: MovieInfoViewController = MovieInfoViewController()
        sendTo.populateText(currentMovieToDisplay: (self.movie)!)
    }
    
    // called from ViewController to configure the cell that is being displayed
    func configureCell (movie:Movie) {
        // keep track of the movie that this cell represents
        self.movie = movie
        // set the movie label to the name of the movie in Movie object
        movieLabel.text = movie.name
    }
    
    
}
