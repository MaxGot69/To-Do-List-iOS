//
//  To_Do_ListApp.swift
//  To Do List
//
//  Created by Maxim Gotovchenko on 03.08.2025.
//

import SwiftUI

@main
struct To_Do_ListApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
