//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/30.
//

import SwiftUI

public struct UserDefaultsBrowserView: View {
    // 💡 iOS 15+: `\.dismiss`
    @Environment(\.presentationMode) private var presentationMode

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
            defaults: .standard,
            excludeKeys: { _ in false } // TODO: To fix using user excluding keys.
        )

        return [standard] + suiteNames.compactMap { name in
            UserDefaults(suiteName: name).map {
                UserDefaultsContainer(
                    name: name,
                    defaults: $0,
                    excludeKeys: { _ in false } // TODO: To fix using user excluding keys.
                )
            }
        }
    }

    public var body: some View {
        Group {
            if presentationMode.wrappedValue.isPresented {
                TabView {
                    //
                    // 􀉩 User
                    //
                    tabContent(title: "User") {
                        SearchContainerView(type: .user(), defaults: defaults)
                    }
                    .tabItem {
                        Label("User", systemImage: "person")
                    }

                    //
                    // 􀟜 Firebase
                    //
                    tabContent(title: "Firebase") {
                        SearchContainerView(type: .firebase, defaults: defaults)
                    }
                    .tabItem {
                        Label("Firebase", systemImage: "iphone")
                    }

                    //
                    // 􀟜 Facebook
                    //
                    tabContent(title: "Facebook") {
                        SearchContainerView(type: .facebook, defaults: defaults)
                    }
                    .tabItem {
                        Label("Facebook", systemImage: "iphone")
                    }

                    //
                    // 􀟜 System
                    //
                    tabContent(title: "System") {
                        SearchContainerView(type: .system, defaults: defaults)
                    }
                    .tabItem {
                        Label("System", systemImage: "iphone")
                    }
                }
            } else {
                List {
                    //
                    // 􀉩 User
                    //
                    NavigationLink {
                        SearchContainerView(type: .user(), defaults: defaults)
                            .navigationTitle("User")
                    } label: {
                        Label("User", systemImage: "person")
                    }

                    //
                    // 􀟜 Firebase
                    //
                    NavigationLink {
                        SearchContainerView(type: .firebase, defaults: defaults)
                            .navigationTitle("Firebase")
                    } label: {
                        Label("Firebase", systemImage: "iphone")
                    }

                    //
                    // 􀟜 Facebook
                    //
                    NavigationLink {
                        SearchContainerView(type: .facebook, defaults: defaults)
                            .navigationTitle("Facebook")
                    } label: {
                        Label("Facebook", systemImage: "iphone")
                    }

                    //
                    // 􀟜 System
                    //
                    NavigationLink {
                        SearchContainerView(type: .system, defaults: defaults)
                            .navigationTitle("System")
                    } label: {
                        Label("System", systemImage: "iphone")
                    }
                }
                .navigationTitle("UserDefaults Browser")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .accentColor(accentColor)
        .environment(\.customAccentColor, accentColor)
    }

    private func tabContent(title: String, content: () -> SearchContainerView) -> some View {
        NavigationView {
            content()
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button("Done") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
        }
        .navigationViewStyle(.stack)
    }
}
