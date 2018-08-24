//
//  ImageCollectionViewController.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 21..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "Cell"

class ImageCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var notes = [Note]() {
        didSet {
            print(notes.count)
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.delegate = self
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
                do {
                    notes = try Note.fetchAllNoteData()
                } catch {
        
                }
        //fetchingAllNotes()
        print("collectionview view appear")
    }
    
    func fetchingAllNotes() {
        AppDelegate.persistentContainer.performBackgroundTask { (context) in
            let request : NSFetchRequest<Note> = Note.fetchRequest()
            do {
                var result = try context.fetch(request)
                result.sort(by: ({$0.createdDate! > $1.createdDate!}))
                DispatchQueue.main.async {
                    self.notes = result
                }
            } catch {
                
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("collectionview disapear")
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as! MainImageCollectionViewCell
        cell.imageView.image = UIImage()
        cell.imageView.alpha = 0
        cell.note = notes[indexPath.row]
        
        return cell
    }
    
    //MARK : collectionView flowLayout settings
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width / 4 - 7.5
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)
    }
    
}
