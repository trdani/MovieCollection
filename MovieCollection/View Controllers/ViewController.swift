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
        // at first app start, update all the movies based on the csv file
        model.updateMoviesArray()
        
        // set the view controller as the data source/delegate for the collection view
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // MARK: - Outgoing Segue Functions
    
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
            let buttonTitle:[String] = (senderButton.currentTitle?.components(separatedBy: "|"))!
            let movieName = buttonTitle[0]
            let director = buttonTitle[1]
            
            // find the correct cell to send over
            if let movieToSend = model.moviesArray.first(where: {$0.name == movieName && $0.director == director}) {
                dest2VC.movieToDisplay = movieToSend
            }
            else {
               // item could not be found
                print("Movie could not be found")
                // TODO: send user an alert if the movie is not found
            }
        }
    }
    
    // actions to take when any movie button is pressed
    @IBAction func takeToMovieInfoDisplay(_ sender: UIButton) {
        self.performSegue(withIdentifier: "MovieDisplaySegue", sender: sender)
    }
    
    // MARK: - Inbound Segue Functions
    
    // "unwind" from adding a movie
    @IBAction func unwindToMainView(segue: UIStoryboardSegue) {
        // takes movies model from AddMovie VC
        let sourceVC : AddScreenViewController = segue.source as! AddScreenViewController
        // save data after clicking save
        sourceVC.saveMovieData()
        // TODO: sort here???
        //sourceVC.model.sortMoviesArray(movies: &sourceVC.model.moviesArray)
        self.model = sourceVC.model // pass the model back
        
        // refresh collectionView with the new movie in mind
        let indexPath = IndexPath(item: model.moviesArray.count-1, section: 0)
        collectionView.numberOfItems(inSection: 0) //dummy line to avoid known Swift bug
        // update collectionView
        collectionView.performBatchUpdates({
            collectionView.insertItems(at: [indexPath])
            //resort array after adding element
            sourceVC.model.sortMoviesArray(movies: &sourceVC.model.moviesArray)
        }, completion: nil)
        print("UNWIND and RESORT COMPLETE")
    }
    
    // "unwind" from deleting a movie record
    @IBAction func unwindAfterDeletingMovie(segue: UIStoryboardSegue) {
        let sourceVC : MovieInfoViewController = segue.source as! MovieInfoViewController
        // TODO: add alert about delete to verify that this is what they want to do
        // delete the movie record
        sourceVC.deleteMovieData()
        // TODO: sort here??
        //sourceVC.model.sortMoviesArray(movies: &sourceVC.model.moviesArray)
        self.model = sourceVC.model // pass the model back after deleting
        
        // refresh collectionView with deleted movie in mind
        let indexPath = IndexPath(item: model.indexToDelete, section: 0)
        collectionView.numberOfItems(inSection: 0) // dummy line
        collectionView.performBatchUpdates({
            collectionView.deleteItems(at: [indexPath])
        }, completion: nil)
        print("Delete complete")
    }
    
    // MARK: - Helper function for sorting collection view
    func sortCollectionViewItems() {
        // call moveItem(at indexPath: __, to newIndexPath) repeatedly
        
    }
    
    // TODO: remove useless- BUTTON TO ADD NEW MOVIE (send to AddScreen view)
    @IBAction func addNewMovie(_ sender: Any) {
        
    }
    
    // MARK: - DELEGATE/DATASOURCE Functions
    
    // DATASOURCE PROTOCOL: returns the number of items in the collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // returns the number of movies we want to display
        //print ("There are \(model.moviesArray.count) movies in the array.")
        return model.moviesArray.count
    }
    
    // DATASOURCE PROTOCOL: returns which cell should be displayed for a specific location in the collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a cell
        let cellForDisplay = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCollectionViewCell
        // configure cell
        
        // TODO: ISSUE HERE WITH INDEX PATH PASSING WRONG CELL TO DISPLAY AFTER SORTING
        print("Configuring cell \(model.moviesArray[indexPath.row].name)")
        cellForDisplay.configureCell(movie: model.moviesArray[indexPath.row])
        
        // return cell to be displayed
        return cellForDisplay
    }
    
    // MARK: - Alert functions (to be implemented)
    
    func showDeleteAlert (sourceVC: MovieInfoViewController) {
        //create alert
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this movie record?", preferredStyle: .alert)
        
        // create Cancel and Delete buttons for alert
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (deleteAction) in

        }
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        // show the alert
        present(alert, animated: true, completion: nil)
    }
}
