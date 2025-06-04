//
//  Nutrify_AIApp.swift
//  Nutrify AI
//
//  Created by EMRE MATARACI on 4.06.2025.
//

import SwiftUI

@main
struct Nutrify_AIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
