//
//  Note.swift
//  infinitePageViewTest
//
//  Created by goya on 2018. 8. 7..
//  Copyright © 2018년 goya. All rights reserved.
//

import UIKit
import CoreData

class Note: NSManagedObject {
    
    static func deleteNote(_ note: Note) {
        let context = AppDelegate.viewContext
        context.delete(note)
    }
    
    static func fetchAllThumbData() throws -> [Data] {
        var thumbs = [Data]()
        let request : NSFetchRequest<Note> = Note.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "createdDate", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        let context = AppDelegate.viewContext
        do {
            let result = try context.fetch(request)
            for note in result {
                if let thumb = note.thumbnail {
                thumbs.append(thumb)
                }
            }
        } catch {
            throw error
        }
        return thumbs
    }
    
    static func fetchAllNoteData() throws -> [Note] {
        let request : NSFetchRequest<Note> = Note.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "createdDate", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        let context = AppDelegate.viewContext
        do {
            return try context.fetch(request)
        } catch {
            throw error
        }
    }
    
    class func test(_ diary: Diary, date dateData: Date) {
        let request : NSFetchRequest<Diary> = Diary.fetchRequest()
        let predicate = NSPredicate(format: "date == %@", dateData as CVarArg)
        request.predicate = predicate
        let context = AppDelegate.viewContext
        do {
            let a = try context.fetch(request)
            
        } catch { }
        
    }
    
    class func allNotesFromHashtag(_ hashTag: HashTag) -> [Note] {
        return ((hashTag.notes as? Set<Note>)?.reversed().sorted(by:({($0.diary?.date!)! > ($1.diary?.date!)!})))!
    }
    
    class func allHashsFromNote(_ note: Note) -> [HashTag] {
        return ((note.hashtags as? Set<HashTag>)?.reversed().sorted(by:({($0.hashtag)! < ($1.hashtag)!})))!
    }
    
    class func allNotesFromDiary(_ diary: Diary) -> [Note] {
        return ((diary.notes as? Set<Note>)?.reversed().sorted(by: ({$0.createdDate! > $1.createdDate!})))!
    }
    
    class func loadDataFromDiary(_ diary: Diary) throws -> [Note] {
        let request : NSFetchRequest<Note> = Note.fetchRequest()
        //if set Data attribute in Note, it will be working but not yet.
        let predicate = NSPredicate(format: "Note.date == %@", (diary.date)! as CVarArg)
        let sortDescriptor = NSSortDescriptor(key: "createdDate", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        request.predicate = predicate
        let context = AppDelegate.viewContext
        do {
            return try context.fetch(request)
        } catch {
            throw error
        }
    }
    
    class func saveOrCreateHashTags(tags hashTags: [String]?, note noteData: Note?) {
        print("Tag Saving Method called")
        func fetchHashTag(_ tag: String) throws {
            print("fetching tags")
            let request : NSFetchRequest<HashTag> = HashTag.fetchRequest()
            let predicate = NSPredicate(format: "%K == %@", #keyPath(HashTag.hashtag), (tag) as CVarArg)
            request.predicate = predicate
            let context = AppDelegate.viewContext
            do {
                if let myHash = try context.fetch(request).first {
                    print("Tag Method called")
                    //add note to hashtag
                    if (myHash.notes?.contains(noteData!))! {
                        return
                    } else {
                        myHash.addToNotes(noteData!)
                    }
                } else {
                    //create hashtag
                    let hashTag = HashTag(context: noteData!.managedObjectContext!)
                    hashTag.hashtag = tag
                    noteData?.addToHashtags(hashTag)
                }
            } catch {
                throw error
            }
        }
        if let myHashs = hashTags {
            for item in myHashs {
                do { try fetchHashTag(item) } catch {}
            }
        }
    }
    
    class func saveDataOrCeate(_ diary: Diary?, note noteData: Note?, image imageData: Data?, thumbnail thumbnailData: Data? ,comment commentData: String?, date dateData: Date?) throws {
        print("saving method called")
        
        let context = AppDelegate.viewContext
        if diary == nil {
            let newNote = Note(context: context)
            saveDataToNote(newNote, image: imageData, thumbnail: thumbnailData, comment: commentData)
            newNote.createdDate = Date()
            let notesDiary = Diary(context: newNote.managedObjectContext!)
            newNote.diary = notesDiary
            newNote.diary?.date = dateData
            saveOrCreateHashTags(tags: SavingContent.hashTag /* set tags*/ , note: newNote)
        } else {
            print("diary else state activated")
            if noteData != nil {
                saveDataToNote(noteData!, image: imageData, thumbnail: thumbnailData, comment: commentData)
                saveOrCreateHashTags(tags: SavingContent.hashTag /* set tags*/ , note: noteData)
            } else if noteData == nil {
                print("note else state activated")
                let newNote = Note(context: context)
                saveDataToNote(newNote, image: imageData, thumbnail: thumbnailData, comment: commentData)
                newNote.createdDate = Date()
                diary?.addToNotes(newNote)
                saveOrCreateHashTags(tags: SavingContent.hashTag /* set tags*/ , note: newNote)
            }
        }
        do {
            try context.save()
        } catch let error {
            throw error
        }
    }
    
    private class func saveDataToNote(_ note: Note, image imageData: Data?, thumbnail thumbnailData: Data? ,comment commentData: String?) {
        if let _ = note.noteImage {
            if let image = imageData {
                note.noteImage?.originalImage = image
            }
            if let thumbnail = thumbnailData {
                note.noteImage?.thumbnailImage = thumbnail
            }
            if let comment = commentData {
                note.comment = comment
            }
        } else {
            let newImageDirection = Image(context: note.managedObjectContext!)
            note.noteImage = newImageDirection
            if let image = imageData {
                note.noteImage?.originalImage = image
            }
            if let thumbnail = thumbnailData {
                note.noteImage?.thumbnailImage = thumbnail
            }
            if let comment = commentData {
                note.comment = comment
            }
        }
    }
    
}
