//
//  ViewController.swift
//  SOPT_5th
//
//  Created by 남수김 on 2019/11/16.
//  Copyright © 2019 ns. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userUniversityLabel: UILabel!
    @IBOutlet weak var userWritePostNumLabel: UILabel!
    @IBOutlet weak var userCommentNumLabel: UILabel!
    @IBOutlet weak var userScrapNumLabel: UILabel!
    @IBOutlet weak var userImageNumLabel: UIImageView!
    
    @IBOutlet weak var realTimeCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realTimeCollectionView.dataSource = self
        
        UserInformation.shared.userinfo{
            data in

            switch data{
            case.success(let object):
                let realData = object as! ResponseStringUserInfo
                
                self.userNameLabel.text = realData.data.userName
                self.userUniversityLabel.text = realData.data.userUniv
                self.userWritePostNumLabel.text = String(realData.data.postingCount)
                self.userCommentNumLabel.text = String (realData.data.commentCount)
                self.userScrapNumLabel.text = String (realData.data.scrapCount)
                
                guard let imageURL = URL(string: realData.data.userImage) else {return}
                do{
                    let imgData = try Data(contentsOf: imageURL)
                    self.userImageNumLabel.image = UIImage(data: imgData)
                }
                catch{
                    print("err")
                }
                
            case.networkFail:
                return
                
            default:
                return
            
            }
        }
        
    }
    @IBAction func moreBookMarkButtonClick(_ sender: Any) {
        print("즐겨찾는 게시판 더보기")
    }
    @IBAction func moreRealTimePostButtonClick(_ sender: Any) {
        print("실시간 인기글 더보기")
    }
    @IBAction func moreSchoolNewButtonClick(_ sender: Any) {
        print("교내소식 더보기")
    }
    
    
}

extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if realTimeCollectionView === collectionView{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RealTimeCell", for: indexPath) as? RealTimePopularCollectionViewCell else {fatalError("RealTime cell err")}
            
            cell.kindOfWriteLabel.text = "RealTime종류\(indexPath.item)"
            cell.userNameLabel.text = "사용자\(indexPath.item)"
            cell.dateLabel.text = "날짜\(indexPath.item)"
            cell.commentNumLabel.text = "\(indexPath.item)"
            cell.goodNumLabel.text = "\(indexPath.item)"
            cell.userCotentLabel.text = "내용\(indexPath.item)"
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.cornerRadius = 14
            cell.contentView.layer.borderColor = UIColor.whiteTwo.cgColor
            
            return cell
        }
        
        //var dataSet = [BoardPopular.DataClass]()
        
        return UICollectionViewCell()
        
    }
    
    
    
    
}

