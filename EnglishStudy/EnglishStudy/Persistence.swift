//
//  Persistence.swift
//  EnglishStudy
//
//  Created by AndyBrila on 27.06.2022.
//

import Foundation
import CoreData
struct PersistentController{
static let shared = PersistentController()
let container: NSPersistentContainer
init(){
container = NSPersistentContainer(name: "UsersWordData" )
container.loadPersistentStores(completionHandler: {(storeDescription, error) in
if let error = error as NSError? {
fatalError("unresolved error:\(error)")
    }
  })
 }
}
