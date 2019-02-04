//
//  ApiClient.swift
//  ario-walking
//
//  Created by subdiox on 2018/12/13.
//  Copyright © 2018 queue-inc. All rights reserved.
//

import Alamofire
import PromiseKit
import SwiftyJSON
import SVProgressHUD

class ApiClient {
    
    enum ApiError: Error {
        case cookie
        case general(Int)
        case decode
    }
    
    class func getApiUrl() -> String {
        return "https://webcatalog-free.circle.ms"
    }
    
    class func post(endpoint: String, params: [String: Any]?) -> Promise<JSON> {
        return Promise { seal in
            SVProgressHUD.show()
            let ud = UserDefaults.standard
            if let cookie = ud.string(forKey: "cookie") {
                let headers: HTTPHeaders = [
                    "Content-Length": "0",
                    "Cookie": cookie
                ]
                let url = getApiUrl() + endpoint
                Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                    SVProgressHUD.dismiss()
                    let statusCode: Int = (response.response?.statusCode)!
                    if statusCode >= 200 && statusCode < 300 {
                        if let result = response.result.value as? [String: Any] {
                            seal.fulfill(JSON(result))
                        } else {
                            seal.reject(ApiError.decode)
                        }
                    } else {
                        if let error = response.error {
                            seal.reject(error)
                        } else {
                            seal.reject(ApiError.general(statusCode))
                        }
                    }
                }
            } else {
                seal.reject(ApiError.cookie)
            }
        }
    }
    
    class func get(endpoint: String, params: [String: Any]?) -> Promise<JSON> {
        return Promise { seal in
            SVProgressHUD.show()
            let ud = UserDefaults.standard
            if let cookie = ud.string(forKey: "cookie") {
                let headers: HTTPHeaders = [
                    "Content-Length": "0",
                    "Cookie": cookie
                ]
                let url = getApiUrl() + endpoint
                Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { response in
                    SVProgressHUD.dismiss()
                    let statusCode: Int = (response.response?.statusCode)!
                    if statusCode >= 200 && statusCode < 300 {
                        if let result = response.result.value as? [String: Any] {
                            seal.fulfill(JSON(result))
                        } else {
                            seal.reject(ApiError.decode)
                        }
                    } else {
                        if let error = response.error {
                            seal.reject(error)
                        } else {
                            seal.reject(ApiError.general(statusCode))
                        }
                    }
                }
            } else {
                seal.reject(ApiError.cookie)
            }
        }
    }
    
    /* ----- for circles ----- */
    
    //{
    //    "A01a": {
    //        "wid": 14200673,
    //        "id": 10318043
    //    },
    //}
    class func getAllCirclesInfo(day: Day, hall: Hall) -> Promise<JSON> {
        let params = [
            "day": day.rawValue,
            "hall": hall.rawValue
        ]
        return get(endpoint: "/Map/GetMapping2", params: params)
    }
    
    //{
    //    "mapcsv": [
    //        {
    //            "isLocationLabel": true,
    //            "hall": "e123",
    //            "locate": [
    //                38,
    //                0
    //            ],
    //            "space": "柱",
    //            "direction": 5
    //        },
    //    ]
    //}
    class func getAllCirclesMap(hall: Hall) -> Promise<JSON> {
        let params = [
            "hall": hall.rawValue
        ]
        return get(endpoint: "/Map/GetMapDataFromExcel", params: params)
    }
    
    //[
    //    {
    //        "genre": "111",
    //        "day": "Day3",
    //        "hall": "e456",
    //        "block": "ト",
    //        "space": "16b"
    //    },
    //]
    class func getAllGenresMap() -> Promise<JSON> {
        return get(endpoint: "/Map/GetGenrePosition2", params: nil)
    }
    
    //{
    //    "Id": 14237740,
    //    "CircleId": 10274492,
    //    "Name": "ちょっと冷めてる",
    //    "Author": "湯冷め",
    //    "IsReject": false,
    //    "Hall": "東",
    //    "Day": "土",
    //    "Block": "Ｗ",
    //    "Space": "05a",
    //    "Loc": 0,
    //    "Genre": "ラブライブ！",
    //    "CircleCutUrl": "https://webcatalogj07.blob.core.windows.net/c95imgthm/223c8754-4530-47e8-93eb-b409a5f6b0a1.png?sv=2016-05-31&sr=c&sig=trzSnvhhUh9BU9EBYljdD%2BCEoqA6F%2B1Tj8b8jajUQHk%3D&se=2019-01-12T15%3A30%3A59Z&sp=r",
    //    "IsNew": false,
    //    "IsOnlineBooksRegistered": false,
    //    "IsPixivRegistered": true,
    //    "PixivUrl": "http://www.pixiv.net/member.php?id=1346402",
    //    "IsTwitterRegistered": true,
    //    "TwitterUrl": "https://twitter.com/SuiMony_Hz",
    //    "IsNiconicoRegistered": false,
    //    "NiconicoUrl": "",
    //    "HasKokutiImage": false,
    //    "HasHanpuImage": false,
    //    "WebSite": "",
    //    "Description": ""
    //}
    class func getCircleDetail(id: Int) -> Promise<JSON> {
        return post(endpoint: "/Circle/\(id)/DetailJson", params: nil)
    }
    
    /* ----- for company booths ----- */
    
    //{
    //    "boothList": [
    //        {
    //            "Id": 1423111,
    //            "X1": 570,
    //            "Y1": 1080,
    //            "X2": 600,
    //            "Y2": 1140,
    //            "Scale": 30,
    //            "Number": 3111,
    //            "AreaName": "c1",
    //            "Label": true
    //        },
    //    ]
    //}
    class func getAllBoothsMap() -> Promise<JSON> {
        return post(endpoint: "/Map/GetBoothPosition", params: nil)
    }
    
    //{
    //    "Id": 1424211,
    //    "Name": "GEE!STORE",
    //    "CutUrl": "https://webcatalogj07.blob.core.windows.net/c95imgdef/d95ef3d6-0f84-4471-b879-25b8b0cfa335.png?sv=2016-05-31&sr=c&sig=rGPYG0kzwwH6ZK%2BGO4sOHOGfQ9zFAd7BVYjT9wM3uYY%3D&se=2019-01-12T15%3A30%3A59Z&sp=r",
    //    "Description": "「ラブライブ！サンシャイン!!」描きおろしイラストグッズなど",
    //    "Number": 4211,
    //    "SellingInfo": "「ラブライブ！サンシャイン!!」Aqoursメンバーの両面フルグラT ゴスロリver.はじめ、「ゆるキャン△」「HUGっと！プリキュア」商品など多数販売"
    //}
    class func getBoothDetail(id: Int) -> Promise<JSON> {
        return post(endpoint: "/Booth/\(id)", params: nil)
    }
}
