//
//  ViewController.swift
//  TicTacToe
//
//  Created by admin on 3/4/16.
//  Copyright © 2016 Hen&Amit All rights reserved.

import CoreData
import UIKit

class ViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource{
    var arrayImage = [UIImage]()
    var arrLocation = [Int]()
    var dicImage = [Int:UIImage]()
    var counter = 1
    var lastIndexPath = NSIndexPath()
    var lastCell = CollectionViewCell()
    var canPlay = true
    var playedAlready = false
    var score = 0
    var timerCount = 0
    var timerRunning = false
    var timer = NSTimer()
    var mCollectionView:UICollectionView!
    var correct = 0
    var firstRun = true
    var userName = ""
    var users = [NSManagedObject]()
    var images = [NSManagedObject]()
    
    @IBOutlet weak var btnStartOver: UIButton!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelScore: UILabel!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var labelDone: UILabel!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    func initImagesArr(){
        arrayImage = [UIImage]()
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Image")
        //3
        do {
            
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            images = results as! [NSManagedObject]
            
            for (var i = 0; i < images.count; i++)
            {
                let image = images[i].valueForKey("image")as! NSData
                let im = UIImage(data:image,scale:1.0)
                arrayImage.append(im!)
                arrayImage.append(im!)
            }
            if arrayImage.count == 0{
                for var i = 0; i < 8; ++i{
                    arrayImage.append(UIImage(named:"\(i+1).jpg")!)
                    arrayImage.append(UIImage(named:"\(i+1).jpg")!)
                    
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            
        }
    }
    func saveResult() {
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let entity =  NSEntityDescription.entityForName("User",
            inManagedObjectContext:managedContext)
        let user = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        //3
        user.setValue(userName, forKey: "name")
        user.setValue(score, forKey: "score")
        user.setValue(timerCount, forKey: "time")
        //4
        do {
            try managedContext.save()
            //5
            users.append(user)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func scoringCalc () -> Int
    {
        let dicScoring = [20:200,40:150,60:100,80:50,100:20,120:10]
        var temp = 20
        if(timerCount < 20)
        {
            temp = 20
        }
        else if(timerCount < 40)
        {
            temp = 40
        }
        else if(timerCount < 60)
        {
            temp = 60
        }
        else if(timerCount < 80)
        {
            temp = 80
        }
        else if(timerCount<100)
        {
            temp = 100
        }
        else if(timerCount<120)
        {
            temp = 120
        }
        return dicScoring[temp]!
    }
    
    func counting (){
        if(timerRunning && correct != 8)
        {
            timerCount+=1
            labelTime.text = "Timer: \(timerCount)"
        }
    }
    
    @IBAction func onlickStartOver(sender: UIButton) {
        timerCount = 0
        score = 0
        labelTime.text = "Timer: 0"
        labelScore.text = "Score: 0"
        timerRunning = false
        initBoard()
        if(playedAlready)
        {
            startOver(mCollectionView)
        }
        btnStartOver.hidden=true
        btnStart.hidden=false
    }
    
    @IBAction func onClickStart(sender: AnyObject) {
        if(!timerRunning)
        {
            timerRunning = true
            btnStart.hidden=true
            btnStop.hidden=false
        }
    }
    
    @IBAction func onClickStop(sender: AnyObject) {
        
        if(timerRunning)
        {
            //timer.invalidate()
            timerRunning = false
            btnStop.hidden=true
            btnStart.hidden=false
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initImagesArr()
        navigationBar.topItem?.title = "Hello \(userName)"
        initBoardDic()
        initBoard()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellIdentifier", forIndexPath: indexPath)
            as! CollectionViewCell
        cell.setBackImage();
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.mCollectionView = collectionView
        if(timerRunning)
        {
            playedAlready = true
            let cell = collectionView.cellForItemAtIndexPath(indexPath)as! CollectionViewCell
            
            if(counter%2 == 1) // first press
            {
                if(canPlay)
                {
                    lastIndexPath = indexPath
                    lastCell = cell
                    cell.setFrontImage(dicImage[indexPath.row * 4 + indexPath.section]!)
                    cell.flipCard()
                    counter++
                }
                
            }
            else // second
            {
                if(indexPath != lastIndexPath)
                {
                    if(canPlay)
                    {
                        counter++
                        cell.setFrontImage(dicImage[indexPath.row * 4 + indexPath.section]!)
                        cell.flipCard()
                        
                        if(dicImage[indexPath.row * 4 + indexPath.section] == dicImage[lastIndexPath.row * 4 + lastIndexPath.section])
                        {
                            correct++
                            score += scoringCalc()
                            labelScore.text = "Score: \(score)"
                            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
                            dispatch_after(delayTime, dispatch_get_main_queue()) {
                                cell.hidden = true
                                self.lastCell.hidden = true
                                self.canPlay = true
                                if(self.correct == 8)
                                {
                                    self.labelDone.hidden = false //needs to wait until all the cards will fliped
                                    self.btnStop.hidden=true
                                    self.btnStartOver.hidden=false
                                    self.saveResult()
                                }
                            }
                            
                        }
                        else
                        {
                            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
                            
                            dispatch_after(delayTime, dispatch_get_main_queue()) {
                                cell.flipCard()
                                self.lastCell.flipCard()
                                self.canPlay = true
                            }
                        }
                    }
                    canPlay = false
                    
                }
            }
        }
    }
    func initBoardDic()
    {
        for var index = 0; index < 16; ++index{
            arrLocation.append(index)
        }
        arrLocation.shuffleInPlace()
    }
    func initBoard(){
        btnStart.hidden=false
        btnStartOver.hidden=true
        btnStop.hidden=true
        labelDone.hidden = true
        correct = 0
        
        arrayImage.shuffleInPlace()
        for var index = 0; index < 16; ++index{
            dicImage[arrLocation[index]] = arrayImage[index]
        }
        if(firstRun){
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("counting"), userInfo: nil, repeats: true)
            firstRun=false
        }
        
        
    }
    func startOver(collectionView: UICollectionView){
        for var index = 0; index < 16; ++index{
            let indexPath = NSIndexPath(forRow: index/4, inSection: index%4)
            let cell = collectionView.cellForItemAtIndexPath(indexPath)as! CollectionViewCell
            cell.hidden = false
            cell.setBackImage()
            cell.flipCard()
        }
    }
    
}

extension CollectionType {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}