//
//  FirstViewController.swift
//  dmj108
//
//  Created by Jirayudech on 4/5/2560 BE.
//  UI/UX Designed by Nopphakhun
//  Developed by RGT Soft. 
//

import UIKit
import AVFoundation
var songs: [AVPlayerItem] = []
var isPlaying = 0 // isPlaying: 0 -> Stopped, 1 -> Playing, 2 -> Paused
var RoundCount = 0
var speed: Float = 1

class FirstViewController: UIViewController {
    
    var qp: AVQueuePlayer!


    @IBOutlet weak var text_round: UILabel!
    @IBOutlet weak var Round: UILabel!
    @IBOutlet weak var TotalRound: UILabel!
    @IBOutlet weak var PlayButton: UIButton!
    @IBOutlet weak var Label1: UILabel!
    @IBOutlet weak var RestartButton: UIButton!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var SpeedSlider: UISlider!

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
        let text = self.text_round.text
        ResetPlayer()
        self.text_round.text = text
        Label1.text =  ""
        
    }
    
    @IBAction func PlayButtonAction(_ sender: Any) {
        // isPlaying: 0 -> Stopped, 1 -> Playing, 2 -> Paused
        if (isPlaying==0) {
            //Playing variables setup.
           /* Label1.text =  "กำลังสวด..."
            isPlaying = 1;
            PlayButton.setImage(UIImage(named: "pause")?.withRenderingMode(.alwaysOriginal), for: .normal)
            RestartButton.isEnabled = true
            //stepper.isEnabled = false*/
            
            
            //Add songs to play list.
            //addSongToPlaylist(SongName: "dhammajak")
            
            /*songs = []
            let rounds = Int(Round.text!)!
            for _ in 0 ..< Int(rounds) {
                let url = Bundle.main.url(forResource: "dhammajak", withExtension: "mp3")!
                let asset2 = AVAsset(url: url)
                let playerItem2 = AVPlayerItem(asset: asset2)
                
                songs = songs + [playerItem2]
            }
            
            
            self.qp = AVQueuePlayer.init(items: songs)*/
            
            //self.qp.addObserver(self, forKeyPath: "currentItem", options: NSKeyValueObservingOptions(), context: nil)
            Play(speed)
            
        } else if(isPlaying==1){ //Playing
            Label1.text =  "หยุดสวดชั่วคราว..."
            self.qp.pause()
            isPlaying = 2;
            PlayButton.setImage(UIImage(named: "play")?.withRenderingMode(.alwaysOriginal), for: .normal)
            
        } else if(isPlaying==2){ //Paused
            Label1.text =  "กำลังสวด..."
            //self.qp.play()
            Play(speed)
            isPlaying = 1;
            PlayButton.setImage(UIImage(named: "pause")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
    }
    
    @IBAction func SpeedSliderAction(_ sender: Any) {
        speed = (sender as AnyObject).value
        
        if #available(iOS 10.0, *) {
            var sp: Float = 1
            if(speed < 1.25){
                speed = 1
                sp = 1
                SpeedSlider.setValue(speed, animated: false)
                Label1.text = "จบละ 17 นาที"
            } else if(speed >= 1.25 && speed < 1.75) {
                speed = 1.5
                sp = 1.4 //ความเร็ว 1.4 เท่า
                SpeedSlider.setValue(speed, animated: false)
                Label1.text = "จบละ 12 นาที"
            } else if(speed >= 1.75) {
                speed = 2
                sp = 1.8 //ความเร็ว 1.8 เท่า
                SpeedSlider.setValue(speed, animated: false)
                Label1.text = "จบละ 9 นาที"
            }
            
            if (isPlaying != 0){
                Play(sp)
            }
        } else {

            if(speed <= 1.5){
                speed = 1
                SpeedSlider.setValue(speed, animated: false)
                Label1.text = "จบละ 17 นาที"
                addSongToPlaylist(SongName: "dhammajak")
            } else if(speed > 1.5 ) {
                speed = 2
                SpeedSlider.setValue(speed, animated: false)
                Label1.text = "จบละ 12 นาที"
                addSongToPlaylist(SongName: "dhammajak12minutes")
            }
            Play(speed)
        }

    }
    
    @IBAction func RestartButtonAction(_ sender: Any) {
        let text = self.text_round.text
        ResetPlayer()
        self.text_round.text = text
        Label1.text =  ""
    }
    
    func addSongToPlaylist(SongName: String){
        songs = []
        let rounds = Int(Round.text!)!
        for _ in 0 ..< Int(rounds) {
            let url = Bundle.main.url(forResource: SongName, withExtension: "mp3")!
            let asset2 = AVAsset(url: url)
            let playerItem2 = AVPlayerItem(asset: asset2)
            
            songs = songs + [playerItem2]
        }
        
        
        self.qp = AVQueuePlayer.init(items: songs)
    
    }
    
    func Play(_ sp: Float){

        if #available(iOS 10.0, *) {
            addSongToPlaylist(SongName: "dhammajak")
            self.qp.playImmediately(atRate: sp)
            //Label1.text =  "กำลังสวด..."
        } else {
            if speed == 1{
                addSongToPlaylist(SongName: "dhammajak")
                Label1.text =  "กำลังสวด จบละ 17 นาที"
            } else {
                addSongToPlaylist(SongName: "dhammajak12minutes")
                Label1.text =  "กำลังสวด จบละ 12 นาที"
            }
            self.qp.addObserver(self, forKeyPath: "currentItem", options: NSKeyValueObservingOptions(), context: nil)
            self.qp.play()
        }
        
        isPlaying = 1;
        PlayButton.setImage(UIImage(named: "pause")?.withRenderingMode(.alwaysOriginal), for: .normal)
        RestartButton.isEnabled = true
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

