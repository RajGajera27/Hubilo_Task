//
//  DetailViewController.swift
//  test
//
//  Created by Raj Gajera on 06/05/21.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var lblUrl: UILabel!
    @IBOutlet weak var lblDownloadingUrl: UILabel!
    @IBOutlet weak var lblHeight: UILabel!
    @IBOutlet weak var lblWidth: UILabel!
    @IBOutlet weak var btnBookMark: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Image Details"
        btnBookMark.image = UIImage(named: "bookmark")
        self.navigationItem.rightBarButtonItem = btnBookMark
    }
    
    @IBAction func btnBookMarkedPressed(sender: UIBarButtonItem) {
        
    }
    
}
