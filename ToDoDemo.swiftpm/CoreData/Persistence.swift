import Foundation
import CoreData


import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        
        //creating entity
        let taskEntity  = NSEntityDescription()
        taskEntity.name = "Task"
        taskEntity.managedObjectClassName = "Task"
        
        
        //now creating the attributes and append them to task entity
        let idAttribute = NSAttributeDescription()
        idAttribute.name = "id"
        idAttribute.type = .uuid
        taskEntity.properties.append(idAttribute)
        
        
        let nameAttribute = NSAttributeDescription()
        nameAttribute.name = "name"
        nameAttribute.type = .string
        taskEntity.properties.append(nameAttribute)
        
        let completeAttribute = NSAttributeDescription()
        completeAttribute.name = "complete"
        completeAttribute.type = .boolean
        taskEntity.properties.append(completeAttribute)
        
        let priorityNumAttribute = NSAttributeDescription()
        priorityNumAttribute.name = "priorityNum"
        priorityNumAttribute.type = .integer32
        taskEntity.properties.append(priorityNumAttribute)
        
        
        //create coredata model
        
        let model = NSManagedObjectModel()
        model.entities  = [taskEntity]
        
        container = NSPersistentContainer(name: "TaskToDo", managedObjectModel: model)
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
