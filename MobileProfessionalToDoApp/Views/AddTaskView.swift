import SwiftUI

struct AddEditTaskView: View {
    @Environment(\.dismiss) var dismiss

    @ObservedObject var viewModel: TaskListViewModel
    @State var task: Task?

    @State private var title = ""
    @State private var description = ""
    @State private var urgency = TaskUrgency.medium
    @State private var status = TaskStatus.todo

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Informações")) {
                    TextField("Título", text: $title)
                    TextField("Descrição", text: $description)
                }

                Section(header: Text("Urgência")) {
                    Picker("Urgência", selection: $urgency) {
                        ForEach(TaskUrgency.allCases) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Status")) {
                    Picker("Status", selection: $status) {
                        ForEach(TaskStatus.allCases) { state in
                            Text(state.rawValue).tag(state)
                        }
                    }
                }
            }
            .navigationTitle(task == nil ? "Nova Tarefa" : "Editar Tarefa")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salvar") {
                        let newTask = Task(
                            id: task?.id ?? UUID(),
                            title: title,
                            description: description,
                            urgency: urgency,
                            status: status
                        )

                        if task == nil {
                            viewModel.addTask(title: title, description: description, urgency: urgency, status: status)
                        } else {
                            viewModel.updateTask(newTask)
                        }

                        dismiss()
                    }
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            if let task = task {
                title = task.title
                description = task.description
                urgency = task.urgency
                status = task.status
            }
        }
    }
}
