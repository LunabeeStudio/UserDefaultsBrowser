//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/30.
//

import SwiftUI

public struct UserDefaultsBrowserView: View {
    private let suiteNames: [String]
    private let accentColor: Color

    public init(
        suiteNames: [String] = [],
        types: [UserDefaultsType] = [.user()],
        accentColor: Color = .accentColor
    ) {
        self.suiteNames = suiteNames
        self.accentColor = accentColor
    }

    private var defaults: [UserDefaultsContainer] {
        let standard = UserDefaultsContainer(
            name: "Standard",
            defaults: .standard
        )

        return [standard] + suiteNames.compactMap { name in
            UserDefaults(suiteName: name).map {
                UserDefaultsContainer(
                    name: name,
                    defaults: $0
                )
            }
        }
    }

    public var body: some View {
        Group {
            List {
                //
                // 􀉩 User
                //
                NavigationLink {
                    SearchContainerView(type: .user(), defaults: defaults)
                        .navigationTitle("User")
                } label: {
                    Label("User keys", systemImage: "person")
                }

                //
                // 􀟜 Firebase
                //
                NavigationLink {
                    SearchContainerView(type: .firebase, defaults: defaults)
                        .navigationTitle("Firebase")
                } label: {
                    Label("Firebase keys", systemImage: "iphone")
                }

                //
                // 􀟜 Facebook
                //
                NavigationLink {
                    SearchContainerView(type: .facebook, defaults: defaults)
                        .navigationTitle("Facebook")
                } label: {
                    Label("Facebook keys", systemImage: "iphone")
                }

                //
                // 􀟜 System
                //
                NavigationLink {
                    SearchContainerView(type: .system, defaults: defaults)
                        .navigationTitle("System")
                } label: {
                    Label("System keys", systemImage: "iphone")
                }
            }
            .navigationTitle("UserDefaults Browser")
            .navigationBarTitleDisplayMode(.inline)
        }
        .accentColor(accentColor)
        .environment(\.customAccentColor, accentColor)
    }
}
