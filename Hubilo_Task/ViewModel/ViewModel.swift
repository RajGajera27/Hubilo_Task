//
//  ViewModel.swift
//  Hubilo_Task
//
//  Created by Raj Gajera on 08/05/21.
//

import Foundation
import UIKit
import CoreData

protocol ImageListViewModelDelegate: class {
    func APISuccess()
    func APIFailure(message: String)
}

class ImageListViewModel {
    
    var arrData = [ImageDetails]()
    var offlineData = [Detail]()
    var offlineOriganlData = [Detail]()
    var originalData = [ImageDetails]()
    var currentPage = 0
    weak var delegate: ImageListViewModelDelegate?
    var isAPICalling = false
    var searchText: String = "" {
        didSet {
            filterData()
        }
    }
    var isInternet = true
    
    init(_ imageListDelegate: ImageListViewModelDelegate) {
        delegate = imageListDelegate
        getImageData(page: currentPage, limit: 10)
    }
    
    // MARK: - Json Parsing (API Call)
    func getImageData(page: Int, limit: Int) {
        isAPICalling = true
        guard let url = URL(string: "https://picsum.photos/v2/list?page=\(page)&limit=\(limit)") else {return}
        print(url.absoluteURL)
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                  error == nil else {
                print(error?.localizedDescription ?? "Response Error")
                
                if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet
                {
                    self.isInternet = false
                }
                else {
                    self.isInternet = true
                }
                return
                
            }
            do{
                
                let jsonResponse = try JSONSerialization.jsonObject(with:
                                                                        dataResponse, options: [])
                print(jsonResponse)
                let JsonData = try JSONSerialization.data(withJSONObject: jsonResponse, options: JSONSerialization.WritingOptions.prettyPrinted)
                guard let jsonArray = jsonResponse as? [[String: Any]] else {
                    return
                }
                let dictData = try JSONDecoder().decode([ImageDetails].self, from: JsonData)
                if page == 0 {
                    DispatchQueue.main.async {
                        self.clearData()
                    }
                    self.originalData.removeAll()
                }
                self.originalData.append(contentsOf: dictData)
                DispatchQueue.main.async {
                    self.saveData(imgData: jsonArray)
                    self.filterData()
                    self.delegate?.APISuccess()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.isAPICalling = false
                }
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
        
    }
    
    // MARK: data save in database (CoreData)
    
    func saveData(imgData: [[String:Any]]) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        for i in 0..<imgData.count {
            let detail = Detail(context: appDelegate.persistentContainer.viewContext)
            detail.id = imgData[i]["id"] as? String
            detail.author = imgData[i]["author"] as? String
            detail.url = imgData[i]["url"] as? String
            detail.downloadURL = imgData[i]["download_url"] as? String
            detail.height = imgData[i]["height"] as? Int64 ?? 0
            detail.width = imgData[i]["width"] as? Int64 ?? 0
            
            let width = Int(round((UIScreen.main.bounds.size.width)))
            let str = "https://picsum.photos/id/\(imgData[i]["id"] ?? "")/\(width)/250"
            if let imgUrl = URL(string: str) {
                self.getImageData(from: imgUrl) { (data, response, error) in
                    detail.imgData = data
                }
            }
        }
        
        do {
            try appDelegate.persistentContainer.viewContext.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // MARK:  (Async) image URL to Data convert
    
    func getImageData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    // MARK: fetch data from database
    
    func retriveData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return 
        }
        let managedObject = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Detail")
        
        do {
            let result = try managedObject.fetch(fetchRequest)
            //            for data in result as! [Detail] {
            //                print(data.value(forKey: "id") as! String)
            //            }
            offlineOriganlData = result as! [Detail]
            self.filterData()
            print("OFFLINE DATA - \(offlineOriganlData.count)")
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    // MARK: All data delete from database
    
    private func clearData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        do {
            
            let managedObject = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Detail")
            do {
                let objects  = try managedObject.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{managedObject.delete($0)}}
                
                do {
                    try managedObject.save()
                } catch let error {
                    print(error.localizedDescription)
                }
                
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
    
    // MARK: Search (filter) data
    
    func filterData() {
        
        if isInternet {
            
            self.arrData = originalData
            if searchText.count > 0 {
                let filteredData = arrData.compactMap { (model) -> ImageDetails? in
                    if model.author.lowercased().contains(searchText.lowercased()) {
                        return model
                    }
                    return nil
                }
                self.arrData = filteredData
            }
        }
        else {
            self.offlineData = offlineOriganlData
            
            if searchText.count > 0 {
                let filteredData = offlineData.compactMap { (model) -> Detail? in
                    if ((model.author?.lowercased().contains(searchText.lowercased())) != nil) {
                        return model
                    }
                    return nil
                }
                self.offlineData = filteredData
            }
            
        }
    }
    
}

