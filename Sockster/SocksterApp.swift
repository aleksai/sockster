//
//  SocksterApp.swift
//  Sockster
//
//  Created by Alek Sai on 9.10.2022.
//

import SwiftUI

@main
struct SocksterApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }.windowStyle(HiddenTitleBarWindowStyle())
    }
}
