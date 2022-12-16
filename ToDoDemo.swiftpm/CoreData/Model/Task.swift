
import Foundation
import SwiftUI
import CoreData

@objc(Task)
public class Task: NSManagedObject,Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var complete: Bool
    @NSManaged public var priorityNum: Int32
}
