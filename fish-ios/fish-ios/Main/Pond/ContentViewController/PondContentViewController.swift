//
//  PondContentViewController.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/10/29.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit

class PondContentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView:UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        self.collectionView.register(UINib.init(nibName: "PondDeviceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: PondDeviceCollectionViewCellReuseID)
        
        let flayout = UICollectionViewFlowLayout()
        flayout.itemSize = self.itemSize()
        flayout.minimumInteritemSpacing = 0
        flayout.minimumLineSpacing = 10
        flayout.sectionInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
        flayout.scrollDirection = .vertical
        
        self.collectionView.collectionViewLayout = flayout
        
        
        self.collectionView.reloadData()
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
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        let count = self.count()
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PondDeviceCollectionViewCellReuseID, for: indexPath)
        
//        guard let eCell = cell as? KKAutoCollectionViewCell,   indexPath.row < count * KKAutoCycle, let models = self.privateImageModels else {
//            return cell
//        }
//        eCell.showData(models[indexPath.row % count])
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
