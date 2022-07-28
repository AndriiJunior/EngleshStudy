//
//  EnglishStudyApp.swift
//  EnglishStudy
//
//  Created by AndyBrila on 22.06.2022.
//

import SwiftUI

@main
struct EnglishStudyApp: App {
    let persistentContainer = PersistentController.shared
    var body: some Scene {
        WindowGroup{
            
            ContentView().environment(\.managedObjectContext,persistentContainer.container.viewContext)
            
            
                
        }
    }
}
