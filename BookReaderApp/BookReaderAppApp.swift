//
//  BookReaderAppApp.swift
//  BookReaderApp
//
//  Created by Mahesh De Silva on 2023-10-19.
//

import SwiftUI

@main
struct BookReaderAppApp: App {
    let dependencyProvider = AppDIContainer()
    var body: some Scene {
        WindowGroup {
            HomeView(dependencyProvider: dependencyProvider)
        }
    }
}
