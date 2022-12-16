import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Task.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Task.priorityNum, ascending: false)
                  ], animation: .default)
    
    var tasks: FetchedResults<Task>
    
    
    @State private var showNewTask: Bool = false
    @State private var updateTask: Bool = false
    @State var selectedTask: Task? = nil
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(tasks.filter({!$0.complete})){ task in
                        TaskListRow(task: task)
                            .onTapGesture {
                                self.selectedTask = task
                                self.updateTask = true
                            }
                    }
                    .onDelete(perform: deleteTask)
                    .onMove(perform: move)
                    
                }
                if tasks.count == 0 {
                    Image("no-data")
                        .resizable()
                        .scaledToFit()
                        .padding()
                }
                
                if self.showNewTask || self.updateTask {
                    BlankView()
                        .onTapGesture {
                            self.showNewTask = false
                        }
                    if self.showNewTask {
                        NewTaskView(isShow: self.$showNewTask)
                            .transition(.move(edge: .bottom))
                            .animation(.default, value: self.showNewTask)
                    }
                    if self.updateTask {
                        NewTaskView(isShow: self.$updateTask,isUpdate:true, task: selectedTask)
                            .transition(.move(edge: .bottom))
                            .animation(.default, value: self.updateTask)
                    }
                }
                
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        self.showNewTask = true
                        print("tap button add")
                    }){
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.black)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing){
                    EditButton()
                        .foregroundColor(.blue)
                        .opacity(self.tasks.count == 0 ? 0.5 : 1)
                        .disabled(self.tasks.count == 0)
                }
                
            }
        }
            .navigationViewStyle(.stack)
    }
    
    func move(from source: IndexSet, to destination: Int) {
        
    }
    
    private func deleteTask(index: IndexSet) -> Void {
        withAnimation {
            index.map{tasks[$0]}.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            }catch{
                let nsError = error as NSError
                fatalError("Unresolved Error \(nsError.localizedDescription), \(nsError.userInfo)")
            }
        }
    }
}
