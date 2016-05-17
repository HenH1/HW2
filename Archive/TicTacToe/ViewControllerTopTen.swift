//
//  ViewControllerTopTen.swift
//  TicTacToe
//
//  Created by Hen Hershko on 16/05/2016.
//  Copyright © 2016 Hen&Amit. All rights reserved.
//

import CoreData
import UIKit

class ViewControllerTopTen: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource{
    var users = [NSManagedObject]()
    var label:UILabel!
    var indexCell = 0
    @IBOutlet weak var mUICollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellIdentifier", forIndexPath: indexPath)
        
        label = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 25))
        label.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        label.textAlignment = .Center
        
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "User")
        //3
        do {
            let sortDescriptor2 = NSSortDescriptor(key: "time", ascending: true)
            let sortDescriptor = NSSortDescriptor(key: "score", ascending: false)
            
            fetchRequest.sortDescriptors = [sortDescriptor,sortDescriptor2]
            
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            users = results as! [NSManagedObject]
            
            if users.count > indexCell
            {
                let user = users[indexCell]
                let name = user.valueForKey("name")as! String
                let score = user.valueForKey("score")as! Int
                let time = user.valueForKey("time")as! Int
                label = UILabel(frame: CGRect(x: 0, y: 0, width: 248, height: 25))
                label.font = UIFont.systemFontOfSize(20)
                label.textColor = UIColor.blueColor()
                label.textAlignment = .Left
                label.text = "\(indexCell+1).  \(name)  \(score)  \(time)"
                indexCell++
                cell.contentView.addSubview(label)
            }
            print("success")
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            
        }
        return cell
    }
    
}
