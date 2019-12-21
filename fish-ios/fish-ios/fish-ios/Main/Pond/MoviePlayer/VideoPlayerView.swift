//
//  VideoPlayerView.swift
//  BeiVideo
//
//  Created by 李利锋 on 2017/7/19.
//  Copyright © 2017年 leefeng. All rights reserved.
//

import UIKit
import IJKMediaFramework
import SDWebImage

class VideoPlayerView: UIView {
    
    weak var playerProtocol:PlayerProtocol?

    var mixOrMax:((_ isMax:Bool)->())?
    @IBOutlet weak var playView: UIView!
 
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var imageViewCover: UIImageView!
    @IBOutlet weak var buttonPlay: UIButton!
    
    // 停止按钮
    @IBOutlet weak var buttonStop: UIButton!
    @IBOutlet weak var viewBottom: UIView!

    @IBOutlet weak var loadviewbg: UIView!
    @IBOutlet weak var loadviewbac: UIView!

    @IBOutlet weak var loadview: UIActivityIndicatorView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var deviceMac:String = "-"
    
    var client: FishMainApi = FishMainApi()
    var selectCameraInfo:CameraInfoModel?
    
    var camerasViewArray:[CameraButton] = []
    var cameraInfos:[CameraInfoModel]? {
        didSet{
            camerasViewArray.removeAll()
            
            for cameraInfo in cameraInfos! {
                
                let button = CameraButton.init(type: .custom)
                button.setImage(UIImage(named: "launchNew.png"), for: .normal)
                button.addTarget(self, action: #selector(cameraButtonClick(_:)), for: .touchUpInside)
                var x:Int = 20
                if camerasViewArray.count > 0 {
                    x = 10 + Int(camerasViewArray.last!.frame.maxX)
                }
                
                button.cameraInfo = cameraInfo
                button.frame = CGRect(x: x, y: 4, width: 36, height: 36)
//                button.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.flexibleLeftMargin.rawValue)
                
                camerasViewArray.append(button)
                
                self.viewBottom.addSubview(button)
                
            }
            
            if cameraInfos?.count ?? 0 > 0 {
                self.selectCameraInfo = cameraInfos?.first
                
                if let url = self.selectCameraInfo?.preview_image {
                    
                    self.imageViewCover.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "icon_logo"))
                }
                
            }
            
        }
    }

    func cameraButtonClick(_ sender: CameraButton) {
        
        if self.selectCameraInfo?.key == sender.cameraInfo?.key {
            return
        }
        
        self.selectCameraInfo = sender.cameraInfo
        self.player?.stop()
        
        if let url = self.selectCameraInfo?.preview_image {
            
             self.imageViewCover.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "icon_logo"))
        }
       
        self.playCamera()
        
    }
    
    @IBOutlet weak var buttonMax: UIButton!
    
    var delaytask:Task?
    
    @IBAction func buttonBackClick(_ sender: Any) {
        if buttonMax.isSelected {
            clickMax(buttonMax)
        }
    }
   
