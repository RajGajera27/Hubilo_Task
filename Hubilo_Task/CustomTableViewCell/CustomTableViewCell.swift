//
//  CustomTableViewCell.swift
//  Hubilo_Task
//
//  Created by Raj Gajera on 08/05/21.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var containerView: UIView!
    var data: ImageDetails? {
        didSet {
            if let dta = data {
                
                let str = "https://picsum.photos/id/\(dta.id)/100"
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
        containerView.dropShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
