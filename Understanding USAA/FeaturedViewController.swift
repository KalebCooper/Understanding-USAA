//
//  FeaturedViewController.swift
//  Understanding USAA
//
//  Created by Kaleb Cooper on 7/19/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SwiftyJSON

class FeaturedViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    var slideshowProducts: [Product] = []
    var featuredProducts1: [Product] = []
    var featuredProducts2: [Product] = []
    var featuredProducts3: [Product] = []
    
    var URLToPass = ""
    var titleToPass = ""
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var collectionViewSlides: UICollectionView!
    @IBOutlet weak var collectionView1: UICollectionView!
    @IBOutlet weak var collectionView2: UICollectionView!
    @IBOutlet weak var collectionView3: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor(patternImage: UIImage(named: "bannerBackground")!)
        self.tableView.backgroundView = nil
//        self.tableView.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0)
        
        ref = Database.database().reference()
        
        //self.tableView.style = .grouped
        
        collectionViewSlides.delegate = self
        collectionViewSlides.dataSource = self
        
        collectionView1.delegate = self
        collectionView1.dataSource = self
        
        collectionView2.delegate = self
        collectionView2.dataSource = self
        
        collectionView3.delegate = self
        collectionView3.dataSource = self
        
        setupInitial()
        // Do any additional setup after loading the view.
    }
    
    
    
    
    func setupInitial() {
        
        
        let childRef = Database.database().reference(withPath: "profiles")
        
        
        childRef.observeSingleEvent(of: .value) { snapshot in
            
            //childRef.observe(.value, with: { snapshot in
            
            let json = JSON(snapshot.value)
            let profile = json[0]["products"]
            
            
            for (key, subJson) in profile {
                
                let icon = subJson["icon"].string!
                let title = subJson["title"].string!
                let url = subJson["url"].string!
                let category = subJson["category"].string!
                
                let product = Product()
                product.title = title
                product.image = UIImage(named: icon)
                product.url = url
                product.category = category
                
                print(title)
                
                if title.lowercased().contains("credit") || title.lowercased().contains("college") || title.lowercased().contains("auto") || title.lowercased().contains("moving") || title.lowercased().contains("pet") {
                    self.slideshowProducts.append(product)
                }
                if title.lowercased().contains("rental car") || title.lowercased().contains("cruise") || title.lowercased().contains("hotel") || title.lowercased().contains("boat") || title.lowercased().contains("flights") {
                    self.featuredProducts1.append(product)
                }
                if title.lowercased().contains("wealth") || title.lowercased().contains("mutual") || title.lowercased().contains("retirment") || title.lowercased().contains("stock") || title.lowercased().contains("portfolio") {
                    self.featuredProducts2.append(product)
                }
                if title.lowercased().contains("flood") || title.lowercased().contains("phone") || title.lowercased().contains("aviation") || title.lowercased().contains("moving") {
                    self.featuredProducts3.append(product)
                }
                

            }
            
            DispatchQueue.main.async {
                self.collectionViewSlides.reloadData()
                self.collectionView1.reloadData()
                self.collectionView2.reloadData()
                self.collectionView3.reloadData()
            }
            
            
        }
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 16, y: 0, width: tableView.frame.width - 32, height: 40))
        headerView.backgroundColor = UIColor.clear

        
        let label = UILabel(frame: headerView.frame)
        //label.contentView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        label.font = UIFont.boldSystemFont(ofSize: 24.0)
        label.textColor = UIColor(red: 18/255, green: 57/255, blue: 91/255, alpha: 1.0)
        label.textAlignment = .left
        
        
        if section == 0 {
            label.text = "Featured Products of the Day"
        }
        else if section == 1 {
            label.text = "Get ready for Summer!"
        }
        else if section == 2 {
            label.text = "Invest in your future!"
        }
        else if section == 3 {
            label.text = "Products you may not know we have!"
        }
        
        
        
        headerView.addSubview(label)
        return headerView
        
    }
    
    
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == collectionViewSlides {
            return slideshowProducts.count
        }
        else if collectionView == collectionView1 {
            return featuredProducts1.count
        }
        else if collectionView == collectionView2 {
            return featuredProducts2.count
        }
        else if collectionView == collectionView3 {
            return featuredProducts3.count
        }
        
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCollectionViewCell
        
        let item = indexPath.row
        
        if collectionView == collectionViewSlides {
            let product = slideshowProducts[item]
            
            cell.imageOutlet.image = product.image
            cell.titleOutlet.text = product.title
            
        }
        else if collectionView == collectionView1 {
            let product = featuredProducts1[item]
            
            cell.imageOutlet.image = product.image
            cell.titleOutlet.text = product.title
            
        }
        else if collectionView == collectionView2 {
            let product = featuredProducts2[item]
            
            cell.imageOutlet.image = product.image
            cell.titleOutlet.text = product.title
            
        }
        else if collectionView == collectionView3 {
            let product = featuredProducts3[item]
            
            cell.imageOutlet.image = product.image
            cell.titleOutlet.text = product.title
            
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == collectionViewSlides {
            let screenWidth = collectionView.bounds.width
            let scaleFactor = (screenWidth / 2) - 8
            
            return CGSize(width: screenWidth * 0.75, height: scaleFactor)
        }
        else {
            let screenWidth = collectionView.bounds.width
            let scaleFactor = (screenWidth / 2) - 8
            
            return CGSize(width: scaleFactor, height: scaleFactor)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == collectionViewSlides {
            
            let item = indexPath.row
            let product = slideshowProducts[item]
            
            self.URLToPass = product.url
            self.titleToPass = product.title
            
        }
        else if collectionView == collectionView1 {
            let item = indexPath.row
            let product = featuredProducts1[item]
            
            self.URLToPass = product.url
            self.titleToPass = product.title
            
        }
        else if collectionView == collectionView2 {
            let item = indexPath.row
            let product = featuredProducts2[item]
            
            self.URLToPass = product.url
            self.titleToPass = product.title
            
        }
        else if collectionView == collectionView3 {
            let item = indexPath.row
            let product = featuredProducts3[item]
            
            self.URLToPass = product.url
            self.titleToPass = product.title
            
        }

        self.performSegue(withIdentifier: "toWebViewSegue", sender: self)
        
    }
    
    

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let viewController = segue.destination as? WebViewController {
            print(self.URLToPass)
            print(self.titleToPass)
            
            viewController.importedURL = self.URLToPass
            viewController.importedTitle = self.titleToPass
        }
        
        
        
        
    }

}
