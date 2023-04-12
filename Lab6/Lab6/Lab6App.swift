//
//  Lab6App.swift
//  Lab6
//
//  Created by 贺力 on 3/21/23.
//

import SwiftUI

@main
struct Lab6App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
