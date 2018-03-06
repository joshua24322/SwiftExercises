//
//  RestaurantDetailViewController.swift
//  FoodPin
//
//  Created by 張書彬 on 2018/2/21.
//  Copyright © 2018年 Joshua Chang. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

//    @IBOutlet weak var restaurantImageView: UIImageView!
    
//    //            12.9 Solution to Exercise
//    @IBOutlet weak var nameLblDetail: UILabel!
//    @IBOutlet weak var locationLblDetail: UILabel!
//    @IBOutlet weak var typeLblDetail: UILabel!
//
//    var restaurantImageName = ""
//    var restaurantDetailName = ""
//    var restaurantDetailLocation = ""
//    var restaurantDetailType = ""
    
    
    // MARK: - Properties
    /*
     當使用者選取表格中的餐廳時，
     需要有一個可以將圖片名稱傳遞到RestaurantDetailViewController的方式。
     這個變數將用來作為資料傳遞用。
     */
    var restaurant: Restaurant = Restaurant()
    
    @IBOutlet weak var tableView: UITableView! //表格視圖的變數
    @IBOutlet weak var headerView: RestaurantDetailHeaderView! //頭部視圖的變數
    
    // MARK: - View controller life style
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        restaurantImageView.image = UIImage(named: restaurant.image) //將視圖的圖片設定為所選餐廳的圖片。
//        //            12.9 Solution to Exercise
//        nameLblDetail.text = restaurant.name
//        locationLblDetail.text = restaurant.location
//        typeLblDetail.text = restaurant.type
        
        navigationItem.largeTitleDisplayMode = .never //停用RestaurantDetailViewController的大標題

        //Configure the headerView...
        headerView.nameLabel.text = restaurant.name
        headerView.typeLabel.text = restaurant.type
        headerView.headerImageView.image = UIImage(named: restaurant.image)
        headerView.heartImageView.isHidden = (restaurant.isVisited) ? false : true
        // isVisited的預設值是false，判斷若isVisited是true的時候、isHidden的條件就設定為false;
        // 判斷若isVisited是false的時候、isHidden的條件就設定為true

        // Configure the table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none //移除表格所有的分隔符號
        tableView.contentInsetAdjustmentBehavior = .never // tableView top constrains must align to superview
        /*
         Configure the behavior of adjustedContentInset.
         Default is UIScrollViewContentInsetAdjustmentAutomatic.
         */
        // iOS11棄用 automaticallyAdjustsScrollViewInsets 屬性，新增 contentInsetAdjustmentBehavior 來取代

        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
        navigationController?.hidesBarsOnSwipe = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDataSource Protocol
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
            /*
             Syntax: String(describing: someValue)
             由於寫死cell的識別馬容易填錯字，且識別碼(identified)輸入錯誤xcode不會回報錯誤。
             因此導入String(describing: someValue)語法，初始化並直接引用其他型別(String)來賦予值，
             這樣xcode就會檢查物件名稱(someValue)是否輸入正確，有錯字就會回報。
             */
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailIconTextCell.self), for: indexPath) as! RestaurantDetailIconTextCell
            cell.iconImageView.image = UIImage(named: "phone")
            cell.shortTextLabel.text = restaurant.phone
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailIconTextCell.self), for: indexPath) as! RestaurantDetailIconTextCell
            cell.iconImageView.image = UIImage(named: "map")
            cell.shortTextLabel.text = restaurant.location
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailTextCell.self), for: indexPath) as! RestaurantDetailTextCell
            cell.descriptionLabel.text = restaurant.description
            
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailSeparatorCell.self), for: indexPath) as! RestaurantDetailSeparatorCell
            cell.titleLabel.text = "HOW TO GET HERE"
            
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailMapCell.self), for: indexPath) as! RestaurantDetailMapCell
            cell.configure(location: restaurant.location)
            
            return cell
        default:
            fatalError("Failed to instantiate the table view cell for detail view controller")
        }
    }

    // MARK: - Status Bar
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMap" {
            let destinationController = segue.destination as! MapViewController
            destinationController.restaurant = restaurant
            
        }
        if segue.identifier == "showReview" {
            let destinationController = segue.destination as! ReviewViewController
            destinationController.restaurant = restaurant
        }
    }
    
    //MARK: - Unwind segue
    @IBAction func close(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func ratingRestaurant(segue: UIStoryboardSegue) {
        dismiss(animated: true) {
            if let rating = segue.identifier {
                self.restaurant.rating = rating
                self.headerView.ratingImageView.image = UIImage(named: rating)
                
                // 實作仿射變形 (Affine Transformation) 動畫效果
                let scaleTransform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
                self.headerView.ratingImageView.transform = scaleTransform
                self.headerView.ratingImageView.alpha = 0
                
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.7, options: [], animations: {
                    self.headerView.ratingImageView.transform = .identity
                    self.headerView.ratingImageView.alpha = 1
                }, completion: nil)
            }
        }
    }

}
