//
//  CustomCollectionViewCell.swift
//  Understanding USAA
//
//  Created by Kaleb Cooper on 7/18/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var descriptionOutlet: UILabel!
    
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 8.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.masksToBounds = true

    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        var transform = CGAffineTransform.identity
//        transform = transform.scaledBy(x: 0.9, y: 0.9)
//        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
//            self.transform = transform
//        }, completion: nil)
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let transform = CGAffineTransform.identity
//        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
//            self.transform = transform
//        }, completion: nil)
//    }
//
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let transform = CGAffineTransform.identity
//        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
//            self.transform = transform
//        }, completion: nil)
//    }
    
}
