//
//  Binding+.swift
//
//
//  Created by Nicolas Dominati on 2026/10/08.
//

import CasePaths
import SwiftUI

extension Binding {
    //
    // `Binding<Value>` -> `Binding<NewValue>`
    //
    func map<NewValue>(get: @escaping (Value) -> NewValue, set: @escaping (NewValue) -> Value) -> Binding<NewValue> {
        .init(
            get: { get(wrappedValue) },
            set: { wrappedValue = set($0) }
        )
    }

    //
    // `Binding<Enum>` -> `Binding<AssociatedValue>?`
    //
    func `case`<AssociatedValue>(_ path: CasePath<Value, AssociatedValue>) -> Binding<AssociatedValue>? {
        if let value = path.extract(from: wrappedValue) {
            return .init(
                get: { value },
                set: { wrappedValue = path.embed($0) }
            )
        } else {
            return nil
        }
    }
}
