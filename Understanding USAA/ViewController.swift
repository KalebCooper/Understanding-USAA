//
//  ViewController.swift
//  Understanding USAA
//
//  Created by Kaleb Cooper on 7/18/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import UIKit
import SwiftyJSON
import FirebaseDatabase

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterOutlet: UIButton!
    @IBOutlet weak var categoryOutlet: UIButton!
    
    @IBAction func filterAction(_ sender: Any) {
    }
    @IBAction func categoryAction(_ sender: Any) {
    }
    
    var URLToPass = ""
    var titleToPass = ""
    var searchResult = ""
    
    var ref: DatabaseReference!
    var products: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ref = Database.database().reference()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.keyboardDismissMode = .interactive
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(noti:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        setupInitial()
        getProducts()
    }
    
    @objc func keyboardWillHide(noti: Notification) {
        let contentInsets = UIEdgeInsets.zero
        self.collectionView.contentInset = contentInsets
        self.collectionView.scrollIndicatorInsets = contentInsets
    }
    
    
    @objc func keyboardWillShow(noti: Notification) {
        
        guard let userInfo = noti.userInfo else { return }
        guard var keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.collectionView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.collectionView.contentInset = contentInset
    }
    
    func getProducts() {
        
        setupChildChanged()
        
    }
        
        
    func setupInitial() {
        
        products.removeAll()
        let childRef = Database.database().reference(withPath: "products")
        
        
        childRef.observeSingleEvent(of: .value) { snapshot in
            
        //childRef.observe(.value, with: { snapshot in
            
            let json = JSON(snapshot.value)
            
            
            for (key, subJson) in json {
                
                let icon = subJson["icon"].string!
                let title = subJson["title"].string!
                let url = subJson["url"].string!
                let category = subJson["category"].string!

                if title.lowercased().contains(self.searchResult.lowercased()) || self.searchResult == "" || category.lowercased().contains(self.searchResult.lowercased()) {
                    
                    let product = Product()
                    product.title = title
                    product.image = UIImage(named: icon)
                    product.url = url
                    product.category = category
                    
                    self.products.append(product)
                    
                    print("RUNNING SETUP INITIAL AGAINNN")
                }
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
            
        }
        
        
    }
    
    
    func setupChildChanged() {
        
        print(self.products.count)


        let childRef = Database.database().reference(withPath: "products")

        childRef.observe(.childChanged, with: { snapshot in

            

            let json = JSON(snapshot.value)
            
            print(json)
            
            print(snapshot.key)
            
            let icon = json["icon"].string!
            let title = json["title"].string!
            let url = json["url"].string!
            let category = json["category"].string!
            
            print(self.products.count)
            
            if title.lowercased().contains(self.searchResult.lowercased()) || self.searchResult == "" || category.lowercased().contains(self.searchResult.lowercased()) {
                
                print(self.products[Int(snapshot.key)!].title)
                
                let product = self.products[Int(snapshot.key)!]
                product.title = title
                product.image = UIImage(named: icon)
                product.url = url
                product.category = category
                
                print(self.products[Int(snapshot.key)!].title)
                
                print(self.products.count)
            }

            DispatchQueue.main.async {
                self.collectionView.reloadItems(at: [IndexPath(row: Int(snapshot.key)!, section: 0)])
            }


        })

    }
    
        
        
//        if let path = Bundle.main.path(forResource: "products", ofType: "json") {
//
//            do {
//                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
//
//                let jsonData = try JSON(data: data)
//
//                for (key, subJson) in jsonData["products"] {
//
//                    let icon = subJson["icon"].string!
//                    let title = subJson["title"].string!
//                    let url = subJson["url"].string!
//                    let category = subJson["category"].string!
//
//                    if title.lowercased().contains(self.searchResult.lowercased()) || self.searchResult == "" || category.lowercased().contains(self.searchResult.lowercased()) {
//
//                        let product = Product()
//                        product.title = title
//                        product.image = UIImage(named: icon)
//                        product.url = url
//                        product.category = category
//
//                        products.append(product)
//                    }
//                }
//
//                DispatchQueue.main.async {
//                    self.collectionView.reloadData()
//                }
//
//
//            }
//            catch let error {
//                print("parse error: \(error.localizedDescription)")
//            }
//
//        }
        
//    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchResult = searchText
        
        getProducts()
        
        
    }
    
    
    
    //Collection View Code
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCollectionViewCell
        
        let item = indexPath.row
        
        let product = products[item]
        
        cell.imageOutlet.image = product.image
        cell.titleOutlet.text = product.title
        
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("Testing")
        
        let item = indexPath.row
        
        let product = products[item]
        
        self.URLToPass = product.url
        self.titleToPass = product.title
        
        self.performSegue(withIdentifier: "toWebViewSegue", sender: self)
        
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let yourWidth = (collectionView.bounds.width / 2.0) - 16
//        let yourHeight = yourWidth
//
//        return CGSize(width: yourWidth, height: yourHeight)
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//
//        return UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
////        return UIEdgeInsets.zero
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.bounds.width
        let scaleFactor = (screenWidth / 2) - 6
        
        return CGSize(width: scaleFactor, height: scaleFactor)
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

