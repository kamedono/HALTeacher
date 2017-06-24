//
//  BGMManager.swift
//  SlideMenuControllerSwift_Test
//
//  Created by sotuken on 2015/08/26.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import UIKit
import AVFoundation

class BGMManager :NSObject, AVAudioPlayerDelegate{
    //シングルトン作成
    static var bgmManagerInstance = BGMManager()
    
    //ユーザデフォルトの設定
    let defaults = NSUserDefaults.standardUserDefaults()
    
    // BGMの取得・設定
    var selectMusic: String? {
        get { return defaults.stringForKey("quizBGM") ?? "てってって"  }
        set { defaults.setObject(newValue, forKey: "quizBGM") }
    }
    
    var audioPlayer: AVAudioPlayer?
    
    
    /*
    音楽の再生
    */
    func playMusic(){
        println("選んだ曲\(self.selectMusic)")
        if selectMusic != "なし" {
            //曲を探す
            let audioPath = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(selectMusic, ofType: "mp3")!)
            var audioError:NSError?
            
            audioPlayer = AVAudioPlayer(contentsOfURL: audioPath, error:&audioError)
            audioPlayer!.delegate = self
            
            //曲をセット
            audioPlayer!.prepareToPlay()
            
            //再生
            audioPlayer!.play()
            
            //ループ数指定(無限ループよおお)
            audioPlayer!.numberOfLoops = -1
        }
    }
    
    /*
    音楽の停止
    */
    func stopMusic() {
        if selectMusic != "なし" && self.audioPlayer != nil {
            self.audioPlayer!.stop()
        }
    }
    
}