//
//  FlickerPhotosViewController.swift
//  flickerSearch_bmiles
//
//  Created by Benjamin Miles on 2/5/19.
//  Copyright © 2019 Benjamin Miles. All rights reserved.
//

import UIKit

class FlickerPhotosViewController: UICollectionViewController {

    // MARK: - Properties
    private let reuseIdentifier = "flickrCell"
    
    private let sectionInsets = UIEdgeInsets(top: 50.0,
                                             left: 20.0,
                                             bottom: 50.0,
                                             right: 20.0)
    
    private var searches: [FlickrSearchResults] = []
    private let flickr = Flickr()

    
    private let itemsPerRow: CGFloat = 3.0
}


// Mark: - Extentions
private extension FlickerPhotosViewController {
    
    func photo(for indexPath: IndexPath) -> FlickrPhoto {
        return searches[indexPath.section].searchResults[indexPath.row]
    }
}


// Text Field delegate
extension FlickerPhotosViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Activity Indicator
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        textField.addSubview(activityIndicator)
        activityIndicator.frame = textField.bounds
        activityIndicator.startAnimating()
        
        flickr.searchFlickrForTerm(textField.text!) {
            
            results, error in
            
            activityIndicator.removeFromSuperview()
            
            // Log errors to console
            if let error = error {
                print("Error searching: \(error)")
                return
            }
            
            if let results = results {
                // The results get logged and added to the front of
                // the searches array
                
                // SANITY CHECK
                
                self.searches.insert(results, at:0)
                
                // self.collectionView is the collection view object
                // managed by this iew controller
                // At this point, we will have new data and need to refresh
                // the ui, so reload all data from the collection
                //
                
                self.collectionView?.reloadData()
                
                
                
            }
        }
        
        
        textField.text = nil
        textField.resignFirstResponder()
        return true
    }
}


// MARK: - UICollectionViewDataSource

extension FlickerPhotosViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return searches.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searches[section].searchResults.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        cell.backgroundColor = .black
        return cell
    }
}


extension FlickerPhotosViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
}

