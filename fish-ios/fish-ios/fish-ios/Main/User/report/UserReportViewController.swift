//
//  UserReportViewController.swift
//  fish-ios
//
//  Created by caiwenshu on 2019/12/19.
//  Copyright © 2019 caiwenshu. All rights reserved.
//

import UIKit

class UserReportViewController : FishPreViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView:UICollectionView!
    
    var itemData = [["icon" : "icon_index_trend.png", "name" : "指标趋势", "type" : "indexTrend"],
                         ["icon" : "icon_weight_report.png", "name" : "饲料消耗趋势", "type" : "weightReport"],
                         ["icon" : "icon_power_report.png", "name" : "用电量报表", "type" : "powerReport"],
                         ["icon" : "icon_o2_report.png", "name" : "增氧报表", "type" : "o2Report"],
                         ["icon" : "icon_event.png", "name" : "所有事件", "type" : "event"]]
    
    
    var needNavigationBarAnimation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "报表"
        // Do any additional setup after loading the view.
        
        self.collectionView.register(UINib.init(nibName: "UserReportCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: UserReportCollectionViewCellReuseID)
        
        let flayout = UICollectionViewFlowLayout()
        flayout.itemSize = self.itemSize()
        flayout.minimumInteritemSpacing = 0
        flayout.minimumLineSpacing = 10
        flayout.sectionInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 0, right: 10)
        flayout.scrollDirection = .vertical
        
        self.collectionView.collectionViewLayout = flayout
        
        needNavigationBarAnimation = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
////        self.navigationController?.navigationBar.isHidden = false
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
//    }
    
    
    
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

    
    // MARK: - CollectionViewDelegate

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
//
//        return CGSize(width: SCREEN_WIDTH, height: 354)
//    }
    
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
        return self.itemData.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //        let count = self.count()
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserReportCollectionViewCellReuseID, for: indexPath)
        
        
        guard let eCell = cell as? UserReportCollectionViewCell else {
            return cell
        }
        //        guard let eCell = cell as? KKAutoCollectionViewCell,   indexPath.row < count * KKAutoCycle, let models = self.privateImageModels else {
        //            return cell
        //        }
        eCell.showData(model: self.itemData[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        let selectedData = self.itemData[indexPath.row]
        
        if selectedData["type"] == "indexTrend" {
            
            let indexTrendVC = ReportIndexTrendViewController()
            self.navigationController?.pushViewController(indexTrendVC, animated: true)
            
        }
        
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