//    var timer:Timer?
    
    var player:IJKFFMoviePlayerController?
    
    func initPlayerView(url:String) {
        
        if let p = player {
            p.shutdown()
            removeAllObserver()
            p.view.removeFromSuperview()
        }
        
        IJKFFMoviePlayerController.setLogLevel(k_IJK_LOG_DEBUG)
        let options = IJKFFOptions.byDefault()
        options?.setPlayerOptionIntValue(5, forKey: "framedrop")
        player = IJKFFMoviePlayerController(contentURLString: url, with: options)
        
        //播放页面视图宽高自适应
        let autoresize = UIViewAutoresizing.flexibleWidth.rawValue |
            UIViewAutoresizing.flexibleHeight.rawValue
        player?.view.autoresizingMask = UIViewAutoresizing(rawValue: autoresize)
        
        player?.view.frame = self.bounds
        player?.shouldAutoplay = false
        player?.scalingMode = .aspectFit //缩放模式
        
        self.insertSubview((player?.view)!, belowSubview: self.imageViewCover)
        
        buttonPlay.isHidden = false
        
        initPlayerObservers()
        
    }

    func removeAllObserver() {
         print("VideoPlayerView removeAllObserver")
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit {
         removeAllObserver()
         print("VideoPlayerView deinit")
    }
    
    func initPlayerObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(moviePlayBackStateDidChange), name: NSNotification.Name.IJKMPMoviePlayerPlaybackStateDidChange, object: player)
    
        NotificationCenter.default.addObserver(self, selector: #selector(mediaIsPreparedToPlayDidChange), name: NSNotification.Name.IJKMPMediaPlaybackIsPreparedToPlayDidChange, object: player)
        
        NotificationCenter.default.addObserver(self, selector: #selector(moviePlayBackFinish), name: NSNotification.Name.IJKMPMoviePlayerPlaybackDidFinish, object: player)
        NotificationCenter.default.addObserver(self, selector: #selector(loadStateDidChange), name: NSNotification.Name.IJKMPMoviePlayerLoadStateDidChange, object: player)
    }
    
    func loadStateDidChange()  {
        let loadState = player?.loadState.rawValue

        print("loadStateDidChange:\(loadState)")
//        IJKMPMovieLoadState
        if loadState == 3 {
            showLoadView(isHidden: true)
            if !(player?.isPlaying())! {
                buttonPlay.isHidden = false
            }
        }else if loadState == 4 {
            showLoadView(isHidden: false)
        }

    }
    
    func moviePlayBackFinish(notifycation:Notification)  {
        
       let l = notifycation.userInfo?[IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] as! Int
        
        switch (l) {
        case 0:
           break
            
        case 2:

            break
            
        case 1:
            print("播放错误，需要重新播放：\(l)")
            self.makeHint("播放失败,请重试")
//            canTouch = false
            self.showCoverStatusView()
            break
        default:
            break
        }
    }
    
    func mediaIsPreparedToPlayDidChange() {
        print("状态状态:mediaIsPreparedToPlayDidChange")
        
        self.player?.play()
        
        showPlayView(isHidden: false)
        showLoadView(isHidden: true)
        
    }
    
    func moviePlayBackStateDidChange()  {

//        canTouch = true
         //播放 1  暂停2  播放完成 0 (移除暂停逻辑)
        print("状态状态：\(player?.playbackState.rawValue)")
        switch player?.playbackState.rawValue ?? 0 {

        case 1:
            self.showPlayStatusView()
            playerProtocol?.playerStartPlay()
            break
            
        case 4:
            if !loadview.isAnimating {
                showLoadView(isHidden: false)
            }
            break
        default:
            break
            
        }
       
    }
    
    ///是否开启菊花
    func showLoadView(isHidden:Bool)  {
        loadviewbac.isHidden = isHidden
        loadviewbg.isHidden = isHidden
        
        if isHidden {
             loadview.stopAnimating()
        }else{
             loadview.startAnimating()
//             buttonPlay.isHidden = true
        }
       
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        viewBottom.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)

        loadviewbac.layer.cornerRadius = 10
        loadviewbac.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.8)

        loadview.startAnimating()

        showPlayView(isHidden: false)
        showLoadView(isHidden: true)
        
        imageViewCover.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

    }
    
    //播放按钮点击
    @IBAction func clickPlay(_ sender: Any) {
        
        // {"device_mac":"{{device_mac}}","cam_key":"1921688110"}
       self.playCamera()

    }
    
    //停止播放
    @IBAction func clickStop(_ sender: Any) {
        
        // {"device_mac":"{{device_mac}}","cam_key":"1921688110"}
         self.player?.stop()
         showCoverStatusView()
    }
    
    //点击全屏按钮
    @IBAction func clickMax(_ sender: UIButton) {
      
        buttonBack.isHidden = sender.isSelected
        sender.isSelected = !sender.isSelected
        mixOrMax?(sender.isSelected)

    }
    
    // 播放视频
    func playCamera() {
        self.showPlayView(isHidden: true)
        self.showLoadView(isHidden: false)
        
        self.client.getCamsPlay(params: ["device_mac":self.deviceMac, "cam_key":self.selectCameraInfo?.key ?? "-"]) { (data, error) in
            
            if let err = Parse.parseResponse(data, error) {
                self.makeHint(err.showMessage)
                self.showLoadView(isHidden: true)
                return
            }
            if let code = data?.code {
                if code == 1000 {
                    let selectedProfile = self.selectCameraInfo?.profiles?.filter({ (model) -> Bool in
                        return model.selected! == true
                    })
                    
                    if let profile = selectedProfile , let selectedInfo = profile.first {
                        let url = selectedInfo.rtsp_url
                        
                        KKSafeMain {
                            self.initPlayerView(url: url!)
                            
                            _ = leefeng_delay(2, task: {
                                if !(self.player?.isPlaying())! {
                                    self.showLoadView(isHidden: false)
                                    self.player?.prepareToPlay()
                                }
                            })
                        }
                    }
                    
                } else {
                    self.makeHint("播放失败,请稍后再试")
                    self.showLoadView(isHidden: true)
                }
            } else {
                self.makeHint("播放失败,请稍后再试")
                self.showLoadView(isHidden: true)
            }
            
        }
    }
    
    // 展示封面和播放按钮
    func showCoverStatusView() {
        buttonPlay.isHidden = false
        self.showLoadView(isHidden: true)
        self.imageViewCover.isHidden = false
    }
    
    
    func showPlayStatusView() {
        self.imageViewCover.isHidden = true
        self.showPlayView(isHidden: true)
        self.showLoadView(isHidden:true)
        
    }

    private func showPlayView(isHidden:Bool){
        
        buttonPlay.isHidden = isHidden

    }
    
    func coverImageView() -> UIImageView {
        return imageViewCover
    }

}

class CameraButton: UIButton {
    var cameraInfo:CameraInfoModel?
}
