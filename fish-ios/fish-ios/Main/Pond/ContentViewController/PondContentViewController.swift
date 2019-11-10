//
//  PondContentViewController.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/10/29.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit

import MJRefresh

let PondDeviceHeaderCollectionViewCellReuseID = "PondDeviceHeaderCollectionViewCellReuseID"

class PondContentViewController: FishPreViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView:UICollectionView!
    
    var pondSceneModel:PondSceneModel?
    
    var client: FishMainApi = FishMainApi()
    
    var ioDevicesList:[PondIOInfoModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.collectionView.register(UINib.init(nibName: "PondDeviceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: PondDeviceCollectionViewCellReuseID)
        
        self.collectionView.register(UINib.init(nibName: "PondDeviceHeaderCollectionViewCell", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: PondDeviceHeaderCollectionViewCellReuseID)
        
        let flayout = UICollectionViewFlowLayout()
        flayout.itemSize = self.itemSize()
        flayout.minimumInteritemSpacing = 0
        flayout.minimumLineSpacing = 10
        flayout.sectionInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
        flayout.scrollDirection = .vertical
        
        self.collectionView.collectionViewLayout = flayout
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(websocketNewDataNotification(nf:)), name: Notification.Name.FishWebSocketNotification, object: nil)
        
        
        self.collectionView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.collectionView.mj_header.endRefreshing()
             self.loadData()
        })
        
        self.loadData()
//        self.collectionView.reloadData()
    }
    
    func websocketNewDataNotification(nf: Notification) {
        guard let obj = nf.object else {
            return
        }
        
        
        // 只要接收到刷新都会刷新页面数据
        
        self.collectionView.reloadData()
        
//        if self.isViewLoaded && (self.view.window != nil) {
//           // viewController is visible
//            print ("PondContentViewController display")
//        }
        
        
        
    }
    
    
    func loadData() -> Void {
        
        self.client.getIOInfo(params: ["device_mac":pondSceneModel?.deviceMac], callBack: { (data, error) in
            
            if let err = Parse.parseResponse(data, error) {
                self.view.makeHint(err.showMessage)
                return
            }
            if let d = data?.data, !d.isEmpty {
                self.ioDevicesList = d
                var enableDevicesList:[PondIOInfoModel] = []
                for model in d {
                    if let enable = model.enabled {
                        if (enable) {
                            enableDevicesList.append(model)
                        }
                    }
                }
                self.ioDevicesList = enableDevicesList
                self.collectionView.reloadData()
            } else {
                self.view.makeHint("数据获取失败，请稍后再试")
            }
        })
        
    }

    private func itemSize() -> CGSize {
        /// 高度说明
        /// 1. collectionView 的高度就是行高，并且高度只与屏幕宽度有关，与数据无关
        /// 2. collectionView 的 itemSize.height 就是行高
        /// 3. collectionView item label height: 17 marginTop:8 marginBottom: 8
        /// 4. collectionView item topView marginTop:12 width/height: 9/8 marginLeft: 8 marginRight: 8
        /// 5. collectionView sectionInset left: 20, right: 20 padding: 10
        
        /// 单个 item 宽度 = (屏幕宽度 - 2 * sectionInset.left - 2 * padding) / 2.0
        let itemWidth: CGFloat = (SCREEN_WIDTH - 20 - 2 * 10) / 3
        
//        /// item 中图片的宽度
//        let itemImageWidth: CGFloat = itemWidth - 2 * 8
//
//        /// item 图片高度
//        let itemImageHeight: CGFloat = itemImageWidth * 8.0 / 9.0
//
        /// item 高度 = 图片高度 + 图片 marginTop + label marginTop + label height + label marginBottom
        let itemHeight: CGFloat = itemWidth * 4.0 / 3.0
        
        /// 数字计算多少存在差异，放置高度大于行高
        return CGSize.init(width: itemWidth, height: itemHeight - 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - CollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView:UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: PondDeviceHeaderCollectionViewCellReuseID, for: indexPath)
        
        guard let eReusableView = reusableView as? PondDeviceHeaderCollectionViewCell,
            let deviceMac = pondSceneModel?.deviceMac else {
            return reusableView
        }
        eReusableView.reloadData(deviceMac:deviceMac)
        return eReusableView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        
        return CGSize(width: SCREEN_WIDTH, height: 354)
    }
    
//    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {

//    }
    
//    - (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//
//    UICollectionReusableView *reusableView = nil;
//    if (kind == UICollectionElementKindSectionHeader) {       //头视图
//    _headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
//    reusableView = _headerView;
//    }else if (kind == UICollectionElementKindSectionFooter) {    //尾视图
//    _footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer" forIndexPath:indexPath];
//    _footerView.delegate = self;
//    reusableView = _footerView;
//    }
//    return reusableView;
//    }
//
//    - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    return CGSizeMake(头视图的宽, 头视图的高);
//    }

    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.ioDevicesList.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        let count = self.count()
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PondDeviceCollectionViewCellReuseID, for: indexPath)
        
        
        guard let eCell = cell as? PondDeviceCollectionViewCell, let deviceMac = pondSceneModel?.deviceMac else {
            return cell
        }
//        guard let eCell = cell as? KKAutoCollectionViewCell,   indexPath.row < count * KKAutoCycle, let models = self.privateImageModels else {
//            return cell
//        }
        eCell.showData(model: self.ioDevicesList[indexPath.row], deviceMac:deviceMac)
        return cell
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
