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
        self.movie = movie
        // set the movie label to the name of the movie in Movie object
        movieLabel.text = movie.name
        // set the button name to the name of the movie in Movie object
        movieButton.setTitle(movie.name, for: UIControl.State.normal)
    }
    
    
}
