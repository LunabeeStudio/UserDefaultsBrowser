//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/05/04.
//

import Foundation

extension Dictionary where Key == String, Value == Any {
    static func from(jsonString: String) -> [String: Any]? {
        guard
            let data = jsonString.data(using: .utf8),
            let decoded = try? JSONSerialization.jsonObject(with: data),
            let dictionary = decoded as? [String: Any] else { return nil }

        return dictionary
    }

    var prettyJSON: String {
        do {
            let data = try JSONSerialization.data(
                withJSONObject: self.dictionaryByReplacingDataWithHex(),
                options: [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
            )
            return String(data: data, encoding: .utf8)!
        } catch {
            preconditionFailure(error.localizedDescription)
        }
    }

    var serializedJSON: String? {
        do {
            let data = try JSONSerialization.data(withJSONObject: self.dictionaryByReplacingDataWithHex())
            return String(data: data, encoding: .utf8)
        } catch {
            preconditionFailure(error.localizedDescription)
        }
    }
}

extension Data {
    var hexString: String {
        map { String(format: "%02hhx", $0) }.joined()
    }
}

func replacingDataWithHex(in value: Any) -> Any {
    switch value {
    case let data as Data:
        return data.hexString
    case let dict as [String: Any]:
        return dict.mapValues(replacingDataWithHex(in:))
    case let array as [Any]:
        return array.map(replacingDataWithHex(in:))
    default:
        return value
    }
}

extension [String: Any] {
    func dictionaryByReplacingDataWithHex() -> Self {
        self.mapValues(replacingDataWithHex(in:))
    }
}
