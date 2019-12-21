//
//  MoviePlayerView.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/12/11.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit
import IJKMediaFramework
import SDWebImage

protocol PlayerProtocol:class {
    func playerStartPlay()
//    func playerStartPause()
//    func playerStartComplete()
}

class MoviePlayerView: UIView {

//    private weak var player:IJKFFMoviePlayerController!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var client: FishMainApi = FishMainApi()
    
    private var videoPlayerView:VideoPlayerView?
    
    var height:CGFloat = 200
    
//    private var attendToPlay = false
    private var isMax = false
    
    var deviceMac:String = "-"
//    private var selectCameraInfo:CameraInfoModel?
    
    var url:String?{
        didSet{
//            attendToPlay = false
            
            if let v = videoPlayerView {
//                p.shutdown()
//
//                p.view.removeFromSuperview()
//                v.removeAllObserver()
                v.removeFromSuperview()
            }
            
//            let options = IJKFFOptions.byDefault()
//            options?.setPlayerOptionIntValue(5, forKey: "framedrop")
//            player = IJKFFMoviePlayerController(contentURLString: url, with: options)
//
//
//            //播放页面视图宽高自适应
            let autoresize = UIViewAutoresizing.flexibleWidth.rawValue |
                UIViewAutoresizing.flexibleHeight.rawValue
//            player?.view.autoresizingMask = UIViewAutoresizing(rawValue: autoresize)
//
//            player?.view.frame = self.bounds
//            player?.shouldAutoplay = false
//            player?.scalingMode = .aspectFill //缩放模式
//            self.addSubview((player?.view)!)
            
            videoPlayerView = (Bundle.main.loadNibNamed("VideoPlayerView", owner: nil, options: nil)?.first as! VideoPlayerView)
            
            videoPlayerView?.autoresizingMask = UIViewAutoresizing(rawValue: autoresize)
            videoPlayerView?.frame = self.bounds
//            videoPlayerView?.player = player
//            videoPlayerView?.isMax(isMax)
            
            self.addSubview(videoPlayerView!)
            
            
            videoPlayerView?.mixOrMax = { [weak self] (isMax) in

                self?.isMax = isMax
                if (isMax) {//小屏->全屏
                    self?.enterFullScreen()
                } else {
                    self?.exitFullScreen()
                }
            }
            
//            if isAutoPlay {
//                player.prepareToPlay()
//            }
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initVideolayerView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
         initVideolayerView()
    }
    
    func initVideolayerView() {

        if let v = videoPlayerView {
            v.removeFromSuperview()
        }
        //            //播放页面视图宽高自适应
        let autoresize = UIViewAutoresizing.flexibleWidth.rawValue |
            UIViewAutoresizing.flexibleHeight.rawValue
        
        videoPlayerView = (Bundle.main.loadNibNamed("VideoPlayerView", owner: nil, options: nil)?.first as! VideoPlayerView)
        
        videoPlayerView?.autoresizingMask = UIViewAutoresizing(rawValue: autoresize)
        videoPlayerView?.frame = self.bounds
        //            videoPlayerView?.player = player
        //            videoPlayerView?.isMax(isMax)
        
        self.addSubview(videoPlayerView!)
        
        
        videoPlayerView?.mixOrMax = { [weak self] (isMax) in
            
            self?.isMax = isMax
            if (isMax) {//小屏->全屏
                self?.enterFullScreen()
            } else {
                self?.exitFullScreen()
            }
        }
    }
    
    
    
    
    /// MARK: 数据请求
    func startLoadData(deviceMac:String) {
        
        self.deviceMac = deviceMac
        
        self.client.getCamsConfig(params: ["device_mac":deviceMac]) { (data, error) in
            
            self.hiddenActivity()
            //            self.tableView?.mj_header?.endRefreshing()
            
            if let err = Parse.parseResponse(data, error) {
                self.makeHint(err.showMessage)
                return
            }
            if let d = data?.data {
                
                let usableCams:[CameraInfoModel] = d.usable_cams!
                
//                self.selectCameraInfo = usableCams[0]
//
//                let url = usableCams[0].preview_image
//
//                let selectedProfile = usableCams[0].profiles?.filter({ (model) -> Bool in
//                    return model.selected! == true
//                })
//
//                if let profile = selectedProfile , let selectedInfo = profile.first {
//                    self.url = selectedInfo.rtsp_url
//                }
//
//                self.videoPlayerView?.selectCameraInfo = self.selectCameraInfo
                self.videoPlayerView?.deviceMac = self.deviceMac
                self.videoPlayerView?.cameraInfos = usableCams
                
//                self.coverImageView()!.sd_setImage(with: URL(string: url!), placeholderImage: UIImage(named: "icon_logo"))
                
//                coverImageView()?.image = usableCams[0].preview_image
                
                
            } else {
                self.makeHint("数据获取失败，请稍后再试")
            }
            
        }
        
    }
    
    
    /// MARK: 页面操作
    
    var smallPreViewFrame =  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200)
    var smallPreToolViewFrame =  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200)
    
    //进入全屏模式
    func enterFullScreen() {
//        self.smallPreViewFrame = self.player.view.frame
//
//        let rectInWindow = self.player.view.convert(self.player.view.frame, to: UIApplication.shared.keyWindow)
//        self.player.view.removeFromSuperview()
//        self.player.view.frame = rectInWindow
        
        self.smallPreToolViewFrame = self.videoPlayerView!.frame
        
        let rectToolsInWindow = self.videoPlayerView!.convert(self.videoPlayerView!.frame, to: UIApplication.shared.keyWindow)
        self.videoPlayerView!.removeFromSuperview()
        self.videoPlayerView!.frame = rectToolsInWindow
        
        
//        UIApplication.shared.keyWindow?.addSubview(self.player.view)
        UIApplication.shared.keyWindow?.addSubview(self.videoPlayerView!)
        
        UIView.animate(withDuration: 0.5, animations: {
            
//            self.player.view.transform = self.player.view.transform.rotated(by: .pi / 2)
//            self.player.view.bounds = CGRect(x: 0, y: 0, width: max(SCREEN_WIDTH, SCREEN_HEIGHT), height: min(SCREEN_WIDTH, SCREEN_HEIGHT))
//            self.player.view.center = CGPoint(x: self.player.view.superview!.bounds.midX, y: self.player.view.superview!.bounds.midY)
         
            
            self.videoPlayerView?.transform =  (self.videoPlayerView?.transform.rotated(by: .pi / 2))!
            self.videoPlayerView?.bounds = CGRect(x: 0, y: 0, width: max(SCREEN_WIDTH, SCREEN_HEIGHT), height: min(SCREEN_WIDTH, SCREEN_HEIGHT))
            self.videoPlayerView?.center = CGPoint(x: self.videoPlayerView!.superview!.bounds.midX, y: self.videoPlayerView!.superview!.bounds.midY)
            
//            self.windowBgView?.transform =  (self.windowBgView?.transform.rotated(by: .pi / 2))!
//            self.windowBgView!.frame =  CGRect(x: 100, y: 100, width: max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height), height: min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height))
//            self.videoPlayerView?.transform =  (self.videoPlayerView?.transform.rotated(by: .pi / 2))!

//            self.videoPlayerView?.center = CGPoint(x: self.player.view.superview!.bounds.midX, y: self.player.view.superview!.bounds.midY)

        }) { (isFinished) in
            

        }
    }
    
    
    //退出全屏
    func exitFullScreen() {
        let frame = self.convert(self.smallPreViewFrame, to: UIApplication.shared.keyWindow)
        
        let toolFrame = self.convert(self.smallPreToolViewFrame, to: UIApplication.shared.keyWindow)
        
        UIView.animate(withDuration: 0.5, animations: {
//            self.player.view.transform = CGAffineTransform.identity
//            self.player.view.frame = frame
            
            self.videoPlayerView!.transform = CGAffineTransform.identity
            self.videoPlayerView!.frame = toolFrame
            
        }) { (isFinished) in
            
            // 回到小屏位置
//            self.player.view.removeFromSuperview()
//            self.player.view.frame = self.smallPreViewFrame
//            self.addSubview( self.player.view)
            
            self.videoPlayerView?.removeFromSuperview()
            self.videoPlayerView?.frame = self.smallPreToolViewFrame
            self.addSubview( self.videoPlayerView!)
            
        }
    }
    
    ///获取封面ImageView
    func coverImageView() -> UIImageView? {
        return videoPlayerView?.coverImageView();
    }
    
    var isAutoPlay = false

    ///是否自动播放
    func isAutoPlay(autoPlay:Bool)  {
        self.isAutoPlay = autoPlay
    }
    ///播放器代理
    weak var playerProtocol:PlayerProtocol?{
        didSet{
            videoPlayerView?.playerProtocol = playerProtocol
        }
    }

//    func play()  {
//        videoPlayerView?.playOrPause(isPlay:true)
//        //        player.prepareToPlay()
//    }
//    func pause()  {
//        videoPlayerView?.playOrPause(isPlay:false)
//        //        player.pause()
//    }
//    func shutDown()  {
//        player.shutdown()
//    }
    deinit {
        onDestory()
        print("PlayerViewController deinit")
    }
    
    //生命周期，必须要调用的
    private func onDestory() {
        //关闭播放器
//        guard let p = player else { return  }
//        p.shutdown()
        
//        videoPlayerView?.removeAllObserver()
    }

}
