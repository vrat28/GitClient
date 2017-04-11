//
//  ViewController.swift
//  GitClient
//
//  Created by Varun Rathi on 11/04/17.
//  Copyright © 2017 vrat28. All rights reserved.
//

import UIKit
import ESPullToRefresh
import SwiftSpinner

class ViewController: UIViewController {

    @IBOutlet weak var tableView:UITableView!
    var dataSource:[CommitModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
      //  loadDummyData()
        
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.es_addPullToRefresh {
            [weak self] in
            /// Do anything you want...
            /// ...
            /// Stop refresh when your job finished, it will reset refresh footer if completion is true
            self?.tableView.es_stopPullToRefresh(ignoreDate: true)
            /// Set ignore footer or not
            self?.tableView.es_stopPullToRefresh(ignoreDate: true, ignoreFooter: false)
        }

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
   
        SwiftSpinner.show("Fetching Commits...")
        let networkService = NetworkService.sharedInstance
        networkService.delegate = self
        networkService.sendRequestForBranches()
        
        
    }

    // Test function
//    func loadDummyData()
//    {
//        let commit1 = CommitModel(userName: "VarunRathi", commitName: "Sample Commit", commitMessage: "Description")
//        let commit2 = CommitModel(userName: "abcd", commitName: "Sample Commit", commitMessage: "Description")
//        let commit3 = CommitModel(userName: "sdsd", commitName: "Sample Commit", commitMessage: "Description")
//     
//        
//        dataSource.append(commit1)
//        dataSource.append(commit2)
//        dataSource.append(commit3)
//    }
//    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController : UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:Constants.UserCellIdentifier, for: indexPath) as! CustomCommitCell
        
        let commit = dataSource[indexPath.row]
        cell.updateCell(with: commit)
        return cell
    }
    
}

extension ViewController: UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension ViewController : ServiceHitDelegate
{
    func didRecievedResponse(response: [CommitModel]) {
        
        dataSource = response
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            SwiftSpinner.hide()
        }
        
        
    }
    
}

