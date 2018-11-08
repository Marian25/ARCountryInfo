//
//  SideMenuViewController.swift
//  ARCountryInfo
//
//  Created by Marian Stanciulica on 08/11/2018.
//  Copyright © 2018 Marian Stanciulica. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let data = ["Geography", "History", "Economy"]
    var checkedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if (checkedIndex == indexPath.row) {
            cell.accessoryType = .checkmark
        }
        
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        checkedIndex = indexPath.row
        dismiss(animated: true, completion: nil)
    }
    

}
