import Foundation
import SwiftUI

struct TaskListRow: View {
    @ObservedObject var task: Task
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        Toggle(isOn: self.$task.complete){
            HStack {
                Text(self.task.name)
                    .fontWeight(.bold)
            }
        }
        .toggleStyle(CheckBoxStyle(taskColor: .black))
        .onReceive(self.task.objectWillChange){_ in
            if self.viewContext.hasChanges {
                try? self.viewContext.save()
            }
        }
    }
}
