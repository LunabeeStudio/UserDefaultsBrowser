//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/05/06.
//

import Foundation

private let userDefaultsSystemKeys: [String] = [
    "AddingEmojiKeybordHandled",
    "CarCapabilities",
    "MSVLoggingMasterSwitchEnabledKey",
    "PreferredLanguages",
    "shouldShowRSVPDataDetectors"
]

private let userDefaultsSystemKeyPrefixes: [String] = [
    "Apple",
    "cloud.",
    "com.apple.",
    "internalSettings.",
    "METAL",
    "INNext",
    "AK",
    "_AK",
    "NS",
    "SS",
    "PK",
    "WebKit",
    "mapping_"
]

private let userDefaultsFacebookKeyPrefixes: [String] = [
    "com.facebook"
]

private let userDefaultsFirebaseKeyPrefixes: [String] = [
    "com.fireperf",
    "firebase"
]

struct UserDefaultsContainer: Identifiable {
    var id: String { name }

    let name: String
    let defaults: UserDefaults
    let excludeKeys: (String) -> Bool

    var allKeys: [String] {
        Array(
            defaults.dictionaryRepresentation().keys.exclude {
                isOSSKey($0) || excludeKeys($0)
            }
        )
    }

    var systemKeys: [String] {
        allKeys.filter { isSystemKey($0) }
    }

    var userKeys: [String] {
        allKeys.filter { !isSystemKey($0) && !isFacebookKey($0) && !isFirebaseKey($0) }
    }

    var facebookKeys: [String] {
        allKeys.filter { isFacebookKey($0) == false }
    }

    var firebaseKeys: [String] {
        allKeys.filter { isFirebaseKey($0) == false }
    }

    func extractKeys(of type: UserDefaultsType) -> [String] {
        switch type {
        case .user: return userKeys
        case .system: return systemKeys
        case .facebook: return facebookKeys
        case .firebase: return firebaseKeys
        }
    }

    func removeAll(of type: UserDefaultsType) {
        for key in extractKeys(of: type) {
            defaults.removeObject(forKey: key)
        }
    }

    func lookup(forKey key: String) -> Any? {
        defaults.lookup(forKey: key)
    }

    // MARK: Private

    private func isOSSKey(_ key: String) -> Bool {
        key.hasPrefix(UserDefaults.keyRepository)
    }

    private func isSystemKey(_ key: String) -> Bool {
        userDefaultsSystemKeys.contains(key) ||
            userDefaultsSystemKeyPrefixes.contains { key.hasPrefix($0) }
    }

    private func isFacebookKey(_ key: String) -> Bool {
        userDefaultsFacebookKeyPrefixes.contains { key.hasPrefix($0) }
    }

    private func isFirebaseKey(_ key: String) -> Bool {
        userDefaultsFirebaseKeyPrefixes.contains { key.hasPrefix($0) }
    }
}
