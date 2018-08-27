//
//  ImageCollectionViewController.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 21..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit
import CoreData

protocol SendSeletedNotePhotoData {
    func moveToDiaryWithSelectedNoteData(_ date: Date, note noteData: Note)
}

private let reuseIdentifier = "Cell"

class NotePhotoCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {
    
    static var photoCellectionDelegate : SendSeletedNotePhotoData?
    
    var myFetchResultController : NSFetchedResultsController<Note>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.delegate = self
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        myFetchResultController = MyFetchedResultsControllerModel.NoteFetchedResultController()
        myFetchResultController.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        do {
            try myFetchResultController.performFetch()
            collectionView?.reloadData()
        } catch {
            
        }
        print("collectionview view appear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("collectionview disapear")
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myFetchResultController.fetchedObjects?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as! NotePhotoCollectionViewCell
        cell.imageView.image = UIImage()
        cell.imageView.alpha = 0
        cell.note = myFetchResultController.object(at: indexPath) as Note
        
        return cell
    }
    
    //MARK: passing note data to mainView
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? NotePhotoCollectionViewCell {
            passingDate = returnMyDate(cell)
            toNoteMainPageView(cell.note!)
        }
    }
    
    
    private func toNoteMainPageView(_ note: Note) {
        NotePhotoCollectionViewController.photoCellectionDelegate?.moveToDiaryWithSelectedNoteData(passingDate, note: note)
    }
    
    private var targetDate : Date!
    
    private var passingDate : Date {
        get {
            return targetDate
        } set {
            targetDate = newValue
        }
    }
    
    private func returnMyDate(_ cell: NotePhotoCollectionViewCell) -> Date {
        return (cell.note?.diary?.date)!
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
