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
    
    let model = MovieModel()
    var moviesArray = [Movie]()
    // TODO: find a way to send the Movie Info View Controller the specific movie you just clicked on
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // TODO: figure out which is prioritized- segue instructions or viewDidLoad (segue prioritized!!!!!!!!!)
        moviesArray = model.getMovies()
        
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
            dest1VC.moviesArray = self.moviesArray
        }
        //sends movies array to show to MovieInfo
        if segue.identifier == "MovieInfoSegue" {
            let dest2VC : MovieInfoViewController = segue.destination as! MovieInfoViewController
            dest2VC.moviesArray = self.moviesArray
        }
        
    }
    
    // TODO: remove useless- BUTTON TO ADD NEW MOVIE (send to AddScreen view)
    @IBAction func addNewMovie(_ sender: Any) {
        
    }
    
    
    // MARK: - DELEGATE/DATASOURCE Functions
    
    // DATASOURCE PROTOCOL: returns the number of items in the collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // returns the number of movies we want to display
        return moviesArray.count
    }
    
    // DATASOURCE PROTOCOL: returns which cell should be displayed for a specific location in the collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a cell
        let cellForDisplay = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCollectionViewCell
        // configure cell
        cellForDisplay.configureCell(movie: moviesArray[indexPath.row])
        
        // return cell to be displayed
        return cellForDisplay
    }
    
    // TODO: remove useless TO VIEW A MOVIE ARCHIVE (needs to go to movie info view control
    // Delegate protocol that does something for whichever cell was just tapped
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    

}

