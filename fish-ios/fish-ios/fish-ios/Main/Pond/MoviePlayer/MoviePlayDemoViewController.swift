//
//  MoviePlayDemoViewController.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/12/10.
//  Copyright © 2019 caiwenshu. All rights reserved.
//



import UIKit
import IJKMediaFramework

class MoviePlayDemoViewController: UIViewController {
    var player:IJKFFMoviePlayerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let options = IJKFFOptions.byDefault()
        
        //视频源地址
        let url = NSURL(string: "rtsp://ed.ypcxpt.com/b827eb170977/1921688110/profile_2")
        //let url = NSURL(string: "http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8")
        
        //初始化播放器，播放在线视频或直播（RTMP）
        let player = IJKFFMoviePlayerController(contentURL: url as! URL, with: options)
        //播放页面视图宽高自适应
        let autoresize = UIViewAutoresizing.flexibleWidth.rawValue |
            UIViewAutoresizing.flexibleHeight.rawValue
        player?.view.autoresizingMask = UIViewAutoresizing(rawValue: autoresize)
        
        player?.view.frame = self.view.bounds
        player?.scalingMode = .aspectFit //缩放模式
        player?.shouldAutoplay = true //开启自动播放
        
        self.view.autoresizesSubviews = true
        self.view.addSubview((player?.view)!)
        self.player = player
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //开始播放
        self.player.prepareToPlay()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //关闭播放器
        self.player.shutdown()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

