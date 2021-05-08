//
//  CustomCollectionViewCell.swift
//  Hubilo_Task
//
//  Created by Raj Gajera on 08/05/21.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    var data: ImageDetails? {
        didSet {
            if let dta = data {
                let width = Int(round((UIScreen.main.bounds.size.width-41)/3))
                let str = "https://picsum.photos/id/\(dta.id)/\(width)/155"
                imgView.downloadImageFrom(urlString: str, imageMode: .scaleAspectFit)
                lblName.text = dta.author
            }
        }
    }
    
    var offlineData: Detail? {
        didSet {
            if let dta = offlineData {
                if let imgdta = dta.imgData {
                    imgView.image = UIImage(data: imgdta)
                }
                lblName.text = dta.author
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
