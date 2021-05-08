//
//  ViewController.swift
//  Hubilo_Task
//
//  Created by Raj Gajera on 08/05/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            self.collectionView.register(UINib.init(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCollectionViewCell")
            collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
            self.tableView.register(UINib.init(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableViewCell")
            tableView.delegate = self
            tableView.dataSource = self
        }
    }

    @IBOutlet weak var barButton: UIBarButtonItem!
    var searchBar: UISearchBar!
    var viewModel: ImageListViewModel!
    let indicator = UIActivityIndicatorView(style: .large)
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.center = view.center
        view.addSubview(indicator)

        viewModel = ImageListViewModel(self)
        searchBar = UISearchBar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 100, height: 20))
        searchBar.placeholder = "Seach by Author Name"
        searchBar.delegate = self
        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !viewModel.isInternet {
            self.viewModel.retriveData()
            self.tableView.reloadData()
            self.collectionView.reloadData()
        }

    }
    
    // MARK: Layout change button action (UIbarButton Action)
    
    @IBAction func btnPressed(button: UIBarButtonItem) {
        self.view.endEditing(true)
        if button.title == "Grid" {
            tableView.isHidden = true
            collectionView.isHidden = false
            button.title = "List"
        }
        else {
            button.title = "Grid"
            tableView.isHidden = false
            collectionView.isHidden = true
        }
    }
    
}

//MARK: ImageListViewModelDelegate

extension ViewController: ImageListViewModelDelegate {
    func APISuccess() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.collectionView.reloadData()
        }
    }
    func APIFailure(message: String) {
        print(message)
    }
}

// MARK: UISearchBarDelegate

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel.searchText = searchText
        self.tableView.reloadData()
        self.collectionView.reloadData()
    }
    
}

//MARK: UITableViewDataSource, UITableViewDelegate

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        
        if (AppDelegate.shared.isInternetAvailable) {
            return self.viewModel.arrData.count
        }
        else {
            return self.viewModel.offlineData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        
        if (AppDelegate.shared.isInternetAvailable) {
            if let object = self.viewModel?.arrData[indexPath.row] {
                cell.data = object
            }
        }
        else {
            if let object = self.viewModel?.offlineData[indexPath.row] {
                cell.offlineData = object
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
        
        if (AppDelegate.shared.isInternetAvailable) {
            vc.imgInfo = self.viewModel.arrData[indexPath.row]
        }
        else {
            vc.offlineData = self.viewModel.offlineData[indexPath.row]
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if (AppDelegate.shared.isInternetAvailable) {
            if indexPath.row == (self.viewModel.arrData.count - 1) && viewModel.isAPICalling == false && self.viewModel.searchText == "" && tableView.isHidden == false {
                viewModel.currentPage = viewModel.currentPage + 1
                viewModel.getImageData(page: viewModel.currentPage, limit: 10)
            }
        }
    }
}

// MARK: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (AppDelegate.shared.isInternetAvailable) {
            return self.viewModel.arrData.count
        }
        else {
            return self.viewModel.offlineData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        if (AppDelegate.shared.isInternetAvailable) {
            cell.data = self.viewModel.arrData[indexPath.row]
        }
        else {
            cell.offlineData = self.viewModel.offlineData[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (AppDelegate.shared.isInternetAvailable) {
            if indexPath.row == (self.viewModel.arrData.count - 1) && viewModel.isAPICalling == false && self.viewModel.searchText == "" && collectionView.isHidden == false {
                viewModel.currentPage = viewModel.currentPage + 1
                viewModel.getImageData(page: viewModel.currentPage, limit: 10)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
        if (AppDelegate.shared.isInternetAvailable) {
            vc.imgInfo = self.viewModel.arrData[indexPath.row]
        }
        else {
            vc.offlineData = self.viewModel.offlineData[indexPath.row]
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.size.width-41)/3, height: 200)
    }
}
