//
//  DetailViewController.swift
//  Hubilo_Task
//
//  Created by Raj Gajera on 08/05/21.
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
    var imgInfo: ImageDetails?
    var offlineData: Detail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Image Details"
        btnBookMark.image = UIImage(named: "bookmark")
        self.navigationItem.rightBarButtonItem = btnBookMark
        
        if (AppDelegate.shared.isInternetAvailable) {
            if let info = imgInfo {
                
                let width = Int(round((UIScreen.main.bounds.size.width)))
                let str = "https://picsum.photos/id/\(info.id)/\(width)/250"
                imgView.downloadImageFrom(urlString: str, imageMode: .scaleAspectFit)
                lblAuthor.text = "Author Name - \(info.author)"
                lblDownloadingUrl.text = "Downloading URL - \(info.downloadURL)"
                lblUrl.text = "Info URL - \(info.url)"
                lblWidth.text = "Image Width - \(info.width)"
                lblHeight.text = "Image Height - \(info.height)"
                
                if AppDelegate.shared.arrBookMarkIds.contains(info.id) {
                    btnBookMark.image = UIImage(named: "bookmarked")
                }
                else {
                    btnBookMark.image = UIImage(named: "bookmark")
                }
                
                let defaults = UserDefaults.standard
                let arrBookMarked = defaults.stringArray(forKey: "SavedBookMarkrdArray") ?? [String]()

                if arrBookMarked.contains(info.id ) {
                    btnBookMark.image = UIImage(named: "bookmarked")
                }
                else {
                    btnBookMark.image = UIImage(named: "bookmark")
                }
                
            }
            
        } else {
            if let info = offlineData {
                let width = Int(round((UIScreen.main.bounds.size.width)))
                let str = "https://picsum.photos/id/\(info.id ?? "")/\(width)/250"
                imgView.downloadImageFrom(urlString: str, imageMode: .scaleAspectFit)
                if let imgdta = info.imgData {
                    imgView.image = UIImage(data: imgdta)
                }
                lblAuthor.text = "Author Name - \(info.author ?? "")"
                lblDownloadingUrl.text = "Downloading URL - \(info.downloadURL ?? "")"
                lblUrl.text = "Info URL - \(info.url ?? "")"
                lblWidth.text = "Image Width - \(info.width)"
                lblHeight.text = "Image Height - \(info.height)"
                let defaults = UserDefaults.standard
                let arrBookMarked = defaults.stringArray(forKey: "SavedBookMarkrdArray") ?? [String]()

                if arrBookMarked.contains(info.id ?? "") {
                    btnBookMark.image = UIImage(named: "bookmarked")
                }
                else {
                    btnBookMark.image = UIImage(named: "bookmark")
                }
            }
        }
    }
    
    @IBAction func btnBookMarkedPressed(sender: UIBarButtonItem) {
        
        
        if (AppDelegate.shared.isInternetAvailable) {
        
        if AppDelegate.shared.arrBookMarkIds.contains(imgInfo?.id ?? "") {
            btnBookMark.image = UIImage(named: "bookmark")
            AppDelegate.shared.arrBookMarkIds = AppDelegate.shared.arrBookMarkIds.filter { $0 != imgInfo?.id ?? ""}
            print(AppDelegate.shared.arrBookMarkIds)
        }
        else {
            btnBookMark.image = UIImage(named: "bookmarked")
            AppDelegate.shared.arrBookMarkIds.append(imgInfo?.id ?? "")
            print(AppDelegate.shared.arrBookMarkIds)
        }
        }
        else {
            if AppDelegate.shared.arrBookMarkIds.contains(offlineData?.id ?? "") {
                btnBookMark.image = UIImage(named: "bookmark")
                AppDelegate.shared.arrBookMarkIds = AppDelegate.shared.arrBookMarkIds.filter { $0 != offlineData?.id ?? ""}
                print(AppDelegate.shared.arrBookMarkIds)
            }
            else {
                btnBookMark.image = UIImage(named: "bookmarked")
                AppDelegate.shared.arrBookMarkIds.append(offlineData?.id ?? "")
                print(AppDelegate.shared.arrBookMarkIds)
            }
        }
        
        let defaults = UserDefaults.standard
        defaults.set(AppDelegate.shared.arrBookMarkIds, forKey: "SavedBookMarkrdArray")
        print(AppDelegate.shared.arrBookMarkIds)
        
    }
    
}
