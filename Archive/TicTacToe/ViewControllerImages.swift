//
//  ViewControllerImages.swift
//  TicTacToe
//
//  Created by Hen Hershko on 15/05/2016.
//  Copyright © 2016 Hen&Amit. All rights reserved.
//
import CoreData
import UIKit

class ViewControllerImages: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var arrayImage = [UIImage]()
    var curr_arrayImage = [UIImage]()
    var start_arr = [UIImage]()
    var index = 1
    var lastCell = CollectionViewCell()
    var imagePicker = UIImagePickerController()
    var images = [NSManagedObject]()
    var isExit = true
    
    @IBOutlet weak var btnTakePhoto: UIButton!
    @IBOutlet weak var btnPhotoLibrary: UIButton!
    @IBOutlet weak var textFieldURL: UITextField!
    @IBOutlet weak var btnChangeFromURL: UIButton!
    @IBOutlet weak var btnDefultPhotos: UIButton!
    
    @IBOutlet weak var collectionViewImages: UICollectionView!
    @IBOutlet weak var mCollectionView: UICollectionView!
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        if isExit
        {
            print("Bye")
            initCurrentArrImages()
            deleteAllData("Image")
            saveImages()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker.delegate = self
        initImagesArr()
        isExit = true
        // Do any additional setup after loading the view, typically from a nib.
    }
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
                start_arr.append(im!)
            }
            if arrayImage.count == 0{
                for var i = 0; i < 8; ++i{
                    arrayImage.append(UIImage(named:"\(i+1).jpg")!)
                    arrayImage.append(UIImage(named:"\(i+1).jpg")!)
                    start_arr.append(UIImage(named:"\(i+1).jpg")!)
                    
                }
            }
            print("success")
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func saveImages() {
        //1
        for(var i = 0; i<8;i++)
        {
            let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
            
            let managedContext = appDelegate.managedObjectContext
            
            //2
            let entity =  NSEntityDescription.entityForName("Image",
                inManagedObjectContext:managedContext)
            
            let image = NSManagedObject(entity: entity!,
                insertIntoManagedObjectContext: managedContext)
            
            //3
            
            image.setValue(UIImagePNGRepresentation(curr_arrayImage[i]), forKey: "image")
            //4
            do {
                try managedContext.save()
                //5
                images.append(image)
                print("Success")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
    
    func deleteAllData(entity: String)
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.deleteObject(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
    @IBAction func onClickTakePhoto(sender: AnyObject) {
        isExit = false
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            //load the camera interface
            let picker : UIImagePickerController = UIImagePickerController()
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.delegate = self
            picker.allowsEditing = false
            self.presentViewController(picker, animated: true, completion: nil)
        }else{
            //no camera available
            let alert = UIAlertController(title: "Error", message: "There is no camera available", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: {(alertAction)in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
            isExit = true
        }
        
    }
    @IBAction func onClickPhotoLibrary(sender: AnyObject) {
        isExit = false
        let picker : UIImagePickerController = UIImagePickerController()
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(.PhotoLibrary)!
        picker.delegate = self
        picker.allowsEditing = false
        self.presentViewController(picker, animated: true, completion: nil)
        
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            lastCell.setImage(pickedImage)
        }
        dismissViewControllerAnimated(true, completion: nil)
        isExit = true
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.imagePicker = UIImagePickerController()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func OnClickChangeFromURL(sender: AnyObject) {
        if let url = NSURL(string: textFieldURL.text!)
        {
            downloadImage(url)
        }
        
    }
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    func downloadImage(url: NSURL){
        print("Download Started")
        print("lastPathComponent: " + (url.lastPathComponent ?? ""))
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else {print(error)
                    return }
                print(response?.suggestedFilename ?? "")
                print("Download Finished")
                self.lastCell.setImage(UIImage(data: data)!)
            }
        }
    }
    @IBAction func onClickChangeToDefult(sender: AnyObject) {
        initDefualtImage()
    }
    
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellIdentifier", forIndexPath: indexPath)
            as! CollectionViewCell
        cell.setImage(start_arr[index-1])
        if(index == 1)
        {
            lastCell = cell
            cell.drawRect()
        }
        index++
        //  cell.cellLabel.text = "\(indexPath.row),\(indexPath.section)"
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.mCollectionView = collectionView
        
        lastCell.disableRect()
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath)as! CollectionViewCell
        
        cell.selected = true
        cell.drawRect()
        
        lastCell = cell
        
    }
    func initDefualtImage()
    {
        arrayImage = [UIImage]()
        for var i = 0; i < 8; ++i{
            arrayImage.append(UIImage(named:"\(i+1).jpg")!)
            let indexPath = NSIndexPath(forRow: i%4, inSection: i/4)
            let cell = mCollectionView.cellForItemAtIndexPath(indexPath)as! CollectionViewCell
            cell.setImage(arrayImage[i])
        }
    }
    
    func initCurrentArrImages()
    {
        curr_arrayImage = [UIImage]()
        for var i = 0; i < 8; ++i{
            let indexPath = NSIndexPath(forRow: i%4, inSection: i/4)
            let cell = mCollectionView.cellForItemAtIndexPath(indexPath)as! CollectionViewCell
            curr_arrayImage.append(cell.getImage())
        }
    }
    
}