//
//  AddScreenViewController.swift
//  MovieCollection
//
//  Created by Trisha Dani on 5/18/20.
//  Copyright © 2020 Trisha Dani. All rights reserved.
//

import UIKit

class AddScreenViewController: UIViewController {

    // stores movies array
    var moviesArray = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    // MARK: - Segue Functions

    // prep for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // sends movies array to ViewController
        let dest1VC : ViewController = segue.destination as! ViewController
        dest1VC.moviesArray = self.moviesArray
    }
    
    // sends back to ViewController WITHOUT saving a movie
    // cancel the addition of a movie to the movies array
    @IBAction func cancelMovie(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    // sends back to ViewController WITH SAVED MOVIE
    @IBAction func saveMovie(_ sender: Any) {
        // TODO: save movie by accessing data source in MovieModel
        
        // dismiss
        dismiss(animated: true, completion: nil)
    }
    
}
