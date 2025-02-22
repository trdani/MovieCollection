//
//  ViewController.swift
//  MovieCollection
//
//  Created by Trisha Dani on 5/18/20.
//  Copyright © 2020 Trisha Dani. All rights reserved.
//
import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var model = MovieModel()
    
    // helper to unwind after adding movie segue
    var justAdded = Bool()
    var movieJustAdded = Movie()
    var dummyButton = UIButton()
    
    // holds Movies user searched for
    var filteredMovies:[Movie] = []
    
    
    // controller of search bar
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // at first app start, update all the movies based on the csv file
        model.loadDatabase()
        //model.updateMoviesArray()
        
        // set the view controller as the data source/delegate for the collection view
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // search bar items
        
        // inform class of any text changes
        searchController.searchResultsUpdater = self
        // no obscuring view when searching
        searchController.obscuresBackgroundDuringPresentation = false
        // keeps search bar at top of screen
        navigationItem.hidesSearchBarWhenScrolling = false
        // text displayed in search bar
        searchController.searchBar.placeholder = "Search Movies"
        // iOS 11 specific
        navigationItem.searchController = searchController
        // takes away search bar when not in this view controller anymore
        definesPresentationContext = true
    }
    
    // MARK: - Search Bar Functions
    
    // returns true if search bar is empty; else returns false
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    // filters movies based on searched text (by name or director)
    func filterContentForSearchText(_ searchText: String) {
        filteredMovies = model.moviesArray.filter { (movie: Movie) -> Bool in
            return movie.name.lowercased().contains(searchText.lowercased()) ||
                movie.director.lowercased().contains(searchText.lowercased()) ||
                movie.genre.lowercased().contains(searchText.lowercased())
        }
      
      collectionView.reloadData()
    }
    
    // MARK: - Outbound Segue Functions
    
    // prep for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // remove activity from search bar to ensure appropriate movie functions
        searchController.isActive = false
        //print("Segue was called")
        // sends movies array to AddScreen
        if segue.identifier == "AddSegue" {
            //print ("sending to Add Movie View Controller")
            let dest1VC : AddScreenViewController = segue.destination as! AddScreenViewController
            dest1VC.model = self.model
            dest1VC.popoverPresentationController?.delegate = self
        }
        //sends movies array to show to MovieInfo
        if segue.identifier == "MovieDisplaySegue" {
            //print ("sending to Movie Info View Controller")
            // set the sender as a button
            let senderButton = sender as! UIButton
            
            // set the location for segue to MovieInfo
            let dest2VC : MovieInfoViewController = segue.destination as! MovieInfoViewController
            dest2VC.popoverPresentationController?.delegate = self
            
            // send movies array
            dest2VC.model = self.model
            
            // save the specific movie to display by checking which button was pressed
            let buttonTitle:String = senderButton.currentTitle!

            // find the correct cell to send over
            if let movieToSend = model.moviesArray.first(where: {$0.unique_id == buttonTitle}) {
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
        self.model = sourceVC.model // pass the model back
        
        // refresh collectionView with the new movie in mind
        let indexPath = IndexPath(item: model.moviesArray.count-1, section: 0)
        movieJustAdded = sourceVC.currentMovie
        justAdded = true
        collectionView.numberOfItems(inSection: 0) //dummy line to avoid known Swift bug
        // update collectionView
        
        collectionView.performBatchUpdates({
            //resort array after adding element
            //print("Sorting after adding movie")
            self.model.sortMoviesArray(movies: &self.model.moviesArray)
            collectionView.insertItems(at: [indexPath])
        }, completion: nil)
        print("UNWIND and RESORT COMPLETE")
    }
    
    // "unwind" from deleting a movie record
    @IBAction func unwindAfterDeletingMovie(segue: UIStoryboardSegue) {
        let sourceVC : MovieInfoViewController = segue.source as! MovieInfoViewController
        // TODO: add alert about delete to verify that this is what they want to do
        // delete the movie record
        sourceVC.deleteMovieData()
        self.model = sourceVC.model // pass the model back after deleting
        
        // refresh collectionView with deleted movie in mind
        let indexPath = IndexPath(item: model.indexToDelete, section: 0)
        collectionView.numberOfItems(inSection: 0) // dummy line
        collectionView.performBatchUpdates({
            collectionView.deleteItems(at: [indexPath])
        }, completion: nil)
        print("DELETE COMPLETE")
    }
    
    // MARK: - Delegate and Datasource Functions
    
    // DATASOURCE PROTOCOL: returns the number of items in the collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //if filtering, return the smaller array of movies that are filtered
        if isFiltering {
          return filteredMovies.count
        }
        // returns the number of movies we want to display IF NOT FILTERING
        return model.moviesArray.count
    }
    
    // DATASOURCE PROTOCOL: returns which cell should be displayed for a specific location in the collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a cell
        let cellForDisplay = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCollectionViewCell
        
        // store movie to display inside MovieCollectionViewCell
        var movieToDisplay = Movie()
        
        // configure cell if filtering (draw from filtered array)
        if isFiltering {
            movieToDisplay = filteredMovies[indexPath.row]
        }
        // configure cell if not filtering
        else {
            movieToDisplay = model.moviesArray[indexPath.row]
        }
        cellForDisplay.configureCell(movie: movieToDisplay)
        
        // return cell to be displayed
        return cellForDisplay
    }
    
    // not currently used
    // check if a movie has already been displayed in the collection view
    func hasDuplicate(_ movie:Movie, _ visibleCells: [MovieCollectionViewCell]) -> Bool {
        for cell in visibleCells {
            if (cell.movie!.name == movie.name && cell.movie!.director == movie.director) {
                print("Found duplicate to \(movie.name)")
                return true
            }
        }
        return false
    }
    
    // MARK: - TODO: Alert functions (to be implemented)
    // not currently in use
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

// MARK: - Search bar extension class
extension ViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    filterContentForSearchText(searchBar.text!)
  }
}

// MARK: - Popover extension class
extension ViewController: UIPopoverPresentationControllerDelegate {

    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        // if just added a movie, send to display
        print("ViewController about to appear after popover")
        if (justAdded) {
            print("about to display a new movie")
            // send to display controller
            dummyButton = generateButton(movie: movieJustAdded)
            performSegue(withIdentifier: "MovieDisplaySegue", sender: dummyButton)
            justAdded = false
        }
    }
    
    func generateButton (movie: Movie) -> UIButton{
        let button:UIButton = UIButton()
        print("Generating dummy button for \(movie.name)")
        button.setTitle(movie.unique_id, for: UIControl.State.normal)
        return button
    }
}

// MARK: - UI Items
@IBDesignable

class GradientView: UIView {
    @IBInspectable var firstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var secondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var isHorizontal:Bool = true {
        didSet {
            updateView()
        }
    }
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [firstColor, secondColor].map{$0.cgColor}
        
        if (self.isHorizontal) {
            layer.startPoint = CGPoint(x:0, y:0.5)
            layer.endPoint = CGPoint(x:1, y:0.5)
        } else {
            layer.startPoint = CGPoint(x:0.5, y:0)
            layer.endPoint = CGPoint(x:0.5, y:1)
        }
    }
    
}
