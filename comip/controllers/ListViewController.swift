//
//  ListViewController.swift
//  comicatalog
//
//  Created by subdiox on 2019/01/13.
//  Copyright © 2019 Yuta Ooka. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.parent?.navigationItem.title = "サークル一覧"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
