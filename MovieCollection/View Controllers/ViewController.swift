//
//  ViewController.swift
//  MovieCollection
//
//  Created by Trisha Dani on 5/18/20.
//  Copyright © 2020 Trisha Dani. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{

    @IBOutlet weak var collectionView: UICollectionView!
    
    var model = MovieModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // at first app start, update all the movies
        model.updateMoviesArray()
        
        // set the view controller as the data source/delegate for the collection view
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // MARK: - Segue Functions
    
    // prep for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // sends movies array to AddScreen
        if segue.identifier == "AddSegue" {
            print ("sending to Add Movie View Controller")
            let dest1VC : AddScreenViewController = segue.destination as! AddScreenViewController
            dest1VC.model = self.model
        }
        //sends movies array to show to MovieInfo
        if segue.identifier == "MovieDisplaySegue" {
            print ("sending to Movie Info View Controller")
            // set the sender as a button
            let senderButton = sender as! UIButton
            
            // set the location for segue to MovieInfo
            let dest2VC : MovieInfoViewController = segue.destination as! MovieInfoViewController
            
            // send movies array
            dest2VC.model = self.model
            
            // save the specific movie to display by checking which button was pressed
            let movieName = senderButton.currentTitle
            
            // find the correct cell to send over
            if let movieToSend = model.moviesArray.first(where: {$0.name == movieName}) {
                dest2VC.movieToDisplay = movieToSend
            }
            else {
               // item could not be found
                print("Movie could not be found")
                // TODO: send user an alert if the movie is not found
            }
        }
        
    }
    
    // unwind from adding a movie
    @IBAction func unwindToMainView(segue: UIStoryboardSegue) {
        
        
    }
    
    // TODO: remove useless- BUTTON TO ADD NEW MOVIE (send to AddScreen view)
    @IBAction func addNewMovie(_ sender: Any) {
        
    }
    
    // actions to take when any movie button is pressed
    @IBAction func takeToMovieInfoDisplay(_ sender: UIButton) {
        self.performSegue(withIdentifier: "MovieDisplaySegue", sender: sender)
    }
    
    // MARK: - DELEGATE/DATASOURCE Functions
    
    // DATASOURCE PROTOCOL: returns the number of items in the collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // returns the number of movies we want to display
        print ("There are \(model.moviesArray.count) movies in the array.")
        return model.moviesArray.count
    }
    
    // DATASOURCE PROTOCOL: returns which cell should be displayed for a specific location in the collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a cell
        let cellForDisplay = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCollectionViewCell
        // configure cell
        cellForDisplay.configureCell(movie: model.moviesArray[indexPath.row])
        
        // return cell to be displayed
        return cellForDisplay
    }

}

