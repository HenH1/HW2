//
//  ViewControllerMain.swift
//  TicTacToe
//
//  Created by Hen Hershko on 16/05/2016.
//  Copyright © 2016 Hen&Amit. All rights reserved.
//
import UIKit

class ViewControllerMain: UIViewController{
    @IBOutlet weak var textFiledName: UITextField!
    @IBOutlet weak var btnPlay: UIButton!
    
    @IBAction func onChangedEdit(sender: AnyObject) {
        if textFiledName.text == ""
        {
            btnPlay.enabled = false
        }
        else
        {
            btnPlay.enabled = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        btnPlay.enabled = false
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "playSegue"
        {
            let vc = segue.destinationViewController as! ViewController
            vc.userName = textFiledName.text!
        }
    }
}