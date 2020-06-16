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
    
    // links the button that the collection view holds to each cell
    @IBOutlet weak var movieButton: UIButton!
    
    // links the movie that the cell is displaying
    var movie:Movie?
    
    // called from ViewController to configure the cell that is being displayed
    func configureCell (movie:Movie) {
        // keep track of the movie that this cell represents
        movieLabel.text = nil
        self.movie = nil
        self.movie = movie
        //print("Movie received to configure: \(movie.name)")
        // set the movie label to the name of the movie in Movie object
        // if there is a year to display, show it
        if movie.year != 0 {
            movieLabel.text = movie.name + " (" + String(movie.year) + ")"
        }
        else {
            movieLabel.text = movie.name
        }
        
        // set the button name to the unique_id of the movie in Movie object
        movieButton.setTitle(movie.unique_id, for: UIControl.State.normal)
    }
}
