import SwiftUI

struct TaskListView: View {
    @StateObject var viewModel = TaskListViewModel()
    @State private var showAdd = false

    var body: some View {
        NavigationView {
            List {
                taskSection(for: .todo, title: "A Fazer", color: .red)
                taskSection(for: .inProgress, title: "Em Andamento", color: .orange)
                taskSection(for: .done, title: "Pronto", color: .green)
            }
            .navigationTitle("Tarefas")
            .toolbar {
                Button(action: { showAdd = true }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showAdd) {
                AddEditTaskView(viewModel: viewModel)
            }
        }
    }

    func taskSection(for status: TaskStatus, title: String, color: Color) -> some View {
        let filteredTasks = viewModel.tasks
            .filter { $0.status == status }
            .sorted(by: urgencySort)

        return Section(header: Text(title).foregroundColor(color)) {
            if filteredTasks.isEmpty {
                Text("Nenhuma tarefa").italic().foregroundColor(.gray)
            } else {
                ForEach(filteredTasks) { task in
                    NavigationLink(destination: TaskDetailView(task: task, viewModel: viewModel)) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(task.title).bold()
                            Text(task.urgency.rawValue)
                                .font(.caption)
                                .foregroundColor(colorForUrgency(task.urgency))
                        }
                    }
                }
            }
        }
    }

    func urgencySort(_ t1: Task, _ t2: Task) -> Bool {
        let order: [TaskUrgency] = [.high, .medium, .low]
        return order.firstIndex(of: t1.urgency)! < order.firstIndex(of: t2.urgency)!
    }

    func colorForUrgency(_ urgency: TaskUrgency) -> Color {
        switch urgency {
        case .high: return .red
        case .medium: return .orange
        case .low: return .gray
        }
    }
}
