//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/05/06.
//

import Foundation

public enum UserDefaultsType {
    case user(excludeKeys: (String) -> Bool = { _ in false })
    case system
    case facebook
    case firebase

    var name: String {
        switch self {
        case .user(let excludeKeys):
            "User"
        case .system:
            "System"
        case .facebook:
            "Facebook"
        case .firebase:
            "Firebase"
        }
    }
}
