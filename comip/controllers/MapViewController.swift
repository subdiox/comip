//
//  CatalogViewController.swift
//  comicatalog
//
//  Created by subdiox on 2019/01/12.
//  Copyright © 2019 Yuta Ooka. All rights reserved.
//

import UIKit
import Alertift

class MapViewController: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var contentView: UIView!
    @IBOutlet var contentViewWidth: NSLayoutConstraint!
    @IBOutlet var contentViewHeight: NSLayoutConstraint!
    
    let blockSize: CGFloat = 20
    let spaceSize: CGFloat = 40
    let borderWidth: CGFloat = 0.5
    var day = Day.day1
    var hall = Hall.e123
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.parent?.navigationItem.title = "会場マップ"
        reloadNavigationBar()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadContentView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.delegate = self
        scrollView.maximumZoomScale = 8.0
        scrollView.minimumZoomScale = 1.0
    }
    
    @objc func blockButtonTapped(_ button: BlockButton) {
        if let space = button.stringValue {
            Alertift.actionSheet(title: "スペース", message: "サークルスペースを選択してください")
            .actions(["\(space)a", "\(space)b"])
            .action(.cancel("キャンセル"))
            .finally { action, index in
                if action.style != .cancel {
                    self.retrieveCircleDetail(of: action.title!)
                }
            }.show(on: self)
        }
    }
    
    @objc func dayButtonTapped(_ button: UIBarButtonItem) {
        Alertift.actionSheet(title: "日にち", message: "日にちを選択してください")
        .action(.default(Day.day1.toLocalizedString())) { _, _ in
            self.day = .day1
            self.reloadNavigationBar()
        }.action(.default(Day.day2.toLocalizedString())) { _, _ in
            self.day = .day2
            self.reloadNavigationBar()
        }.action(.default(Day.day3.toLocalizedString())) { _, _ in
            self.day = .day3
            self.reloadNavigationBar()
        }.action(.cancel("キャンセル")).show(on: self)
    }
    
    @objc func hallButtonTapped(_ button: UIBarButtonItem) {
        Alertift.actionSheet(title: "ホール名", message: "ホール名を選択してください")
        .action(.default(Hall.e123.toLocalizedString())) { _, _ in
            self.hall = .e123
            self.reloadNavigationBar()
            self.reloadContentView()
        }.action(.default(Hall.e456.toLocalizedString())) { _, _ in
            self.hall = .e456
            self.reloadNavigationBar()
            self.reloadContentView()
        }.action(.default(Hall.w12.toLocalizedString())) { _, _ in
            self.hall = .w12
            self.reloadNavigationBar()
            self.reloadContentView()
        }.action(.cancel("キャンセル")).show(on: self)
    }
    
    func reloadNavigationBar() {
        self.parent?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: day.toLocalizedString(), style: .plain, target: self, action: #selector(dayButtonTapped(_:)))
        self.parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: hall.toLocalizedString(), style: .plain, target: self, action: #selector(hallButtonTapped(_:)))
    }
    
    func reloadContentView() {
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        ApiClient.getAllCirclesMap(hall: hall).done { json in
            var maxX: CGFloat = 0
            var maxY: CGFloat = 0
            for circle in json["mapcsv"].arrayValue {
                let x = circle["locate"][0].intValue
                let y = circle["locate"][1].intValue
                if CGFloat(x) > maxX {
                    maxX = CGFloat(x)
                }
                if CGFloat(y) > maxY {
                    maxY = CGFloat(y)
                }
                let space = circle["space"].stringValue
                if !circle["isLocationLabel"].boolValue {
                    let button = BlockButton(frame: CGRect(
                        x: self.spaceSize + CGFloat(x) * self.blockSize - self.borderWidth,
                        y: self.spaceSize + CGFloat(y) * self.blockSize - self.borderWidth,
                        width: self.blockSize + self.borderWidth * 2,
                        height: self.blockSize + self.borderWidth * 2
                    ))
                    button.setTitle(String(space[space.index(after: space.startIndex)..<space.endIndex]), for: .normal)
                    button.stringValue = space
                    button.addTarget(self, action: #selector(self.blockButtonTapped(_:)), for: .touchUpInside)
                    button.titleLabel?.adjustsFontSizeToFitWidth = true
                    button.layer.borderWidth = self.borderWidth * 2
                    button.layer.borderUIColor = UIColor.black
                    self.contentView.addSubview(button)
                } else if space.starts(with: "sp") && !space.starts(with: "sps") {
                    let label = UILabel(frame: CGRect(
                        x: self.spaceSize + CGFloat(x - 1) * self.blockSize,
                        y: self.spaceSize + CGFloat(y - 1) * self.blockSize,
                        width: self.blockSize * 2,
                        height: self.blockSize * 2
                    ))
                    label.text = String(space.suffix(space.count - 2))
                    label.font = UIFont.systemFont(ofSize: 30)
                    label.textAlignment = .center
                    self.contentView.addSubview(label)
                }
            }
            self.contentViewWidth.constant = maxX * self.blockSize + self.spaceSize * 3
            self.contentViewHeight.constant = maxY * self.blockSize + self.spaceSize * 3
        }.catch{ error in
            print(error)
        }
    }
    
    func retrieveCircleDetail(of space: String) {
        ApiClient.getAllCirclesInfo(day: self.day, hall: self.hall).done { json in
            let wid = json[space]["wid"].intValue
            ApiClient.getCircleDetail(id: wid).done { detailJson in
                let detailViewController = self.storyboard!.instantiateViewController(withIdentifier: "Detail") as! DetailViewController
                detailViewController.detailJson = detailJson
                self.navigationController?.pushViewController(detailViewController, animated: true)
            }.catch{ error in
                print(error)
            }
        }.catch{ error in
            print(error)
        }
    }
}

extension MapViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }
}
