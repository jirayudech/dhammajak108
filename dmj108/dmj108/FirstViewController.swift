//
//  FirstViewController.swift
//  dmj108
//
//  Created by Jirayudech on 4/5/2560 BE.
//  Copyright © 2560 RGT Soft. All rights reserved.
//

import UIKit
import AVFoundation
var songs: [AVPlayerItem] = []
var isPlaying = 0
var RoundCount = 0

class FirstViewController: UIViewController {
    
    var qp: AVQueuePlayer!


    @IBOutlet weak var text_round: UILabel!
    @IBOutlet weak var Round: UILabel!
    @IBOutlet weak var TotalRound: UILabel!
    @IBOutlet weak var PlayButton: UIButton!
    @IBOutlet weak var Label1: UILabel!
    @IBOutlet weak var RestartButton: UIButton!
    @IBOutlet weak var stepper: UIStepper!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //Decorate UI
        RestartButton.layer.borderColor = UIColor.black.cgColor
        RestartButton.layer.cornerRadius = 5
        
        stepper.layer.cornerRadius = 5
        
        self.tabBarController?.tabBar.tintColor = UIColor.orange
        
        //Total Round
        let Default = UserDefaults.standard
        
        TotalRound.text = Default.value(forKey: "TotalRound") as! String?
        
        if TotalRound.text == nil || TotalRound.text?.isEmpty == true {
            TotalRound.text = "0"
        }
        
        /// Enable background play. Need to add capabilities, Background Mode: Audio, Airplay
        let audioSession = AVAudioSession.sharedInstance()
        
        do{
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
        } catch{
            print(error)
        }
        
        
        //Fix drag does not work.
        /*let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FirstViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)*/
    }

    //Calls this function when the tap is recognized.
    /*func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        //view.endEditing(true)
    }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func Stepper(_ stepper: UIStepper) {
        Round.text = "\(String(format: "%.0f", stepper.value))"
    }
    
    @IBAction func PlayButtonAction(_ sender: Any) {
        if (isPlaying==0) {
            //Playing variables setup.
            Label1.text =  "กำลังสวด..."
            isPlaying = 1;
            PlayButton.setImage(UIImage(named: "pause")?.withRenderingMode(.alwaysOriginal), for: .normal)
            RestartButton.isEnabled = true
            stepper.isEnabled = false
            
            
            //Add songs to play list.
            songs = []
            var rounds = Int(Round.text!)!
            for _ in 0 ..< Int(rounds) {
                let url = Bundle.main.url(forResource: "dhammajak", withExtension: "mp3")!
                let asset2 = AVAsset(url: url)
                let playerItem2 = AVPlayerItem(asset: asset2)
                
                songs = songs + [playerItem2]
            }
            
            
            self.qp = AVQueuePlayer.init(items: songs)
            self.qp.addObserver(self, forKeyPath: "currentItem", options: NSKeyValueObservingOptions(), context: nil)
            self.qp.play()
            
        } else if(isPlaying==1){
            Label1.text =  "หยุดสวดชั่วคราว..."
            self.qp.pause()
            isPlaying = 2;
            PlayButton.setImage(UIImage(named: "play")?.withRenderingMode(.alwaysOriginal), for: .normal)
            
        } else if(isPlaying==2){ //paused
            Label1.text =  "กำลังสวด..."
            self.qp.play()
            isPlaying = 1;
            PlayButton.setImage(UIImage(named: "pause")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
    }
    
    
    @IBAction func RestartButtonAction(_ sender: Any) {
        let text = self.text_round.text
        ResetPlayer()
        self.text_round.text = text
        Label1.text =  ""
        
    }
    
    
    func ResetPlayer(){
        //self.qp.pause()
        songs = [];
        self.qp = AVQueuePlayer.init(items: songs)
        isPlaying = 0
        //self.text_round.text = "1"
        PlayButton.setImage(UIImage(named: "play")?.withRenderingMode(.alwaysOriginal), for: .normal)
        RestartButton.isEnabled = false
        RoundCount = 0
        stepper.isEnabled = true
    }
    
    //Observe when finished each songs
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        RoundCount = RoundCount + 1
        Label1.text = "สวดแล้ว " + String(RoundCount)+" จบ"
        
        //Save total round to device storage.
        let Default = UserDefaults.standard
        
        let total = 1 + Int(TotalRound.text!)!

        Default.set(String(total), forKey: "TotalRound")
        
        //Update total rounds on screen
        TotalRound.text = String(total)
        
        if(RoundCount == Int(Round.text!)){ // finished all rounds
            ResetPlayer()
        }
        
    }
    
}

