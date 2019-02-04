//
//  DetailViewController.swift
//  comicatalog
//
//  Created by subdiox on 2019/01/13.
//  Copyright © 2019 Yuta Ooka. All rights reserved.
//

import UIKit
import SwiftyJSON
import AlamofireImage

class DetailViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    var detailJson: JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        print(detailJson)
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell")!
        switch (indexPath.row) {
        case 0:
            cell.textLabel?.text = ""
            cell.detailTextLabel?.text = ""
            if let url = URL(string: detailJson["CircleCutUrl"].stringValue) {
                let imageView = UIImageView(frame: CGRect(x: cell.contentView.frame.size.width / 2 - 90, y: 0, width: 180, height: 256))
                imageView.af_setImage(withURL: url)
                cell.contentView.addSubview(imageView)
            }
        case 1:
            cell.textLabel?.text = "サークル名"
            cell.detailTextLabel?.text = detailJson["Name"].stringValue
        case 2:
            cell.textLabel?.text = "著者"
            cell.detailTextLabel?.text = detailJson["Author"].stringValue
        case 3:
            cell.textLabel?.text = "ジャンル"
            cell.detailTextLabel?.text = detailJson["Genre"].stringValue
        case 4:
            cell.textLabel?.text = "日にち"
            cell.detailTextLabel?.text = detailJson["Day"].stringValue
        case 5:
            cell.textLabel?.text = "場所"
            cell.detailTextLabel?.text = "\(detailJson["Hall"].stringValue) \(detailJson["Block"].stringValue)\(detailJson["Space"].stringValue)"
        case 6:
            cell.textLabel?.text = "説明"
            cell.detailTextLabel?.text = detailJson["Description"].stringValue
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.row) {
        case 0:
            return 256
        default:
            break
        }
        return 44
    }
}

