//
//  Enums.swift
//  comicatalog
//
//  Created by subdiox on 2019/01/13.
//  Copyright © 2019 Yuta Ooka. All rights reserved.
//

import Foundation

enum Day: String {
    case day1 = "Day1"
    case day2 = "Day2"
    case day3 = "Day3"
}

extension Day {
    func toLocalizedString() -> String {
        switch (self) {
        case .day1:
            return "1日目"
        case .day2:
            return "2日目"
        case .day3:
            return "3日目"
        }
    }
}

enum Hall: String {
    case e123 = "e123"
    case e456 = "e456"
    case w12 = "w12"
}

extension Hall {
    func toLocalizedString() -> String {
        switch (self) {
        case .e123:
            return "東123"
        case .e456:
            return "東456"
        case .w12:
            return "西12"
        }
    }
}
