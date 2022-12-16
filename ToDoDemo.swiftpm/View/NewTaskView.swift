import Foundation
import SwiftUI


struct NewTaskView: View {
    @Binding var isShow: Bool
    
    // add data to core data
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var taskName: String = ""
    @State private var isEditing: Bool = false
    var isUpdate = false
    var task: Task? = nil
    var body: some View {
        VStack {
            Spacer()
            
            VStack(alignment: .leading){
                HStack {
                    Text(isUpdate ? "Edit Task":"Add new task")
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    
                    Button(action: {
                        self.isShow = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundColor(.black)
                    }
                }
                
                TextField(isUpdate ? "Update Task Description":"New Task Description", text: self.$taskName, onEditingChanged: {
                    self.isEditing = $0
                })
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.bottom)
                
                Button(action: {
                    guard self.taskName.trimmingCharacters(in: .whitespaces) != "" else {
                        return
                    }
                    
                    self.isShow = false
                    
                    self.addNewTask(name: self.taskName)
                }){
                    Text(isUpdate ? "Update Task":"Add new Task")
                        .font(.system( .title3, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.black)
                }
                .cornerRadius(10)
                .padding(.vertical)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10, antialiased: true)
            .offset(y: self.isEditing ? -320 : 0)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    private func addNewTask(name: String) -> Void {
        if isUpdate {
            if let task = task {
                task.name = name
                do {
                    try viewContext.save()
                    print("view context called")
                }catch {
                    print(error.localizedDescription)
                    print("error called")
                }
            }
        } else {
            let newTask = Task(context: viewContext)
            newTask.id = UUID()
            newTask.name = name
            newTask.complete = false
            
            do {
                try viewContext.save()
                print("view context called")
            }catch {
                print(error.localizedDescription)
                print("error called")
            }
        }
        
        
    }
}
